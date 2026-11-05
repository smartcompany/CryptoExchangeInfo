import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

const _bybitBase = 'https://api.bybit.com/v5/announcements/index';
const _binanceBase =
    'https://www.binance.com/bapi/composite/v1/public/cms/article/list/query';
const _okxBase = 'https://www.okx.com/api/v5/support/announcements';
const _upbitBase = 'https://api-manager.upbit.com/api/v1/announcements';
const _bithumbBase = 'https://api.bithumb.com/v1/notices';
const _bitgetBase = 'https://api.bitget.com/api/v2/public/annoucements';
const _translateBase = 'https://api.mymemory.translated.net/get';
const _jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

final _browserHeaders = {
  'User-Agent':
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
  'Accept': 'application/json, text/plain, */*',
  'Accept-Language': 'en-US,en;q=0.9,ko;q=0.8',
};

final _translationCache = <String, String>{};
final _imageCache = <String, String?>{};

Future<void> main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8787;
  final router = Router()
    ..get('/health', (_) => Response.ok('ok'))
    ..get('/api/settings', _settingsHandler)
    ..get('/api/bybit/events', _bybitEventsHandler)
    ..get('/api/binance/events', _binanceEventsHandler)
    ..get('/api/okx/events', _okxEventsHandler)
    ..get('/api/upbit/events', _upbitEventsHandler)
    ..get('/api/bithumb/events', _bithumbEventsHandler)
    ..get('/api/bitget/events', _bitgetEventsHandler)
    ..get('/api/earn/flexible-usdt', _flexibleUsdtEarnHandler)
    ..get('/api/event-image', _eventImageHandler)
    ..get('/api/image-proxy', _imageProxyHandler)
    ..post('/api/event-analyze', _eventAnalyzeHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  stdout.writeln('CoinInfo proxy listening on http://localhost:${server.port}');
}

/// AdMob unit config for flutter_share_lib [AdService].
/// Override with env: IOS_INITIAL_AD, IOS_REWARDED_AD, ANDROID_INITIAL_AD,
/// ANDROID_REWARDED_AD. Defaults are Google sample (test) unit IDs.
Future<Response> _settingsHandler(Request request) async {
  final settings = {
    'ios_ads': [
      {'initial_ad': 5},
      {'rewarded_ad': 1},
    ],
    'android_ads': [
      {'initial_ad': 5},
      {'rewarded_ad': 1},
    ],
    'ref': {
      'ios': {
        'initial_ad': Platform.environment['IOS_INITIAL_AD'] ??
            'ca-app-pub-3940256099942544/4411468910',
        'rewarded_ad': Platform.environment['IOS_REWARDED_AD'] ??
            'ca-app-pub-3940256099942544/1712485313',
      },
      'android': {
        'initial_ad': Platform.environment['ANDROID_INITIAL_AD'] ??
            'ca-app-pub-3940256099942544/1033173712',
        'rewarded_ad': Platform.environment['ANDROID_REWARDED_AD'] ??
            'ca-app-pub-3940256099942544/5224354917',
      },
    },
    'down_load_url': Platform.environment['DOWNLOAD_URL'] ??
        'https://cryptoexchangeinfoserver.vercel.app/applink',
    'referrals': {
      'binance': Platform.environment['REF_BINANCE'] ?? 'GRO_28502_DHEX0',
      'bybit': Platform.environment['REF_BYBIT'] ?? '4LMVJ',
      'okx': Platform.environment['REF_OKX'] ?? 'LYPMI7KH',
      'gate': Platform.environment['REF_GATE'] ?? 'VVUXULXECQ',
      'mexc': Platform.environment['REF_MEXC'] ?? '4E6ZD',
      'bitget': Platform.environment['REF_BITGET'] ?? 'ZNUN2HX5',
      'kucoin': Platform.environment['REF_KUCOIN'] ?? 'L2ZXN45F',
      'coinbase': Platform.environment['REF_COINBASE'] ?? 'SWD7NTZ',
    },
    'referral_links': {
      'binance':
          Platform.environment['REF_LINK_BINANCE'] ??
          'https://www.binance.com/join?ref=GRO_28502_DHEX0',
      'bybit':
          Platform.environment['REF_LINK_BYBIT'] ??
          'https://www.bybit.com/invite?ref=4LMVJ',
      'okx':
          Platform.environment['REF_LINK_OKX'] ??
          'https://www.okx.com/join/LYPMI7KH',
      'gate':
          Platform.environment['REF_LINK_GATE'] ??
          'https://www.gate.com/share/VVUXULXECQ',
      'mexc':
          Platform.environment['REF_LINK_MEXC'] ??
          'https://s.mexc.com/referral/A3WQZcmWqu',
      'bitget':
          Platform.environment['REF_LINK_BITGET'] ??
          'https://share.bitget.com/u/S6N2QMQN',
      'kucoin':
          Platform.environment['REF_LINK_KUCOIN'] ??
          'https://www.kucoin.com/r/rf/L2ZXN45F',
      'coinbase':
          Platform.environment['REF_LINK_COINBASE'] ??
          'https://advanced.coinbase.com/join/SWD7NTZ?src=referral-link',
    },
  };
  return Response.ok(jsonEncode(settings), headers: _jsonHeaders);
}

