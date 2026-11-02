import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exchange_events_service.dart';

class EventImageResolver {
  EventImageResolver({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final _cache = <String, String?>{};

  static const _browserHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml',
    'Accept-Language': 'en-US,en;q=0.9,ko;q=0.8',
  };

  Future<String?> resolve({
    required Exchange exchange,
    required String url,
  }) async {
    if (url.trim().isEmpty) return null;
    if (_cache.containsKey(url)) return _cache[url];

    String? image;
    try {
      image = switch (exchange) {
        Exchange.upbit => await _upbitNoticeImage(url),
        Exchange.binance => await _binanceArticleImage(url),
        Exchange.bitget => await _bitgetOg(url),
        _ => await _ogImage(url),
      };
    } catch (_) {
      image = null;
    }
    _cache[url] = image;
    return image;
  }

  Future<String?> _bitgetOg(String url) async {
    final image = await _ogImage(url);
    if (image != null && image.contains('open_graph_new')) return null;
    return image;
  }

  Future<String?> _ogImage(String pageUrl) async {
    final res = await _client
        .get(Uri.parse(pageUrl), headers: _browserHeaders)
        .timeout(const Duration(seconds: 12));
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
      final value = match?.group(1)?.trim();
      if (value != null && value.startsWith('http')) return value;
    }
    return null;
  }

  Future<String?> _upbitNoticeImage(String pageUrl) async {
    final id = Uri.tryParse(pageUrl)?.queryParameters['id'];
    if (id == null || id.isEmpty) return _ogImage(pageUrl);
    final uri = Uri.parse(
      'https://api-manager.upbit.com/api/v1/announcements/$id',
    ).replace(queryParameters: {'os': 'web'});
    final res = await _client
        .get(
          uri,
          headers: {
            ..._browserHeaders,
            'Accept': 'application/json, text/plain, */*',
          },
        )
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
    final segments = Uri.tryParse(pageUrl)?.pathSegments ?? const [];
    final code = segments.isNotEmpty ? segments.last : null;
    if (code == null || code.isEmpty) return _ogImage(pageUrl);
    final uri = Uri.parse(
      'https://www.binance.com/bapi/composite/v1/public/cms/article/detail/query',
    ).replace(queryParameters: {'articleCode': code});
    final res = await _client
        .get(
          uri,
          headers: {
            ..._browserHeaders,
            'Accept': 'application/json, text/plain, */*',
            'Origin': 'https://www.binance.com',
            'Referer': 'https://www.binance.com/en/support/announcement',
            'clienttype': 'web',
            'lang': 'en',
          },
        )
        .timeout(const Duration(seconds: 12));
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
}
