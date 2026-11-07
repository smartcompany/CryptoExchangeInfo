import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import 'push_digest_copy.dart';
import 'push_preferences.dart';

/// Local notifications for data-only FCM digests (client-side l10n).
class PushLocalNotifications {
  PushLocalNotifications._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'exora_opportunities',
    'Opportunity alerts',
    description: 'New exchange contests, listings, and Earn offers',
    importance: Importance.high,
  );

  static var _initialized = false;

  static Future<void> ensureInitialized() async {
    if (kIsWeb || _initialized) return;
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)) {
      return;
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onTap,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(_androidChannel);

    _initialized = true;
  }

  static Future<void> showFromRemoteMessage(RemoteMessage message) async {
    await ensureInitialized();
    final prefs = await PushPreferences.load();
    final copy = PushDigestCopy.fromMessageData(message.data, prefs: prefs);
    if (copy == null) return;

    final payload = jsonEncode({'url': copy.url});
    await _plugin.show(
      id:
          message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
      title: copy.title,
      body: copy.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  static Future<void> handleLaunchPayload() async {
    await ensureInitialized();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return;
    final payload = details!.notificationResponse?.payload;
    if (payload == null || payload.isEmpty) return;
    await _openPayload(payload);
  }

  static void _onTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    // ignore: discarded_futures
    _openPayload(payload);
  }

  static Future<void> _openPayload(String payload) async {
    try {
      final map = jsonDecode(payload);
      if (map is! Map) return;
      final url = map['url']?.toString().trim() ?? '';
      if (url.isEmpty) return;
      final uri = Uri.tryParse(url);
      if (uri == null) return;
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[push] local notif tap failed: $e');
    }
  }
}
