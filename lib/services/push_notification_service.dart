import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase_options.dart';
import 'push_preferences.dart';
import 'push_register_service.dart';
import 'push_topics.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Data handled when user opens the notification.
}

/// FCM topic sync from [PushPreferences] + notification open handling.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  bool _ready = false;
  PushPreferences prefs = PushPreferences();
  final Set<String> _subscribed = {};
  StreamSubscription<String>? _tokenRefreshSub;
  Timer? _tokenRetryTimer;
  var _tokenRetryAttempt = 0;

  bool get masterEnabled => prefs.masterEnabled;

  Future<void> initialize() async {
    if (kIsWeb) return;
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)) {
      return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    prefs = await PushPreferences.load();

    final messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen(openFromMessage);
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      unawaited(openFromMessage(initial));
    }

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = messaging.onTokenRefresh.listen((token) {
      unawaited(registerPushToken(tokenOverride: token));
    });

    if (prefs.masterEnabled) {
      await syncTopics();
    }
    // Always upsert user row on launch (token only when master is on).
    unawaited(registerPushToken());
    _ready = true;
  }

  void _scheduleTokenRetryIfNeeded({required String? token}) {
    _tokenRetryTimer?.cancel();
    if (!prefs.masterEnabled) {
      _tokenRetryAttempt = 0;
      return;
    }
    if (token != null && token.isNotEmpty) {
      _tokenRetryAttempt = 0;
      return;
    }
    // Simulator / cold APNs: keep retrying a few times; real devices usually
    // succeed via onTokenRefresh or within these attempts.
    if (_tokenRetryAttempt >= 8) return;
    _tokenRetryAttempt += 1;
    final delay = Duration(seconds: 2 * _tokenRetryAttempt);
    debugPrint(
      '[push] FCM token missing — retry #$_tokenRetryAttempt in ${delay.inSeconds}s'
      '${defaultTargetPlatform == TargetPlatform.iOS ? ' (simulator often has no APNs)' : ''}',
    );
    _tokenRetryTimer = Timer(delay, () {
      unawaited(registerPushToken());
    });
  }

  Future<bool> setMasterEnabled(bool value) async {
    await _ensureReady();
    if (kIsWeb) return false;

    String? token;
    if (value) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final ok =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!ok) {
        prefs.masterEnabled = false;
        await prefs.save();
        await syncTopics();
        unawaited(registerPushToken());
        return false;
      }
      token = await _resolveFcmToken();
    }

    prefs.masterEnabled = value;
    await prefs.save();
    await syncTopics();
    await registerPushToken(tokenOverride: token);
    return value;
  }

  Future<void> setCategory(PushCategory category, bool enabled) async {
    await _ensureReady();
    if (enabled) {
      prefs.categories.add(category);
    } else {
      prefs.categories.remove(category);
    }
    await prefs.save();
    if (prefs.masterEnabled) await syncTopics();
  }

  Future<void> setExchange(PushExchange exchange, bool enabled) async {
    await _ensureReady();
    if (enabled) {
      prefs.exchanges.add(exchange);
    } else {
      prefs.exchanges.remove(exchange);
    }
    await prefs.save();
    if (prefs.masterEnabled) await syncTopics();
  }

  /// Upsert FCM token + prefs into Supabase via Railway.
  Future<void> registerPushToken({String? tokenOverride}) async {
    if (kIsWeb) return;
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)) {
      return;
    }

    String? token = tokenOverride;
    if (prefs.masterEnabled && (token == null || token.isEmpty)) {
      token = await _resolveFcmToken();
    }

    final locale = PlatformDispatcher.instance.locale.languageCode;
    final ok = await PushRegisterService.instance.upsert(
      pushEnabled: prefs.masterEnabled,
      pushToken: token,
      locale: locale,
    );
    if (!ok) {
      debugPrint(
        '[push] register failed (check Railway SUPABASE_* env + API logs)',
      );
    }
    _scheduleTokenRetryIfNeeded(token: token);
  }

  /// iOS needs an APNs token before FCM `getToken` succeeds.
  Future<String?> _resolveFcmToken() async {
    final messaging = FirebaseMessaging.instance;
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        String? apns = await messaging.getAPNSToken();
        for (var i = 0; i < 15 && (apns == null || apns.isEmpty); i++) {
          await Future<void>.delayed(const Duration(milliseconds: 400));
          apns = await messaging.getAPNSToken();
        }
        if (apns == null || apns.isEmpty) {
          debugPrint(
            '[push] APNs token not ready yet '
            '(common on iOS Simulator — use a real device for FCM token)',
          );
          return null;
        }
      }
      return await messaging.getToken();
    } catch (e) {
      debugPrint('[push] getToken failed: $e');
      return null;
    }
  }

  /// Subscribe/unsubscribe so local prefs match FCM topics.
  Future<void> syncTopics() async {
    if (kIsWeb) return;
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)) {
      return;
    }

    final messaging = FirebaseMessaging.instance;
    final desired = prefs.desiredTopics();
    final allKnown = {...PushTopics.allCategory, ...PushTopics.allExchange};

    for (final topic in allKnown) {
      final want = desired.contains(topic);
      if (want) {
        if (_subscribed.contains(topic)) continue;
        try {
          await messaging.subscribeToTopic(topic);
          _subscribed.add(topic);
        } catch (e) {
          debugPrint('[push] subscribe $topic failed: $e');
        }
      } else {
        // Always unsubscribe when not desired (covers app restart with empty
        // in-memory set — FCM keeps prior subscriptions until cleared).
        try {
          await messaging.unsubscribeFromTopic(topic);
        } catch (e) {
          debugPrint('[push] unsubscribe $topic failed: $e');
        }
        _subscribed.remove(topic);
      }
    }
  }

  Future<void> openFromMessage(RemoteMessage message) async {
    final url = message.data['url']?.toString().trim() ?? '';
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _ensureReady() async {
    if (!_ready && !kIsWeb) {
      await initialize();
    }
  }
}
