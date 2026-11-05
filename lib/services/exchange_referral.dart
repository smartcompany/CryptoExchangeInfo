import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'exchange_events_service.dart';

/// Appends affiliate referral codes when opening exchange destinations.
///
/// Codes/links are loaded from server `GET /api/settings`:
/// - `referrals` — invite codes applied to outbound URLs
/// - `referral_links` — full signup links (banner Sign up CTA)
///
/// Attribution typically applies when a **new** user registers (or binds)
/// via a link carrying these params.
class ExchangeReferral {
  const ExchangeReferral._();

  static String? _binance;
  static String? _bybit;
  static String? _okx;
  static String? _gate;
  static String? _mexc;
  static String? _bitget;
  static String? _kucoin;
  static String? _coinbase;

  static final Map<String, String> _links = {};
  static var _loaded = false;

  static bool get isLoaded => _loaded;

  /// Full invite URL for [exchange] if provided by settings (e.g. `mexc`).
  static String? signupLink(String exchange) {
    final key = exchange.trim().toLowerCase();
    final value = _links[key];
    if (value == null || value.isEmpty) return null;
    return value;
  }

  /// Loads referral codes/links from [apiBaseUrl]/api/settings`.
  static Future<void> load({
    String? apiBaseUrl,
    http.Client? client,
  }) async {
    final base =
        (apiBaseUrl ?? ExchangeEventsService.productionApiBaseUrl).trim();
    final uri = Uri.parse('$base/api/settings');
    final httpClient = client ?? http.Client();
    final ownsClient = client == null;
    try {
      final res = await httpClient
          .get(uri, headers: {'accept': 'application/json'})
          .timeout(const Duration(seconds: 12));
      if (res.statusCode < 200 || res.statusCode >= 300) {
        debugPrint('[ExchangeReferral] settings HTTP ${res.statusCode}');
        return;
      }
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) return;

      final raw = decoded['referrals'];
      if (raw is Map) {
        configure(
          binance: raw['binance']?.toString(),
          bybit: raw['bybit']?.toString(),
          okx: raw['okx']?.toString(),
          gate: raw['gate']?.toString(),
          mexc: raw['mexc']?.toString(),
          bitget: raw['bitget']?.toString(),
          kucoin: raw['kucoin']?.toString(),
          coinbase: raw['coinbase']?.toString(),
        );
      } else {
        debugPrint('[ExchangeReferral] no referrals in settings');
      }

      _links.clear();
      final links = decoded['referral_links'];
      if (links is Map) {
        for (final entry in links.entries) {
          final key = entry.key.toString().trim().toLowerCase();
          final value = entry.value?.toString().trim() ?? '';
          if (key.isEmpty || value.isEmpty) continue;
          _links[key] = value;
        }
      }

      _loaded = true;
      debugPrint(
        '[ExchangeReferral] loaded '
        'binance=${_binance != null} bybit=${_bybit != null} '
        'okx=${_okx != null} gate=${_gate != null} mexc=${_mexc != null} '
        'bitget=${_bitget != null} kucoin=${_kucoin != null} '
        'coinbase=${_coinbase != null} links=${_links.length}',
      );
    } catch (error, stack) {
      debugPrint('[ExchangeReferral] load failed: $error');
      debugPrint('$stack');
    } finally {
      if (ownsClient) httpClient.close();
    }
  }

  @visibleForTesting
  static void configure({
    String? binance,
    String? bybit,
    String? okx,
    String? gate,
    String? mexc,
    String? bitget,
    String? kucoin,
    String? coinbase,
  }) {
    _binance = _nonzero(binance);
    _bybit = _nonzero(bybit);
    _okx = _nonzero(okx);
    _gate = _nonzero(gate);
    _mexc = _nonzero(mexc);
    _bitget = _nonzero(bitget);
    _kucoin = _nonzero(kucoin);
    _coinbase = _nonzero(coinbase);
  }

  static String? _nonzero(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Returns [uri] with referral params for supported exchange hosts.
  static Uri apply(Uri uri) {
    final host = uri.host.toLowerCase();

    final binance = _binance;
    if (binance != null && host.contains('binance.')) {
      return _withQuery(uri, {'ref': binance});
    }

    final bybit = _bybit;
    if (bybit != null && host.contains('bybit.')) {
      return _withQuery(uri, {'ref': bybit});
    }

    final okx = _okx;
    if (okx != null && host.contains('okx.')) {
      // Official invite form: https://okx.com/join/{code}
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
      if (segments.isNotEmpty && segments.first.toLowerCase() == 'join') {
        return uri.replace(path: '/join/$okx');
      }
      // Deep links: OKX affiliate tracking commonly uses channelId.
      return _withQuery(uri, {'channelId': okx});
    }

    final gate = _gate;
    if (gate != null && (host.contains('gate.') || host.contains('gateio.'))) {
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .map((s) => s.toLowerCase())
          .toList(growable: false);
      // https://www.gate.com/share/{code}
      if (segments.isNotEmpty && segments.first == 'share') {
        return uri.replace(path: '/share/$gate');
      }
      // Deep links / signup: Gate commonly uses ref (+ ref_type).
      return _withQuery(uri, {'ref': gate, 'ref_type': '103'});
    }

    final mexc = _mexc;
    if (mexc != null && host.contains('mexc.')) {
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .map((s) => s.toLowerCase())
          .toList(growable: false);
      // Keep short referral landing paths intact; otherwise stamp inviteCode.
      if (segments.isNotEmpty && segments.first == 'referral') {
        return uri;
      }
      return _withQuery(uri, {'inviteCode': mexc});
    }

    final bitget = _bitget;
    if (bitget != null && host.contains('bitget.')) {
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .map((s) => s.toLowerCase())
          .toList(growable: false);
      // Keep share.bitget.com/u/... invite landings intact.
      if (host.startsWith('share.') &&
          segments.isNotEmpty &&
          segments.first == 'u') {
        return uri;
      }
      // Bitget deep links commonly honor vipCode.
      return _withQuery(uri, {'vipCode': bitget});
    }

    final kucoin = _kucoin;
    if (kucoin != null && host.contains('kucoin.')) {
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .map((s) => s.toLowerCase())
          .toList(growable: false);
      // Official invite: https://www.kucoin.com/r/rf/{code}
      if (segments.length >= 2 &&
          segments[0] == 'r' &&
          (segments[1] == 'rf' || segments[1] == 'af')) {
        return uri.replace(path: '/r/${segments[1]}/$kucoin');
      }
      return _withQuery(uri, {'rcode': kucoin});
    }

    final coinbase = _coinbase;
    if (coinbase != null && host.contains('coinbase.')) {
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .map((s) => s.toLowerCase())
          .toList(growable: false);
      // Official invite: https://advanced.coinbase.com/join/{code}
      if (segments.isNotEmpty && segments.first == 'join') {
        return uri.replace(path: '/join/$coinbase');
      }
      // Status / docs pages are not signup landings.
      if (host.startsWith('status.')) {
        return uri;
      }
    }

    return uri;
  }

  static Uri _withQuery(Uri uri, Map<String, String> extra) {
    final params = Map<String, String>.from(uri.queryParameters)..addAll(extra);
    return uri.replace(queryParameters: params);
  }
}