bool _authorized(Request request) {
  final expected = Platform.environment['EXORA_API_TOKEN']?.trim() ?? '';
  if (expected.isEmpty) return false;
  final header = request.headers['authorization'] ?? '';
  final match = RegExp(r'^Bearer\s+(\S+)$', caseSensitive: false).firstMatch(header);
  final provided = match?.group(1)?.trim() ?? '';
  return provided.isNotEmpty && provided == expected;
}

Future<Response> _eventAnalyzeHandler(Request request) async {
  if (!_authorized(request)) {
    return Response(
      401,
      body: jsonEncode({'error': 'Unauthorized'}),
      headers: _jsonHeaders,
    );
  }

  final apiKey = Platform.environment['GEMINI_API_KEY']?.trim() ?? '';
  if (apiKey.isEmpty) {
    return Response(
      503,
      body: jsonEncode({'error': 'GEMINI_API_KEY is not configured'}),
      headers: _jsonHeaders,
    );
  }

  Map<String, dynamic> payload;
  try {
    final raw = await request.readAsString();
    payload = jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return Response(
      400,
      body: jsonEncode({'error': 'invalid JSON body'}),
      headers: _jsonHeaders,
    );
  }

  final title = (payload['title'] as String?)?.trim() ?? '';
  final description = (payload['description'] as String?)?.trim() ?? '';
  final exchange = (payload['exchange'] as String?)?.trim() ?? '';
  final url = (payload['url'] as String?)?.trim() ?? '';
  final tags = (payload['tags'] as List<dynamic>? ?? [])
      .map((e) => e.toString())
      .where((e) => e.isNotEmpty)
      .toList();

  if (title.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'error': 'title is required'}),
      headers: _jsonHeaders,
    );
  }

  final systemPrompt = '''
당신은 암호화폐 거래소 이벤트·공지를 초보 투자자에게 쉽게 풀어 설명하는 도우미입니다.
투자 권유를 하지 마세요. 원문에 없는 보상·조건을 지어내지 마세요. 불확실하면 그렇다고 적으세요.
반드시 JSON 객체만 반환하세요:
{
  "summary": "2~4문장 한국어 요약",
  "reward": "보상 요약 (없으면 빈 문자열)",
  "period": "기간 요약 (없으면 빈 문자열)",
  "conditions": ["참여 조건 불릿"],
  "cautions": ["주의점·지역/KYC/위험 불릿"]
}
''';

  final userPrompt = '''
거래소: $exchange
제목: $title
태그: ${tags.join(', ')}
설명: ${description.isEmpty ? '(없음)' : description}
원문 URL: $url
시작(ms): ${payload['startDateTimestamp']}
종료(ms): ${payload['endDateTimestamp']}
''';

  try {
    const model = 'gemini-3.5-flash-lite';
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
    ).replace(queryParameters: {'key': apiKey});

    final res = await http
        .post(
          uri,
          headers: {'content-type': 'application/json; charset=utf-8'},
          body: jsonEncode({
            'systemInstruction': {
              'parts': [
                {'text': systemPrompt},
              ],
            },
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {'text': userPrompt},
                ],
              },
            ],
            'generationConfig': {
              'temperature': 0.3,
              'responseMimeType': 'application/json',
            },
          }),
        )
        .timeout(const Duration(seconds: 55));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      stderr.writeln('gemini HTTP ${res.statusCode}: ${res.body}');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Gemini HTTP ${res.statusCode}'}),
        headers: _jsonHeaders,
      );
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final candidates = body['candidates'] as List<dynamic>? ?? [];
    if (candidates.isEmpty) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Empty Gemini candidates'}),
        headers: _jsonHeaders,
      );
    }
    final content =
        (candidates.first as Map<String, dynamic>)['content']
            as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>? ?? [];
    final text = parts
        .map((p) => (p as Map<String, dynamic>)['text']?.toString() ?? '')
        .join()
        .trim();
    if (text.isEmpty) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Empty Gemini text'}),
        headers: _jsonHeaders,
      );
    }

    final analysis = _parseJsonObject(text);
    if (analysis == null) {
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to parse Gemini JSON'}),
        headers: _jsonHeaders,
      );
    }

    return Response.ok(
      jsonEncode({'analysis': analysis}),
      headers: _jsonHeaders,
    );
  } catch (e, st) {
    return _catchError('event-analyze', e, st);
  }
}

