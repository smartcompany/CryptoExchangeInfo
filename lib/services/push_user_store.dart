import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// Local UUID for [cryptoex_users.id] (generated once per install).
class PushUserStore {
  PushUserStore._();

  static const _kUserId = 'exora_push_user_id';

  static Future<String> getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_kUserId)?.trim();
    if (existing != null && existing.isNotEmpty) return existing;
    final id = _uuidV4();
    await prefs.setString(_kUserId, id);
    return id;
  }

  static String _uuidV4() {
    final r = Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int b) => b.toRadixString(16).padLeft(2, '0');
    final h = bytes.map(hex).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
}
