import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/app_database.dart';
import '../models/exchange_event.dart';

enum Exchange { bybit, binance, okx, upbit, bithumb, bitget }

extension ExchangeX on Exchange {
  String get apiPath => switch (this) {
        Exchange.bybit => '/api/bybit/events',
        Exchange.binance => '/api/binance/events',
        Exchange.okx => '/api/okx/events',
        Exchange.upbit => '/api/upbit/events',
        Exchange.bithumb => '/api/bithumb/events',
        Exchange.bitget => '/api/bitget/events',
      };

  String get labelKo => switch (this) {
        Exchange.bybit => '바이비트',
        Exchange.binance => '바이낸스',
        Exchange.okx => 'OKX',
        Exchange.upbit => '업비트',
        Exchange.bithumb => '빗썸',
        Exchange.bitget => 'Bitget',
      };
}

class ExchangeEventsResult {
  const ExchangeEventsResult({
    required this.exchange,
    required this.total,
    required this.items,
    required this.fromCache,
    this.fetchedAt,
  });

  final Exchange exchange;
  final int total;
  final List<ExchangeEvent> items;
  final bool fromCache;
  final DateTime? fetchedAt;
}

class ExchangeEventsService {
  ExchangeEventsService({
    String? apiBaseUrl,
    http.Client? client,
    AppDatabase? database,
    this.cacheTtl = const Duration(hours: 1),
  })  : apiBaseUrl = apiBaseUrl ?? defaultApiBaseUrl,
        _client = client ?? http.Client(),
        _db = database ?? AppDatabase();

  final String apiBaseUrl;
  final http.Client _client;
  final AppDatabase _db;
  final Duration cacheTtl;

  static String get defaultApiBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8787';
    }
    return 'http://localhost:8787';
  }

  Future<ExchangeEventsResult?> readCache(Exchange exchange) async {
    final snapshot = await _db.readExchangeSnapshot(exchange.name);
    if (snapshot == null) return null;
    return ExchangeEventsResult(
      exchange: exchange,
      total: snapshot.total,
      items: snapshot.items,
      fromCache: true,
      fetchedAt: snapshot.fetchedAt,
    );
  }

  bool isFresh(ExchangeEventsResult? cached) {
    final fetchedAt = cached?.fetchedAt;
    if (cached == null || fetchedAt == null || cached.items.isEmpty) {
      return false;
    }
    return DateTime.now().difference(fetchedAt) <= cacheTtl;
  }

  /// Cache-first load: returns cache immediately via [onCache], then refreshes
  /// from network when stale / forced / empty.
  Future<ExchangeEventsResult> loadEvents(
    Exchange exchange, {
    int limit = 20,
    bool forceRefresh = false,
    void Function(ExchangeEventsResult cached)? onCache,
  }) async {
    final cached = await readCache(exchange);
    if (cached != null && cached.items.isNotEmpty) {
      onCache?.call(cached);
      if (!forceRefresh && isFresh(cached)) {
        return cached;
      }
    }

    try {
      final remote = await fetchEvents(exchange, limit: limit);
      await _db.replaceExchangeEvents(
        exchange: exchange.name,
        total: remote.total,
        items: remote.items,
      );
      return remote;
    } catch (e) {
      if (cached != null && cached.items.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  Future<ExchangeEventsResult> fetchEvents(
    Exchange exchange, {
    int limit = 20,
  }) async {
    final uri = Uri.parse('$apiBaseUrl${exchange.apiPath}').replace(
      queryParameters: {'limit': '$limit'},
    );

    final response =
        await _client.get(uri).timeout(const Duration(seconds: 90));
    if (response.statusCode != 200) {
      throw Exception('이벤트 조회 실패 (${response.statusCode}): ${response.body}');
    }

    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (body['error'] != null) {
      throw Exception(body['error'].toString());
    }

    final items = (body['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(ExchangeEvent.fromJson)
        .toList();

    return ExchangeEventsResult(
      exchange: exchange,
      total: (body['total'] as num?)?.toInt() ?? items.length,
      items: items,
      fromCache: false,
      fetchedAt: DateTime.now(),
    );
  }

  /// Resolves a campaign image asynchronously and persists it in local SQL.
  /// Returns a display URL safe for [Image.network] (proxied on web).
  Future<String?> fetchEventImage({
    required Exchange exchange,
    required String url,
  }) async {
    final uri = Uri.parse('$apiBaseUrl/api/event-image').replace(
      queryParameters: {
        'exchange': exchange.name,
        'url': url,
      },
    );
    final response =
        await _client.get(uri).timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      return null;
    }
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (body['error'] != null) return null;
    final imageUrl = body['imageUrl']?.toString();
    final normalized =
        (imageUrl == null || imageUrl.trim().isEmpty) ? null : imageUrl.trim();
    await _db.updateEventImageUrl(
      exchange: exchange.name,
      url: url,
      imageUrl: normalized,
    );
    return displayImageUrl(normalized);
  }

  /// CDN images often block browser CORS; on web load via our proxy.
  String? displayImageUrl(String? imageUrl) {
    final trimmed = imageUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    if (!kIsWeb) return trimmed;
    return Uri.parse('$apiBaseUrl/api/image-proxy').replace(
      queryParameters: {'url': trimmed},
    ).toString();
  }

  Future<void> close() => _db.close();
}
