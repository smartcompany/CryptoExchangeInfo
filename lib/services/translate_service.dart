import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TranslateService {
  TranslateService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final _cache = <String, String>{};

  static final _ko = RegExp(r'[\uac00-\ud7a3]');
  static final _ja = RegExp(r'[\u3040-\u30ff\u31f0-\u31ff]');
  static final _zh = RegExp(r'[\u4e00-\u9fff]');
  static final _latin = RegExp(r'[A-Za-z]');
  static final _letters = RegExp(
    r'[A-Za-z\uac00-\ud7a3\u3040-\u30ff\u31f0-\u31ff\u4e00-\u9fff]',
  );

  /// App-supported language codes.
  static const supported = {'en', 'ko', 'zh', 'ja'};

  /// Translates [text] into the active app locale (or [targetLanguage]).
  /// Skips the network call when the text already matches the target language.
  Future<String> translate(String text, {String? targetLanguage}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;

    final target = normalizeLang(
      targetLanguage ?? PlatformDispatcher.instance.locale.languageCode,
    );
    final source = detectLanguage(trimmed);
    if (source == target) return trimmed;

    final cacheKey = '$source>$target::$trimmed';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final chunk = trimmed.length > 450 ? trimmed.substring(0, 450) : trimmed;

    // Prefer Google gtx (more reliable). MyMemory often returns 429 under load.
    final viaGtx = await _translateGtx(chunk, source: source, target: target);
    if (viaGtx != null) {
      _cache[cacheKey] = viaGtx;
      return viaGtx;
    }

    final viaMyMemory = await _translateMyMemory(
      chunk,
      source: source,
      target: target,
    );
    if (viaMyMemory != null) {
      _cache[cacheKey] = viaMyMemory;
      return viaMyMemory;
    }

    debugPrint(
      '[Translate] failed $source->$target '
      'text="${chunk.length > 40 ? '${chunk.substring(0, 40)}…' : chunk}"',
    );
    return trimmed;
  }

  /// Back-compat helper; prefer [translate].
  Future<String> toKo(String text) => translate(text, targetLanguage: 'ko');

  static String normalizeLang(String raw) {
    final code = raw.toLowerCase().split(RegExp(r'[_-]')).first;
    if (supported.contains(code)) return code;
    return 'en';
  }

  static String detectLanguage(String text) {
    final ko = _ko.allMatches(text).length;
    final ja = _ja.allMatches(text).length;
    final zh = _zh.allMatches(text).length;
    final latin = _latin.allMatches(text).length;
    final letters = _letters.allMatches(text).length;
    if (letters == 0) return 'en';

    // Any Hangul ⇒ Korean (Upbit/Bithumb titles are often mostly Hangul).
    if (ko > 0) return 'ko';
    if (ja / letters > 0.12) return 'ja';
    if (zh / letters > 0.35) return 'zh';
    if (latin / letters > 0.5) return 'en';
    if (zh > 0) return 'zh';
    if (ja > 0) return 'ja';
    return 'en';
  }

  Future<String?> _translateGtx(
    String text, {
    required String source,
    required String target,
  }) async {
    try {
      final uri =
          Uri.parse(
            'https://translate.googleapis.com/translate_a/single',
          ).replace(
            queryParameters: {
              'client': 'gtx',
              'sl': _gtxCode(source),
              'tl': _gtxCode(target),
              'dt': 't',
              'q': text,
            },
          );
      final res = await _client
          .get(
            uri,
            headers: const {
              'User-Agent':
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
              'Accept': '*/*',
            },
          )
          .timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return null;
      final decoded = jsonDecode(res.body);
      if (decoded is! List || decoded.isEmpty || decoded.first is! List) {
        return null;
      }
      final buf = StringBuffer();
      for (final part in decoded.first as List) {
        if (part is List && part.isNotEmpty && part.first is String) {
          buf.write(part.first as String);
        }
      }
      final value = buf.toString().trim();
      if (value.isEmpty) return null;
      return value;
    } catch (error) {
      debugPrint('[Translate] gtx error: $error');
      return null;
    }
  }

  Future<String?> _translateMyMemory(
    String text, {
    required String source,
    required String target,
  }) async {
    try {
      final uri = Uri.parse('https://api.mymemory.translated.net/get').replace(
        queryParameters: {
          'q': text,
          'langpair': '${_mymemoryCode(source)}|${_mymemoryCode(target)}',
        },
      );
      final res = await _client.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final translated =
          (data['responseData'] as Map<String, dynamic>?)?['translatedText']
              as String?;
      if (translated == null || translated.trim().isEmpty) return null;
      final value = translated.trim();
      if (value.toUpperCase().contains('INVALID') ||
          value.toUpperCase().contains('PLEASE SELECT') ||
          value.toUpperCase().contains('MYMEMORY WARNING')) {
        return null;
      }
      return value;
    } catch (error) {
      debugPrint('[Translate] mymemory error: $error');
      return null;
    }
  }

  String _mymemoryCode(String lang) => switch (lang) {
    'zh' => 'zh-CN',
    _ => lang,
  };

  String _gtxCode(String lang) => switch (lang) {
    'zh' => 'zh-CN',
    _ => lang,
  };
}