Map<String, dynamic>? _parseJsonObject(String text) {
  try {
    final decoded = jsonDecode(text);
    if (decoded is Map<String, dynamic>) return decoded;
  } catch (_) {}
  final start = text.indexOf('{');
  final end = text.lastIndexOf('}');
  if (start >= 0 && end > start) {
    try {
      final decoded = jsonDecode(text.substring(start, end + 1));
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
  }
  return null;
}

Future<Response> _bybitEventsHandler(Request request) async {
  final clamped = _limitFrom(request);
  try {
    final uri = Uri.parse(_bybitBase).replace(queryParameters: {
      'locale': 'en-US',
      'type': 'latest_activities',
      'limit': '$clamped',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _httpError('Bybit', res.statusCode);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['retCode'] != 0) {
      return _bizError(body['retMsg'] ?? 'Bybit error');
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
    return _okResponse(
      exchange: 'bybit',
      total: result['total'] ?? prepared.length,
      items: await _translateEvents(prepared),
    );
  } catch (e, st) {
    return _catchError('bybit', e, st);
  }
}

Future<Response> _binanceEventsHandler(Request request) async {
  final clamped = _limitFrom(request);
  try {
    final uri = Uri.parse(_binanceBase).replace(queryParameters: {
      'type': '1',
      'catalogId': '93',
      'pageNo': '1',
      'pageSize': '$clamped',
    });
    final res = await http
        .get(uri, headers: {
          ..._browserHeaders,
          'Origin': 'https://www.binance.com',
          'Referer': 'https://www.binance.com/en/support/announcement',
          'clienttype': 'web',
          'lang': 'en',
        })
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _httpError('Binance', res.statusCode);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '000000') {
      return _bizError(body['message']?.toString() ?? 'Binance error');
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
        .take(clamped)
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
            : 'https://www.binance.com/en/support/announcement/detail/$code',
        dateTimestamp: releaseDate,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: releaseDate,
      );
    }).toList();
    return _okResponse(
      exchange: 'binance',
      total: _asInt(activities?['total']) ?? prepared.length,
      items: await _translateEvents(prepared),
    );
  } catch (e, st) {
    return _catchError('binance', e, st);
  }
}

