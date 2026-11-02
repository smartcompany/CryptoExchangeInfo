import 'dart:convert';
import 'dart:ui' show PlatformDispatcher;

import 'package:http/http.dart' as http;

import '../models/exchange_event.dart';
import 'exchange_events_service.dart';
import 'translate_service.dart';

class _RawEvent {
  const _RawEvent({
    required this.exchange,
    required this.title,
    required this.description,
    required this.typeKey,
    required this.typeTitle,
    required this.tags,
    required this.url,
    required this.dateTimestamp,
    required this.startDateTimestamp,
    required this.endDateTimestamp,
    required this.publishTime,
  });

  final String exchange;
  final String title;
  final String description;
  final String typeKey;
  final String typeTitle;
  final List<String> tags;
  final String url;
  final int? dateTimestamp;
  final int? startDateTimestamp;
  final int? endDateTimestamp;
  final int? publishTime;
}

class ExchangeEventsPageResult {
  const ExchangeEventsPageResult({
    required this.total,
    required this.items,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  final int total;
  final List<ExchangeEvent> items;
  final int page;
  final int pageSize;

  /// True when the remote feed may have another page and we are under [maxItems].
  final bool hasMore;
}

class ExchangeEventFetchers {
  ExchangeEventFetchers({http.Client? client, TranslateService? translate})
    : _client = client ?? http.Client(),
      _translate = translate ?? TranslateService(client: client);

  final http.Client _client;
  final TranslateService _translate;

  static const defaultPageSize = 20;
  static const maxItems = 100;

  static const _browserHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.9,ko;q=0.8',
  };

  Future<ExchangeEventsPageResult> fetchPage(
    Exchange exchange, {
    int page = 1,
    int pageSize = defaultPageSize,
    int alreadyLoaded = 0,
  }) async {
    final safePage = page < 1 ? 1 : page;
    final size = pageSize.clamp(1, defaultPageSize);
    final remaining = maxItems - alreadyLoaded;
    if (remaining <= 0) {
      return ExchangeEventsPageResult(
        total: alreadyLoaded,
        items: const [],
        page: safePage,
        pageSize: size,
        hasMore: false,
      );
    }
    final requestSize = remaining < size ? remaining : size;

    final raw = await switch (exchange) {
      Exchange.binance => _binance(page: safePage, limit: requestSize),
      Exchange.okx => _okx(page: safePage, limit: requestSize),
      Exchange.bybit => _bybit(page: safePage, limit: requestSize),
      Exchange.gate => _gate(page: safePage, limit: requestSize),
      Exchange.mexc => _mexc(page: safePage, limit: requestSize),
      Exchange.bitget => _bitget(page: safePage, limit: requestSize),
      Exchange.kucoin => _kucoin(page: safePage, limit: requestSize),
      Exchange.coinbase => _coinbase(page: safePage, limit: requestSize),
      Exchange.htx => _htx(page: safePage, limit: requestSize),
      Exchange.upbit => _upbit(page: safePage, limit: requestSize),
      Exchange.bithumb => _bithumb(page: safePage, limit: requestSize),
    };

    final items = await _translateEvents(raw.prepared);
    final loadedAfter = alreadyLoaded + items.length;
    final reachedCap = loadedAfter >= maxItems;
    final remoteTotal = raw.total > loadedAfter ? raw.total : loadedAfter;
    // Full page and remote total still ahead ⇒ likely more.
    // (APIs that repeat page 1 should report total == page length.)
    final hasMore =
        !reachedCap && items.length >= requestSize && loadedAfter < remoteTotal;

    return ExchangeEventsPageResult(
      total: remoteTotal,
      items: items,
      page: safePage,
      pageSize: size,
      hasMore: hasMore,
    );
  }

  /// Convenience: first page only (same as previous single-shot fetch).
  Future<({int total, List<ExchangeEvent> items})> fetch(
    Exchange exchange, {
    int limit = defaultPageSize,
  }) async {
    final page = await fetchPage(
      exchange,
      page: 1,
      pageSize: limit.clamp(1, defaultPageSize),
    );
    return (total: page.total, items: page.items);
  }

  Future<({int total, List<_RawEvent> prepared})> _bybit({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse('https://api.bybit.com/v5/announcements/index')
        .replace(
          queryParameters: {
            'locale': 'en-US',
            'type': 'latest_activities',
            'page': '$page',
            'limit': '$limit',
          },
        );
    final res = await _client.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Bybit HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['retCode'] != 0) {
      throw Exception(body['retMsg']?.toString() ?? 'Bybit error');
    }
    final result = body['result'] as Map<String, dynamic>? ?? {};
    final list = (result['list'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final prepared = list.map((raw) {
      final type = raw['type'] as Map<String, dynamic>? ?? {};
      final tags = (raw['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();
      return _RawEvent(
        exchange: 'bybit',
        title: (raw['title'] as String?)?.trim() ?? '',
        description: (raw['description'] as String?)?.trim() ?? '',
        typeKey: (type['key'] as String?) ?? 'latest_activities',
        typeTitle: (type['title'] as String?) ?? 'Latest Campaigns',
        tags: tags,
        url: (raw['url'] as String?) ?? '',
        dateTimestamp: _asInt(raw['dateTimestamp']),
        startDateTimestamp: _asInt(raw['startDateTimestamp']),
        endDateTimestamp: _asInt(raw['endDateTimestamp']),
        publishTime: _asInt(raw['publishTime']),
      );
    }).toList();
    return (
      total: _asInt(result['total']) ?? prepared.length,
      prepared: prepared,
    );
  }

  Future<({int total, List<_RawEvent> prepared})> _binance({
    required int page,
    required int limit,
  }) async {
    final uri =
        Uri.parse(
          'https://www.binance.com/bapi/composite/v1/public/cms/article/list/query',
        ).replace(
          queryParameters: {
            'type': '1',
            'catalogId': '93',
            'pageNo': '$page',
            'pageSize': '$limit',
          },
        );
    final res = await _client
        .get(
          uri,
          headers: {
            ..._browserHeaders,
            'Origin': 'https://www.binance.com',
            'Referer': 'https://www.binance.com/en/support/announcement',
            'clienttype': 'web',
            'lang': 'en',
          },
        )
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Binance HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '000000') {
      throw Exception(body['message']?.toString() ?? 'Binance error');
    }
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final catalogs = (data['catalogs'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    Map<String, dynamic>? activities;
    for (final catalog in catalogs) {
      if (catalog['catalogId'] == 93) {
        activities = catalog;
        break;
      }
    }
    activities ??= catalogs.isNotEmpty ? catalogs.first : null;
    final articles = (activities?['articles'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .take(limit)
        .toList();
    final prepared = articles.map((raw) {
      final code = (raw['code'] as String?) ?? '';
      final releaseDate = _asInt(raw['releaseDate']);
      return _RawEvent(
        exchange: 'binance',
        title: (raw['title'] as String?)?.trim() ?? '',
        description: '',
        typeKey: 'latest_activities',
        typeTitle: 'Latest Activities',
        tags: const ['Latest Activities'],
        url: code.isEmpty
            ? 'https://www.binance.com/en/support/announcement'
            : 'https://www.binance.com/en/support/announcement/$code',
        dateTimestamp: releaseDate,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: releaseDate,
      );
    }).toList();
    return (
      total: _asInt(activities?['total']) ?? prepared.length,
      prepared: prepared,
    );
  }

  Future<({int total, List<_RawEvent> prepared})> _okx({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse(
      'https://www.okx.com/api/v5/support/announcements',
    ).replace(queryParameters: {'annType': 'latest-events', 'page': '$page'});
    final res = await _client
        .get(uri, headers: {..._browserHeaders, 'Accept-Language': 'en-US'})
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('OKX HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '0') {
      throw Exception(body['msg']?.toString() ?? 'OKX error');
    }
    final pages = (body['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final pageData = pages.isNotEmpty ? pages.first : <String, dynamic>{};
    final details = (pageData['details'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .take(limit)
        .toList();
    final totalPage =
        int.tryParse(pageData['totalPage']?.toString() ?? '') ?? 1;
    // OKX page size is typically ~20; approximate remote total from pages.
    final prepared = details.map((raw) {
      final pTime = _asInt(raw['pTime']) ?? _asInt(raw['businessPTime']);
      return _RawEvent(
        exchange: 'okx',
        title: (raw['title'] as String?)?.trim() ?? '',
        description: '',
        typeKey: (raw['annType'] as String?) ?? 'latest-events',
        typeTitle: 'Latest events',
        tags: [(raw['annType'] as String?) ?? 'latest-events'],
        url: (raw['url'] as String?) ?? 'https://www.okx.com/help',
        dateTimestamp: pTime,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: pTime,
      );
    }).toList();
    return (total: totalPage * defaultPageSize, prepared: prepared);
  }

  Future<({int total, List<_RawEvent> prepared})> _upbit({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse('https://api-manager.upbit.com/api/v1/announcements')
        .replace(
          queryParameters: {
            'os': 'web',
            'page': '$page',
            'per_page': '$limit',
            'category': 'event',
          },
        );
    final res = await _client
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Upbit HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      throw Exception('Upbit error');
    }
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final notices = (data['notices'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final prepared = notices.map((raw) {
      final id = raw['id'];
      final title = (raw['title'] as String?)?.trim() ?? '';
      final category = (raw['category'] as String?) ?? 'Event';
      final listedAt = _parseKoreaDateTime(
        (raw['listed_at'] as String?) ?? (raw['first_listed_at'] as String?),
      );
      return _RawEvent(
        exchange: 'upbit',
        title: title,
        description: '',
        typeKey: 'event',
        typeTitle: category,
        tags: [category],
        url: id == null
            ? 'https://upbit.com/service_center/notice'
            : 'https://upbit.com/service_center/notice?id=$id',
        dateTimestamp: listedAt,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: listedAt,
      );
    }).toList();
    return (
      total: _asInt(data['total_count']) ?? prepared.length,
      prepared: prepared,
    );
  }

  /// Bithumb only exposes `count` (no page). Re-fetch a growing window and
  /// return the slice for [page].
  Future<({int total, List<_RawEvent> prepared})> _bithumb({
    required int page,
    required int limit,
  }) async {
    final end = page * limit;
    final count = end.clamp(1, maxItems);
    final uri = Uri.parse(
      'https://api.bithumb.com/v1/notices',
    ).replace(queryParameters: {'count': '$count'});
    final res = await _client
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Bithumb HTTP ${res.statusCode}');
    }
    final list = (jsonDecode(res.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final start = (page - 1) * limit;
    final slice = start >= list.length
        ? const <Map<String, dynamic>>[]
        : list.sublist(start, end > list.length ? list.length : end);
    final prepared = slice.map((raw) {
      final title = (raw['title'] as String?)?.trim() ?? '';
      final categories = (raw['categories'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();
      final published = _parseKoreaDateTime(raw['published_at'] as String?);
      return _RawEvent(
        exchange: 'bithumb',
        title: title,
        description: '',
        typeKey: categories.isNotEmpty ? categories.first : 'notice',
        typeTitle: categories.isNotEmpty ? categories.first : 'Notice',
        tags: categories.isEmpty ? const ['Notice'] : categories,
        url: (raw['pc_url'] as String?) ?? 'https://feed.bithumb.com/notice',
        dateTimestamp: published,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: published,
      );
    }).toList();
    // Without a remote total, treat the fetched window size as the known total.
    return (total: list.length, prepared: prepared);
  }

  Future<({int total, List<_RawEvent> prepared})> _bitget({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse('https://api.bitget.com/api/v2/public/annoucements')
        .replace(
          queryParameters: {
            'language': 'en_US',
            'pageNo': '$page',
            'pageSize': '$limit',
            'annType': 'latest_news',
          },
        );
    final res = await _client
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Bitget HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '00000') {
      throw Exception(body['msg']?.toString() ?? 'Bitget error');
    }
    final list = (body['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .take(limit)
        .toList();
    final prepared = list.map((raw) {
      final cTime = _asInt(raw['cTime']);
      return _RawEvent(
        exchange: 'bitget',
        title: (raw['annTitle'] as String?)?.trim() ?? '',
        description: '',
        typeKey: (raw['annType'] as String?) ?? 'latest_news',
        typeTitle: (raw['annDesc'] as String?) ?? 'Latest news',
        tags: [(raw['annType'] as String?) ?? 'latest_news'],
        url: (raw['annUrl'] as String?) ?? 'https://www.bitget.com/support',
        dateTimestamp: cTime,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: cTime,
      );
    }).toList();
    // Bitget's public announcements API ignores pageNo and always returns the
    // same first window — treat every response as a terminal page.
    return (total: prepared.length, prepared: prepared);
  }

  Future<({int total, List<_RawEvent> prepared})> _gate({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse('https://api.gateio.ws/api/v4/ann/list_article');
    final res = await _client
        .post(
          uri,
          headers: {..._browserHeaders, 'Content-Type': 'application/json'},
          body: jsonEncode({
            'page': '$page',
            'size': '$limit',
            'language': 'en',
          }),
        )
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Gate HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code'] != 0 && body['code']?.toString() != '0') {
      throw Exception(body['message']?.toString() ?? 'Gate error');
    }
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final list = (data['list'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final prepared = list.map((raw) {
      final path = (raw['url'] as String?) ?? '';
      final id = raw['id'];
      final url = path.startsWith('http')
          ? path
          : 'https://www.gate.com${path.startsWith('/') ? path : '/announcements/article/$id'}';
      final ts = _asInt(raw['release_timestamp']) ?? _asInt(raw['created_t']);
      // Gate timestamps may be seconds.
      final ms = ts == null ? null : (ts < 100000000000 ? ts * 1000 : ts);
      final tags =
          (raw['tags'] as String?)
              ?.split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList() ??
          const <String>[];
      return _RawEvent(
        exchange: 'gate',
        title: (raw['title'] as String?)?.trim() ?? '',
        description: (raw['brief'] as String?)?.trim() ?? '',
        typeKey: 'announcement',
        typeTitle: tags.isNotEmpty ? tags.first : 'Announcement',
        tags: tags.isEmpty ? const ['Announcement'] : tags,
        url: url,
        dateTimestamp: ms,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: ms,
      );
    }).toList();
    return (
      total: _asInt(data['total']) ?? prepared.length,
      prepared: prepared,
    );
  }

  Future<({int total, List<_RawEvent> prepared})> _mexc({
    required int page,
    required int limit,
  }) async {
    // MEXC requires limit to be a multiple of 5 or 10.
    final safeLimit = ((limit + 4) ~/ 5) * 5;
    final uri = Uri.parse('https://api.mexc.com/api/v3/announcements').replace(
      queryParameters: {
        'language': 'en-US',
        'page': '$page',
        'limit': '$safeLimit',
      },
    );
    final res = await _client
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('MEXC HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final code = body['code'];
    if (code != null && code != 0 && code.toString() != '0') {
      throw Exception(body['msg']?.toString() ?? 'MEXC error');
    }
    final pages = (body['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final pageData = pages.isNotEmpty ? pages.first : <String, dynamic>{};
    final details = (pageData['details'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .take(limit)
        .toList();
    final totalPage =
        int.tryParse(pageData['totalPage']?.toString() ?? '') ?? 1;
    final prepared = details.map((raw) {
      final postTime = _asInt(raw['postTime']);
      return _RawEvent(
        exchange: 'mexc',
        title: (raw['title'] as String?)?.trim() ?? '',
        description: '',
        typeKey: 'announcement',
        typeTitle: 'Announcement',
        tags: const ['Announcement'],
        url: (raw['url'] as String?) ?? 'https://www.mexc.com/announcements',
        dateTimestamp: postTime,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: postTime,
      );
    }).toList();
    return (total: totalPage * defaultPageSize, prepared: prepared);
  }

  Future<({int total, List<_RawEvent> prepared})> _kucoin({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse('https://api.kucoin.com/api/v3/announcements')
        .replace(
          queryParameters: {
            'currentPage': '$page',
            'pageSize': '$limit',
            'annType': 'latest-announcements',
            'lang': 'en_US',
          },
        );
    final res = await _client
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('KuCoin HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '200000') {
      throw Exception(body['msg']?.toString() ?? 'KuCoin error');
    }
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final items = (data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final prepared = items.map((raw) {
      final types = (raw['annType'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();
      final cTime = _asInt(raw['cTime']);
      return _RawEvent(
        exchange: 'kucoin',
        title: (raw['annTitle'] as String?)?.trim() ?? '',
        description: (raw['annDesc'] as String?)?.trim() ?? '',
        typeKey: types.isNotEmpty ? types.first : 'latest-announcements',
        typeTitle: types.isNotEmpty ? types.first : 'Announcement',
        tags: types.isEmpty ? const ['Announcement'] : types,
        url:
            (raw['annUrl'] as String?) ?? 'https://www.kucoin.com/announcement',
        dateTimestamp: cTime,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: cTime,
      );
    }).toList();
    return (
      total: _asInt(data['totalNum']) ?? prepared.length,
      prepared: prepared,
    );
  }

  /// Coinbase public status incidents + scheduled maintenance.
  Future<({int total, List<_RawEvent> prepared})> _coinbase({
    required int page,
    required int limit,
  }) async {
    final incidentsUri = Uri.parse(
      'https://status.coinbase.com/api/v2/incidents.json',
    ).replace(queryParameters: {'page': '$page'});
    final maintenanceUri = Uri.parse(
      'https://status.coinbase.com/api/v2/scheduled-maintenances.json',
    );

    final responses = await Future.wait([
      _client
          .get(incidentsUri, headers: _browserHeaders)
          .timeout(const Duration(seconds: 20)),
      if (page == 1)
        _client
            .get(maintenanceUri, headers: _browserHeaders)
            .timeout(const Duration(seconds: 20)),
    ]);

    final incidentsRes = responses.first;
    if (incidentsRes.statusCode != 200) {
      throw Exception('Coinbase HTTP ${incidentsRes.statusCode}');
    }
    final incidentBody = jsonDecode(incidentsRes.body) as Map<String, dynamic>;
    final incidents = (incidentBody['incidents'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    final rows = <Map<String, dynamic>>[
      for (final raw in incidents) {...raw, '_kind': 'incident'},
    ];

    if (page == 1 && responses.length > 1 && responses[1].statusCode == 200) {
      final maintBody = jsonDecode(responses[1].body) as Map<String, dynamic>;
      final maints =
          (maintBody['scheduled_maintenances'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      rows.addAll([
        for (final raw in maints) {...raw, '_kind': 'maintenance'},
      ]);
    }

    DateTime? parseAt(Map<String, dynamic> raw) {
      final value =
          raw['created_at']?.toString() ?? raw['started_at']?.toString();
      return value == null ? null : DateTime.tryParse(value)?.toUtc();
    }

    rows.sort((a, b) {
      final aa = parseAt(a) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bb = parseAt(b) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bb.compareTo(aa);
    });

    final slice = rows.take(limit).toList();
    final prepared = slice.map((raw) {
      final when = parseAt(raw);
      final kind = raw['_kind']?.toString() ?? 'notice';
      final updates = (raw['incident_updates'] as List<dynamic>? ?? []);
      final desc = updates.isNotEmpty
          ? ((updates.first as Map)['body']?.toString() ?? '')
          : '';
      return _RawEvent(
        exchange: 'coinbase',
        title: (raw['name'] as String?)?.trim() ?? '',
        description: desc.trim(),
        typeKey: kind,
        typeTitle: kind == 'maintenance' ? 'Maintenance' : 'Status',
        tags: [kind == 'maintenance' ? 'Maintenance' : 'Status'],
        url: (raw['shortlink'] as String?) ?? 'https://status.coinbase.com',
        dateTimestamp: when?.millisecondsSinceEpoch,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: when?.millisecondsSinceEpoch,
      );
    }).toList();

    // Statuspage rarely exposes a hard total; assume another page if full.
    final assumedTotal = prepared.length < limit
        ? (page - 1) * limit + prepared.length
        : page * limit + 1;
    return (total: assumedTotal, prepared: prepared);
  }

  /// HTX Latest Activities support list (HTML). Page 1 is the base list URL;
  /// page N uses `/list/{categoryId}/{N}`.
  Future<({int total, List<_RawEvent> prepared})> _htx({
    required int page,
    required int limit,
  }) async {
    const categoryId = '360000031362'; // Latest Activities
    final path = page <= 1
        ? '/en-us/support/list/$categoryId/'
        : '/en-us/support/list/$categoryId/$page';
    final uri = Uri.parse('https://www.htx.com$path');
    final res = await _client
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('HTX HTTP ${res.statusCode}');
    }
    final html = res.body;
    final pattern = RegExp(
      r'href="(/en-us/support/(\d+)/)"[\s\S]{0,400}?>([^<>]{10,200})</span></span></span><span[^>]*>\s*([^<>]{5,40})\s*<',
      caseSensitive: false,
    );
    final matches = pattern.allMatches(html).toList();
    final prepared = <_RawEvent>[];
    for (final match in matches.take(limit)) {
      final pathUrl = match.group(1) ?? '';
      final title = _decodeHtml(match.group(3)?.trim() ?? '');
      final dateText = match.group(4)?.trim() ?? '';
      if (title.isEmpty || pathUrl.isEmpty) continue;
      prepared.add(
        _RawEvent(
          exchange: 'htx',
          title: title,
          description: '',
          typeKey: 'latest_activities',
          typeTitle: 'Latest Activities',
          tags: const ['Latest Activities'],
          url: 'https://www.htx.com$pathUrl',
          dateTimestamp: _parseHtxListDate(dateText),
          startDateTimestamp: null,
          endDateTimestamp: null,
          publishTime: _parseHtxListDate(dateText),
        ),
      );
    }
    final assumedTotal = prepared.length < limit
        ? (page - 1) * limit + prepared.length
        : page * limit + 1;
    return (total: assumedTotal, prepared: prepared);
  }

  String _decodeHtml(String value) => value
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");

  int? _parseHtxListDate(String raw) {
    // e.g. "10/31 05:00:05 (UTC)" — month/day in current/previous year.
    final cleaned = raw.replaceAll('(UTC)', '').trim();
    final match = RegExp(
      r'^(\d{1,2})/(\d{1,2})\s+(\d{1,2}):(\d{2}):(\d{2})$',
    ).firstMatch(cleaned);
    if (match == null) return null;
    final now = DateTime.now().toUtc();
    var year = now.year;
    final month = int.parse(match.group(1)!);
    final day = int.parse(match.group(2)!);
    final hour = int.parse(match.group(3)!);
    final minute = int.parse(match.group(4)!);
    final second = int.parse(match.group(5)!);
    var dt = DateTime.utc(year, month, day, hour, minute, second);
    if (dt.isAfter(now.add(const Duration(days: 2)))) {
      dt = DateTime.utc(year - 1, month, day, hour, minute, second);
    }
    return dt.millisecondsSinceEpoch;
  }

  Future<List<ExchangeEvent>> _translateEvents(List<_RawEvent> prepared) async {
    final targetLang = TranslateService.normalizeLang(
      PlatformDispatcher.instance.locale.languageCode,
    );
    // Translate sequentially to avoid free-API rate limits (esp. KR→EN).
    final items = <ExchangeEvent>[];
    for (final item in prepared) {
      final titleKo = await _translate.translate(
        item.title,
        targetLanguage: targetLang,
      );
      final descriptionKo = item.description.trim().isEmpty
          ? ''
          : await _translate.translate(
              item.description,
              targetLanguage: targetLang,
            );
      items.add(
        ExchangeEvent(
          exchange: item.exchange,
          title: item.title,
          titleKo: titleKo,
          description: item.description,
          descriptionKo: descriptionKo,
          typeKey: item.typeKey,
          typeTitle: item.typeTitle,
          tags: item.tags,
          tagsKo: item.tags,
          url: item.url,
          imageUrl: null,
          dateTimestamp: item.dateTimestamp,
          startDateTimestamp: item.startDateTimestamp,
          endDateTimestamp: item.endDateTimestamp,
          publishTime: item.publishTime,
        ),
      );
    }
    return items;
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  int? _parseKoreaDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final normalized = raw.trim().replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) return null;
    if (parsed.isUtc || raw.contains('+') || raw.endsWith('Z')) {
      return parsed.toUtc().millisecondsSinceEpoch;
    }
    return parsed
        .toUtc()
        .subtract(const Duration(hours: 9))
        .millisecondsSinceEpoch;
  }
}
