import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'exchange_events_service.dart';

/// Shares the Exora app download / landing link.
abstract final class AppShare {
  static const _fallbackUrl =
      'https://cryptoexchangeinfoserver.vercel.app/applink';

  static String? _cachedUrl;

  static Future<String> resolveDownloadUrl() async {
    final cached = _cachedUrl;
    if (cached != null && cached.isNotEmpty) return cached;

    try {
      final uri = Uri.parse(
        '${ExchangeEventsService.productionApiBaseUrl}/api/settings',
      );
      final res = await http
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        if (body is Map) {
          final url = body['down_load_url']?.toString().trim();
          if (url != null && url.isNotEmpty) {
            _cachedUrl = url;
            return url;
          }
        }
      }
    } catch (e) {
      debugPrint('[AppShare] settings fetch failed: $e');
    }

    _cachedUrl = _fallbackUrl;
    return _fallbackUrl;
  }

  static Future<void> shareApp(AppLocalizations l10n) async {
    final url = await resolveDownloadUrl();
    await Share.share(l10n.shareMessage(url), subject: l10n.appTitle);
  }
}