Future<Response> _okxEventsHandler(Request request) async {
  final clamped = _limitFrom(request);
  try {
    final uri = Uri.parse(_okxBase).replace(queryParameters: {
      'annType': 'latest-events',
      'page': '1',
    });
    final res = await http
        .get(uri, headers: {
          ..._browserHeaders,
          'Accept-Language': 'en-US',
        })
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _httpError('OKX', res.statusCode);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '0') {
      return _bizError(body['msg']?.toString() ?? 'OKX error');
    }
    final pages = (body['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final page = pages.isNotEmpty ? pages.first : <String, dynamic>{};
    final details = (page['details'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .take(clamped)
        .toList();
    final totalPage = int.tryParse(page['totalPage']?.toString() ?? '') ?? 1;
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
    return _okResponse(
      exchange: 'okx',
      total: totalPage * 20,
      items: await _translateEvents(prepared),
    );
  } catch (e, st) {
    return _catchError('okx', e, st);
  }
}

Future<Response> _upbitEventsHandler(Request request) async {
  final clamped = _limitFrom(request);
  try {
    // category=event → 이벤트성 공지 (이미 한국어)
    final uri = Uri.parse(_upbitBase).replace(queryParameters: {
      'os': 'web',
      'page': '1',
      'per_page': '$clamped',
      'category': 'event',
    });
    final res = await http
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _httpError('Upbit', res.statusCode);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      return _bizError('Upbit error');
    }
    final data = body['data'] as Map<String, dynamic>? ?? {};
    final notices = (data['notices'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final prepared = notices.map((raw) {
      final id = raw['id'];
      final title = (raw['title'] as String?)?.trim() ?? '';
      final category = (raw['category'] as String?) ?? '이벤트';
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
    // Already Korean → translation helper will pass through.
    return _okResponse(
      exchange: 'upbit',
      total: _asInt(data['total_count']) ?? prepared.length,
      items: await _translateEvents(prepared),
    );
  } catch (e, st) {
    return _catchError('upbit', e, st);
  }
}

Future<Response> _bithumbEventsHandler(Request request) async {
  final clamped = _limitFrom(request);
  try {
    final uri = Uri.parse(_bithumbBase).replace(queryParameters: {
      'count': '$clamped',
    });
    final res = await http
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _httpError('Bithumb', res.statusCode);
    }
    final list = (jsonDecode(res.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final prepared = list.map((raw) {
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
        typeTitle: categories.isNotEmpty ? categories.first : '공지',
        tags: categories.isEmpty ? const ['공지'] : categories,
        url: (raw['pc_url'] as String?) ?? 'https://feed.bithumb.com/notice',
        dateTimestamp: published,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: published,
      );
    }).toList();
    return _okResponse(
      exchange: 'bithumb',
      total: prepared.length,
      items: await _translateEvents(prepared),
    );
  } catch (e, st) {
    return _catchError('bithumb', e, st);
  }
}

Future<Response> _bitgetEventsHandler(Request request) async {
  final clamped = _limitFrom(request);
  try {
    final uri = Uri.parse(_bitgetBase).replace(queryParameters: {
      'language': 'en_US',
      'pageNo': '1',
      'pageSize': '$clamped',
      'annType': 'latest_news',
    });
    final res = await http
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _httpError('Bitget', res.statusCode);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '00000') {
      return _bizError(body['msg']?.toString() ?? 'Bitget error');
    }
    final list = (body['data'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .take(clamped)
        .toList();
    final prepared = list.map((raw) {
      final cTime = _asInt(raw['cTime']);
      return _RawEvent(
        exchange: 'bitget',
        title: (raw['annTitle'] as String?)?.trim() ?? '',
        description: '',
        typeKey: (raw['annType'] as String?) ?? 'latest_news',
        typeTitle: (raw['annDesc'] as String?) ?? 'Latest news',
        tags: [
          (raw['annType'] as String?) ?? 'latest_news',
        ],
        url: (raw['annUrl'] as String?) ?? 'https://www.bitget.com/support',
        dateTimestamp: cTime,
        startDateTimestamp: null,
        endDateTimestamp: null,
        publishTime: cTime,
      );
    }).toList();
    return _okResponse(
      exchange: 'bitget',
      total: prepared.length,
      items: await _translateEvents(prepared),
    );
  } catch (e, st) {
    return _catchError('bitget', e, st);
  }
}

int _limitFrom(Request request) {
  final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 20;
  return limit.clamp(1, 50);
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

/// Parses ISO or `yyyy-MM-dd HH:mm:ss` as Asia/Seoul local wall time → ms.
int? _parseKoreaDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final normalized = raw.trim().replaceFirst(' ', 'T');
  final parsed = DateTime.tryParse(normalized);
  if (parsed == null) return null;
  if (parsed.isUtc || raw.contains('+') || raw.endsWith('Z')) {
    return parsed.toUtc().millisecondsSinceEpoch;
  }
  // Treat naive datetime as KST (UTC+9).
  return parsed.toUtc().subtract(const Duration(hours: 9)).millisecondsSinceEpoch;
}

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

Future<List<Map<String, dynamic>>> _translateEvents(
  List<_RawEvent> prepared,
) async {
  final items = <Map<String, dynamic>>[];
  const batchSize = 3;
  for (var i = 0; i < prepared.length; i += batchSize) {
    final batch = prepared.sublist(
      i,
      (i + batchSize > prepared.length) ? prepared.length : i + batchSize,
    );
    final translated = await Future.wait(batch.map((item) async {
      final titleKo = await _translateToKo(item.title);
      final descriptionKo = await _translateToKo(item.description);
      return {
        'exchange': item.exchange,
        'title': item.title,
        'titleKo': titleKo,
        'description': item.description,
        'descriptionKo': descriptionKo,
        'typeKey': item.typeKey,
        'typeTitle': item.typeTitle,
        'tags': item.tags,
        'tagsKo': item.tags,
        'url': item.url,
        // Images are resolved asynchronously via /api/event-image.
        'imageUrl': null,
        'dateTimestamp': item.dateTimestamp,
        'startDateTimestamp': item.startDateTimestamp,
        'endDateTimestamp': item.endDateTimestamp,
        'publishTime': item.publishTime,
      };
    }));
    items.addAll(translated);
  }
  return items;
}

Future<Response> _eventImageHandler(Request request) async {
  final exchange = request.url.queryParameters['exchange']?.trim() ?? '';
  final url = request.url.queryParameters['url']?.trim() ?? '';
  if (exchange.isEmpty || url.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'error': 'exchange and url are required'}),
      headers: _jsonHeaders,
    );
  }

  try {
    final imageUrl = await _resolveEventImage(exchange: exchange, url: url);
    return Response.ok(
      jsonEncode({
        'exchange': exchange,
        'url': url,
        'imageUrl': imageUrl,
      }),
      headers: _jsonHeaders,
    );
  } catch (e, st) {
    return _catchError('event-image', e, st);
  }
}

/// Proxies remote images so Flutter web can display them without CDN CORS.
Future<Response> _imageProxyHandler(Request request) async {
  final url = request.url.queryParameters['url']?.trim() ?? '';
  final uri = Uri.tryParse(url);
  if (uri == null ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.host.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'error': 'valid url is required'}),
      headers: _jsonHeaders,
    );
  }

  try {
    final res = await http.get(
      uri,
      headers: {
        ..._browserHeaders,
        'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
        'Referer': '${uri.scheme}://${uri.host}/',
      },
    ).timeout(const Duration(seconds: 20));
    if (res.statusCode < 200 || res.statusCode >= 400) {
      return Response(res.statusCode, body: 'upstream image fetch failed');
    }
    final contentType = res.headers['content-type'] ?? 'image/jpeg';
    return Response.ok(
      res.bodyBytes,
      headers: {
        'content-type': contentType,
        'cache-control': 'public, max-age=86400',
      },
    );
  } catch (e, st) {
    return _catchError('image-proxy', e, st);
  }
}

Future<String?> _resolveEventImage({
  required String exchange,
  required String url,
}) async {
  if (url.trim().isEmpty) return null;
  if (_imageCache.containsKey(url)) return _imageCache[url];

  String? image;
  try {
    switch (exchange) {
      case 'upbit':
        image = await _upbitNoticeImage(url);
      case 'binance':
        image = await _binanceArticleImage(url);
      case 'bybit':
      case 'okx':
      case 'bithumb':
        image = await _ogImage(url);
      case 'bitget':
        image = await _ogImage(url);
        // Bitget often returns a site-wide default OG image.
        if (image != null && image.contains('open_graph_new')) {
          image = null;
        }
      default:
        image = await _ogImage(url);
    }
  } catch (e) {
    stderr.writeln('image resolve failed ($exchange): $e');
  }

  _imageCache[url] = image;
  return image;
}

Future<String?> _ogImage(String pageUrl) async {
  final res = await http.get(
    Uri.parse(pageUrl),
    headers: {
      ..._browserHeaders,
      'Accept': 'text/html,application/xhtml+xml',
    },
  ).timeout(const Duration(seconds: 12));
  if (res.statusCode < 200 || res.statusCode >= 400) return null;
  final html = res.body;
  final patterns = <RegExp>[
    RegExp(
      'property=["\']og:image["\'][^>]*content=["\']([^"\']+)["\']',
      caseSensitive: false,
    ),
    RegExp(
      'content=["\']([^"\']+)["\'][^>]*property=["\']og:image["\']',
      caseSensitive: false,
    ),
    RegExp(
      'name=["\']twitter:image["\'][^>]*content=["\']([^"\']+)["\']',
      caseSensitive: false,
    ),
  ];
  for (final pattern in patterns) {
    final match = pattern.firstMatch(html);
    if (match != null) {
      final value = match.group(1)?.trim();
      if (value != null && value.startsWith('http')) return value;
    }
  }
  return null;
}

Future<String?> _upbitNoticeImage(String pageUrl) async {
  final id = Uri.tryParse(pageUrl)?.queryParameters['id'];
  if (id == null || id.isEmpty) return _ogImage(pageUrl);
  final uri = Uri.parse('$_upbitBase/$id').replace(
    queryParameters: {'os': 'web'},
  );
  final res = await http
      .get(uri, headers: _browserHeaders)
      .timeout(const Duration(seconds: 12));
  if (res.statusCode != 200) return null;
  final body = jsonDecode(res.body) as Map<String, dynamic>;
  final data = body['data'] as Map<String, dynamic>? ?? body;
  final shared = data['shared_resources'] as Map<String, dynamic>?;
  final image = shared?['image_url']?.toString();
  if (image != null && image.startsWith('http')) return image;
  return null;
}

Future<String?> _binanceArticleImage(String pageUrl) async {
  final code = Uri.tryParse(pageUrl)?.pathSegments.isNotEmpty == true
      ? Uri.parse(pageUrl).pathSegments.last
      : null;
  if (code == null || code.isEmpty) return _ogImage(pageUrl);
  final uri = Uri.parse(
    'https://www.binance.com/bapi/composite/v1/public/cms/article/detail/query',
  ).replace(queryParameters: {'articleCode': code});
  final res = await http.get(uri, headers: {
    ..._browserHeaders,
    'Origin': 'https://www.binance.com',
    'Referer': 'https://www.binance.com/en/support/announcement',
    'clienttype': 'web',
    'lang': 'en',
  }).timeout(const Duration(seconds: 12));
  if (res.statusCode != 200) return null;
  final body = jsonDecode(res.body) as Map<String, dynamic>;
  final data = body['data'];
  if (data is! Map<String, dynamic>) return null;
  final found = <String>[];
  void walk(dynamic node) {
    if (node is Map) {
      for (final entry in node.entries) {
        final key = entry.key.toString().toLowerCase();
        final value = entry.value;
        if ((key == 'src' || key == 'url' || key == 'image') &&
            value is String &&
            value.startsWith('http') &&
            _looksLikeImageUrl(value)) {
          found.add(value);
        } else {
          walk(value);
        }
      }
    } else if (node is List) {
      for (final item in node) {
        walk(item);
      }
    } else if (node is String && node.startsWith('{')) {
      try {
        walk(jsonDecode(node));
      } catch (_) {}
    }
  }

  walk(data['body']);
  walk(data['contentJson']);
  if (found.isNotEmpty) return found.first;
  return null;
}

bool _looksLikeImageUrl(String url) {
  final lower = url.toLowerCase();
  return lower.contains('.png') ||
      lower.contains('.jpg') ||
      lower.contains('.jpeg') ||
      lower.contains('.webp') ||
      lower.contains('.gif') ||
      lower.contains('/image/');
}

Future<String> _translateToKo(String text) async {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return trimmed;
  if (_looksMostlyKorean(trimmed)) return trimmed;

  final cached = _translationCache[trimmed];
  if (cached != null) return cached;

  try {
    final chunk = trimmed.length > 450 ? trimmed.substring(0, 450) : trimmed;
    final uri = Uri.parse(_translateBase).replace(queryParameters: {
      'q': chunk,
      'langpair': 'en|ko',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final translated =
          (data['responseData'] as Map<String, dynamic>?)?['translatedText']
              as String?;
      if (translated != null && translated.trim().isNotEmpty) {
        _translationCache[trimmed] = translated.trim();
        return translated.trim();
      }
    }
  } catch (e) {
    stderr.writeln('translate failed: $e');
  }
  return trimmed;
}

bool _looksMostlyKorean(String text) {
  final ko = RegExp(r'[\uac00-\ud7a3]').allMatches(text).length;
  final letters = RegExp(r'[A-Za-z\uac00-\ud7a3]').allMatches(text).length;
  if (letters == 0) return false;
  return ko / letters > 0.4;
}

Response _okResponse({
  required String exchange,
  required Object total,
  required List<Map<String, dynamic>> items,
}) {
  return Response.ok(
    jsonEncode({
      'exchange': exchange,
      'total': total,
      'items': items,
    }),
    headers: _jsonHeaders,
  );
}

Response _httpError(String name, int status) {
  return Response.internalServerError(
    body: jsonEncode({'error': '$name HTTP $status'}),
    headers: _jsonHeaders,
  );
}

Response _bizError(Object message) {
  return Response.internalServerError(
    body: jsonEncode({'error': message.toString()}),
    headers: _jsonHeaders,
  );
}

Response _catchError(String name, Object e, StackTrace st) {
  stderr.writeln('$name events error: $e\n$st');
  return Response.internalServerError(
    body: jsonEncode({'error': e.toString()}),
    headers: _jsonHeaders,
  );
}

/// Flexible USDT Earn across exchanges (public sources only).
Future<Response> _flexibleUsdtEarnHandler(Request request) async {
  try {
    final results = await Future.wait([
      _fetchBybitFlexibleUsdt(),
      _fetchBinanceFlexibleUsdt(),
      _fetchOkxFlexibleUsdt(),
      Future.value(_unavailableEarn(
        exchange: 'bitget',
        note: 'Bitget Savings 상품 조회는 API 키가 필요합니다.',
      )),
      Future.value(_unavailableEarn(
        exchange: 'upbit',
        note: '업비트는 공개 Flexible USDT Earn API가 없습니다.',
      )),
      Future.value(_unavailableEarn(
        exchange: 'bithumb',
        note: '빗썸은 공개 Flexible USDT Earn API가 없습니다.',
      )),
    ]);

    return Response.ok(
      jsonEncode({
        'productType': 'flexible',
        'coin': 'USDT',
        'fetchedAt': DateTime.now().toUtc().toIso8601String(),
        'items': results,
      }),
      headers: _jsonHeaders,
    );
  } catch (e, st) {
    return _catchError('earn', e, st);
  }
}

Map<String, dynamic> _unavailableEarn({
  required String exchange,
  required String note,
}) {
  return {
    'exchange': exchange,
    'coin': 'USDT',
    'productType': 'flexible',
    'available': false,
    'aprPercent': null,
    'aprDisplay': null,
    'minAmount': null,
    'status': null,
    'productId': null,
    'tiers': <Map<String, dynamic>>[],
    'note': note,
  };
}

Future<Map<String, dynamic>> _fetchBybitFlexibleUsdt() async {
  try {
    final uri = Uri.parse(
      'https://api.bybit.com/v5/earn/product',
    ).replace(queryParameters: {
      'category': 'FlexibleSaving',
      'coin': 'USDT',
    });
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _unavailableEarn(
        exchange: 'bybit',
        note: 'Bybit HTTP ${res.statusCode}',
      );
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['retCode'] != 0) {
      return _unavailableEarn(
        exchange: 'bybit',
        note: body['retMsg']?.toString() ?? 'Bybit error',
      );
    }
    final list = ((body['result'] as Map?)?['list'] as List?) ?? [];
    if (list.isEmpty) {
      return _unavailableEarn(exchange: 'bybit', note: 'USDT Flexible 상품 없음');
    }
    final raw = list.first as Map<String, dynamic>;
    final aprDisplay = (raw['estimateApr'] as String?) ?? '';
    final tiers = <Map<String, dynamic>>[];
    for (final tier in (raw['tierAprDetails'] as List? ?? [])) {
      final t = tier as Map<String, dynamic>;
      tiers.add({
        'min': t['min']?.toString(),
        'max': t['max']?.toString(),
        'aprDisplay': t['estimateApr']?.toString(),
      });
    }
    return {
      'exchange': 'bybit',
      'coin': 'USDT',
      'productType': 'flexible',
      'available': true,
      'aprPercent': _parsePercentNumber(aprDisplay),
      'aprDisplay': aprDisplay,
      'minAmount': raw['minStakeAmount']?.toString(),
      'maxAmount': raw['maxStakeAmount']?.toString(),
      'status': raw['status']?.toString(),
      'productId': raw['productId']?.toString(),
      'hasTieredApr': raw['hasTieredApr'] == true,
      'tiers': tiers,
      'note': tiers.isNotEmpty ? '금액 구간에 따라 적용 APR이 달라질 수 있습니다.' : null,
    };
  } catch (e) {
    return _unavailableEarn(exchange: 'bybit', note: e.toString());
  }
}

Future<Map<String, dynamic>> _fetchBinanceFlexibleUsdt() async {
  try {
    final uri = Uri.parse(
      'https://www.binance.com/bapi/earn/v1/friendly/lending/daily/product/list',
    ).replace(queryParameters: {
      'pageSize': '5',
      'pageIndex': '1',
      'asset': 'USDT',
    });
    final res = await http.get(uri, headers: {
      ..._browserHeaders,
      'Origin': 'https://www.binance.com',
      'Referer': 'https://www.binance.com/en/earn',
      'clienttype': 'web',
      'lang': 'en',
    }).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _unavailableEarn(
        exchange: 'binance',
        note: 'Binance HTTP ${res.statusCode}',
      );
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '000000') {
      return _unavailableEarn(
        exchange: 'binance',
        note: body['message']?.toString() ?? 'Binance error',
      );
    }
    final list = (body['data'] as List? ?? []).cast<Map<String, dynamic>>();
    if (list.isEmpty) {
      return _unavailableEarn(
        exchange: 'binance',
        note: 'USDT Flexible 상품 없음',
      );
    }
    final raw = list.first;
    final latest = _asDouble(raw['latestAnnualInterestRate']);
    final market = _asDouble(raw['marketApr']);
    final tiers = <Map<String, dynamic>>[];
    for (final tier in (raw['tierAnnualInterestRateList'] as List? ?? [])) {
      final t = tier as Map<String, dynamic>;
      final rate = _asDouble(t['annualInterestRate']);
      tiers.add({
        'min': t['beginAmount']?.toString(),
        'max': t['endAmount']?.toString(),
        'aprDisplay': rate == null ? null : '${_fmtPct(rate * 100)}%',
      });
    }
    final aprPercent = latest == null ? null : latest * 100;
    return {
      'exchange': 'binance',
      'coin': 'USDT',
      'productType': 'flexible',
      'available': true,
      'aprPercent': aprPercent,
      'aprDisplay': aprPercent == null ? null : '${_fmtPct(aprPercent)}%',
      'marketAprDisplay':
          market == null ? null : '${_fmtPct(market * 100)}%',
      'minAmount': raw['minPurchaseAmount']?.toString(),
      'maxAmountPerUser': raw['upLimitPerUser']?.toString(),
      'status': raw['status']?.toString(),
      'productId': raw['id']?.toString(),
      'hasTieredApr': raw['hasTierInterest'] == true,
      'tiers': tiers,
      'note': 'Easy Earn Flexible. 고시 APR과 구간별 금리가 다를 수 있습니다.',
    };
  } catch (e) {
    return _unavailableEarn(exchange: 'binance', note: e.toString());
  }
}

