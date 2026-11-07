import 'dart:ui' show PlatformDispatcher;

import 'package:http/http.dart' as http;

import '../data/app_database.dart';
import '../models/exchange_event.dart';
import 'event_image_resolver.dart';
import 'exchange_event_fetchers.dart';
import 'translate_service.dart';

enum Exchange {
  binance,
  okx,
  bybit,
  gate,
  mexc,
  bitget,
  kucoin,
  coinbase,
  upbit,
  bithumb,
}

extension ExchangeX on Exchange {
  String get labelKo => switch (this) {
    Exchange.binance => '바이낸스',
    Exchange.okx => 'OKX',
    Exchange.bybit => '바이비트',
    Exchange.gate => 'Gate',
    Exchange.mexc => 'MEXC',
    Exchange.bitget => 'Bitget',
    Exchange.kucoin => 'KuCoin',
    Exchange.coinbase => 'Coinbase',
    Exchange.upbit => '업비트',
    Exchange.bithumb => '빗썸',
  };
}

class ExchangeEventsResult {
  const ExchangeEventsResult({
    required this.exchange,
    required this.total,
    required this.items,
    required this.fromCache,
    this.fetchedAt,
    this.hasMore = false,
    this.page = 1,
  });

  final Exchange exchange;
  final int total;
  final List<ExchangeEvent> items;
  final bool fromCache;
  final DateTime? fetchedAt;
  final bool hasMore;
  final int page;
}

class ExchangeEventsService {
  ExchangeEventsService({
    http.Client? client,
    AppDatabase? database,
    ExchangeEventFetchers? fetchers,
    EventImageResolver? imageResolver,
    this.cacheTtl = const Duration(hours: 1),
  }) : _client = client ?? http.Client(),
       _db = database ?? AppDatabase(),
       _fetchers =
           fetchers ?? ExchangeEventFetchers(client: client ?? http.Client()),
       _images =
           imageResolver ?? EventImageResolver(client: client ?? http.Client());

  final http.Client _client;
  final AppDatabase _db;
  final ExchangeEventFetchers _fetchers;
  final EventImageResolver _images;
  final Duration cacheTtl;

  /// Settings + AI analyze API (Vercel).
  static const productionApiBaseUrl =
      'https://cryptoexchangeinfoserver.vercel.app';

  String get _activeLocale => TranslateService.normalizeLang(
    PlatformDispatcher.instance.locale.languageCode,
  );

  Future<ExchangeEventsResult?> readCache(Exchange exchange) async {
    final snapshot = await _db.readExchangeSnapshot(exchange.name);
    if (snapshot == null) return null;
    // Cached titles are localized for a specific app language — ignore on mismatch.
    if (snapshot.localeCode != _activeLocale) return null;
    final items = snapshot.items;
    // Drop caches that still look Korean while the app language is not Korean
    // (e.g. previous MyMemory 429 failures stored raw Hangul under locale=en).
    if (!_localizedTitlesLookValid(items, _activeLocale)) return null;
    final hasMore =
        items.length < ExchangeEventFetchers.maxItems &&
        items.length < snapshot.total;
    return ExchangeEventsResult(
      exchange: exchange,
      total: snapshot.total,
      items: items,
      fromCache: true,
      fetchedAt: snapshot.fetchedAt,
      hasMore: hasMore,
      page: _pageFromCount(items.length),
    );
  }

  bool _localizedTitlesLookValid(List<ExchangeEvent> items, String locale) {
    if (locale == 'ko' || items.isEmpty) return true;
    var sample = 0;
    var wrong = 0;
    for (final item in items.take(6)) {
      final title = item.displayTitle.trim();
      if (title.isEmpty) continue;
      sample++;
      final detected = TranslateService.detectLanguage(title);
      if (detected != locale) wrong++;
    }
    if (sample == 0) return true;
    return wrong * 2 < sample; // allow a few mixed titles
  }

  bool isFresh(ExchangeEventsResult? cached) {
    final fetchedAt = cached?.fetchedAt;
    if (cached == null || fetchedAt == null || cached.items.isEmpty) {
      return false;
    }
    return DateTime.now().difference(fetchedAt) <= cacheTtl;
  }

