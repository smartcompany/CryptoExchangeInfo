import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_auth.dart';
import 'exchange_events_service.dart';
import 'push_user_store.dart';

/// Registers / updates FCM token via API → Supabase `cryptoex_users`.
class PushRegisterService {
  PushRegisterService._();
  static final PushRegisterService instance = PushRegisterService._();

  Future<bool> upsert({
    required bool pushEnabled,
    String? pushToken,
    String? locale,
  }) async {
    if (kIsWeb) return false;
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android)) {
      return false;
    }

    final id = await PushUserStore.getOrCreateUserId();
    final platform = defaultTargetPlatform == TargetPlatform.iOS
        ? 'ios'
        : 'android';

    final uri = Uri.parse(
      '${ExchangeEventsService.productionApiBaseUrl}/api/push-register',
    );

    try {
      final res = await http
          .post(
            uri,
            headers: {
              ...ApiAuth.headers,
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'id': id,
              'push_token': pushEnabled ? pushToken : null,
              'platform': platform,
              'locale': locale,
              'push_enabled': pushEnabled,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode < 200 || res.statusCode >= 300) {
        debugPrint(
          '[push-register] HTTP ${res.statusCode}: ${res.body}',
        );
        return false;
      }
      debugPrint('[push-register] ok id=$id enabled=$pushEnabled');
      return true;
    } catch (e) {
      debugPrint('[push-register] failed: $e');
      return false;
    }
  }
}