Future<Map<String, dynamic>> _fetchOkxFlexibleUsdt() async {
  try {
    final uri = Uri.parse(
      'https://www.okx.com/api/v5/finance/savings/lending-rate-summary',
    ).replace(queryParameters: {'ccy': 'USDT'});
    final res = await http
        .get(uri, headers: _browserHeaders)
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      return _unavailableEarn(
        exchange: 'okx',
        note: 'OKX HTTP ${res.statusCode}',
      );
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['code']?.toString() != '0') {
      return _unavailableEarn(
        exchange: 'okx',
        note: body['msg']?.toString() ?? 'OKX error',
      );
    }
    final list = (body['data'] as List? ?? []).cast<Map<String, dynamic>>();
    if (list.isEmpty) {
      return _unavailableEarn(exchange: 'okx', note: 'USDT Flexible 금리 없음');
    }
    final raw = list.first;
    final est = _asDouble(raw['estRate']);
    final avg = _asDouble(raw['avgRate']);
    final pre = _asDouble(raw['preRate']);
    final aprPercent = est == null ? null : est * 100;
    return {
      'exchange': 'okx',
      'coin': 'USDT',
      'productType': 'flexible',
      'available': true,
      'aprPercent': aprPercent,
      'aprDisplay': aprPercent == null ? null : '${_fmtPct(aprPercent)}%',
      'avgAprDisplay': avg == null ? null : '${_fmtPct(avg * 100)}%',
      'prevAprDisplay': pre == null ? null : '${_fmtPct(pre * 100)}%',
      'minAmount': null,
      'status': 'Available',
      'productId': null,
      'hasTieredApr': false,
      'tiers': <Map<String, dynamic>>[],
      'note': 'OKX Simple Earn / Savings 추정·평균 금리(연율, 소수→%).',
    };
  } catch (e) {
    return _unavailableEarn(exchange: 'okx', note: e.toString());
  }
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

double? _parsePercentNumber(String raw) {
  final cleaned = raw.trim().replaceAll('%', '');
  return double.tryParse(cleaned);
}

String _fmtPct(double value) {
  if (value >= 10) return value.toStringAsFixed(2);
  if (value >= 1) return value.toStringAsFixed(2);
  return value.toStringAsFixed(3);
}