  /// Cache-first load of the first page: returns cache via [onCache], then
  /// refreshes from network when stale / forced / empty.
  Future<ExchangeEventsResult> loadEvents(
    Exchange exchange, {
    int limit = ExchangeEventFetchers.defaultPageSize,
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
      final remote = await fetchEventsPage(
        exchange,
        page: 1,
        pageSize: limit,
      );
      await _db.replaceExchangeEvents(
        exchange: exchange.name,
        total: remote.total,
        items: remote.items,
        localeCode: _activeLocale,
      );
      return remote;
    } catch (e) {
      if (cached != null && cached.items.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  /// Appends the next page onto [current] (deduped by URL), capped at maxItems.
  Future<ExchangeEventsResult> loadMoreEvents(
    Exchange exchange, {
    required List<ExchangeEvent> current,
    required int nextPage,
  }) async {
    if (current.length >= ExchangeEventFetchers.maxItems) {
      return ExchangeEventsResult(
        exchange: exchange,
        total: current.length,
        items: current,
        fromCache: false,
        fetchedAt: DateTime.now(),
        hasMore: false,
        page: nextPage - 1,
      );
    }

    final page = await _fetchers.fetchPage(
      exchange,
      page: nextPage,
      pageSize: ExchangeEventFetchers.defaultPageSize,
      alreadyLoaded: current.length,
    );

    final seen = current.map((e) => e.url).toSet();
    final merged = [
      ...current,
      for (final item in page.items)
        if (item.url.isNotEmpty && seen.add(item.url)) item,
    ];
    final capped = merged.length > ExchangeEventFetchers.maxItems
        ? merged.sublist(0, ExchangeEventFetchers.maxItems)
        : merged;

    final added = capped.length - current.length;
    // Some exchanges (e.g. Bitget) ignore pageNo and repeat page 1 — stop then.
    final hasMore =
        added > 0 &&
        page.hasMore &&
        capped.length < ExchangeEventFetchers.maxItems;

    await _db.replaceExchangeEvents(
      exchange: exchange.name,
      total: page.total > capped.length ? page.total : capped.length,
      items: capped,
      localeCode: _activeLocale,
    );

    return ExchangeEventsResult(
      exchange: exchange,
      total: page.total > capped.length ? page.total : capped.length,
      items: capped,
      fromCache: false,
      fetchedAt: DateTime.now(),
      hasMore: hasMore,
      page: nextPage,
    );
  }

  Future<ExchangeEventsResult> fetchEvents(
    Exchange exchange, {
    int limit = ExchangeEventFetchers.defaultPageSize,
  }) async {
    return fetchEventsPage(exchange, page: 1, pageSize: limit);
  }

  Future<ExchangeEventsResult> fetchEventsPage(
    Exchange exchange, {
    int page = 1,
    int pageSize = ExchangeEventFetchers.defaultPageSize,
  }) async {
    final result = await _fetchers.fetchPage(
      exchange,
      page: page,
      pageSize: pageSize,
      alreadyLoaded: (page - 1) * pageSize,
    );
    return ExchangeEventsResult(
      exchange: exchange,
      total: result.total,
      items: result.items,
      fromCache: false,
      fetchedAt: DateTime.now(),
      hasMore: result.hasMore,
      page: result.page,
    );
  }

  /// Resolves a campaign image asynchronously and persists it in local SQL.
  Future<String?> fetchEventImage({
    required Exchange exchange,
    required String url,
  }) async {
    final imageUrl = await _images.resolve(exchange: exchange, url: url);
    final normalized = (imageUrl == null || imageUrl.trim().isEmpty)
        ? null
        : imageUrl.trim();
    await _db.updateEventImageUrl(
      exchange: exchange.name,
      url: url,
      imageUrl: normalized,
    );
    return displayImageUrl(normalized);
  }

  /// On native platforms images load directly. Web may hit CDN CORS limits.
  String? displayImageUrl(String? imageUrl) {
    final trimmed = imageUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  Future<void> close() async {
    _client.close();
    await _db.close();
  }

  int _pageFromCount(int count) {
    if (count <= 0) return 1;
    return ((count - 1) ~/ ExchangeEventFetchers.defaultPageSize) + 1;
  }
}
