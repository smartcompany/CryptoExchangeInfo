import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/exchange_event.dart';
import '../models/opportunity.dart';
import 'api_auth.dart';
import 'exchange_events_service.dart';
import 'translate_service.dart';

class EventAiAnalysis {
  const EventAiAnalysis({
    required this.summary,
    required this.reward,
    required this.period,
    required this.conditions,
    required this.cautions,
  });

  final String summary;
  final String reward;
  final String period;
  final List<String> conditions;
  final List<String> cautions;

  factory EventAiAnalysis.fromJson(Map<String, dynamic> json) {
    List<String> listOf(dynamic value) {
      if (value is List) {
        return value
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      if (value is String && value.trim().isNotEmpty) {
        return [value.trim()];
      }
      return const [];
    }

    return EventAiAnalysis(
      summary: (json['summary'] as String?)?.trim() ?? '',
      reward: (json['reward'] as String?)?.trim() ?? '',
      period: (json['period'] as String?)?.trim() ?? '',
      conditions: listOf(json['conditions']),
      cautions: listOf(json['cautions']),
    );
  }
}

class EventAiException implements Exception {
  EventAiException({
    required this.message,
    this.statusCode,
    this.uri,
    this.detail,
    this.rawBody,
  });

  final String message;
  final int? statusCode;
  final Uri? uri;
  final String? detail;
  final String? rawBody;

  @override
  String toString() {
    final buf = StringBuffer(message);
    if (statusCode != null) buf.write(' [$statusCode]');
    if (detail != null && detail!.trim().isNotEmpty) {
      buf.write(' — $detail');
    }
    return buf.toString();
  }
}

class EventAiService {
  EventAiService({String? apiBaseUrl, http.Client? client})
    : apiBaseUrl = apiBaseUrl ?? ExchangeEventsService.productionApiBaseUrl,
      _client = client ?? http.Client();

  final String apiBaseUrl;
  final http.Client _client;

  String get _activeLanguage => TranslateService.normalizeLang(
        PlatformDispatcher.instance.locale.languageCode,
      );

  Future<EventAiAnalysis> analyze(ExchangeEvent event) {
    return _post({
      'exchange': event.exchange,
      'title': event.displayTitle,
      'description': event.displayDescription,
      'tags': event.tags,
      'url': event.url,
      'startDateTimestamp': event.startDateTimestamp,
      'endDateTimestamp': event.endDateTimestamp,
      'language': _activeLanguage,
    });
  }

  Future<EventAiAnalysis> analyzeOpportunity(Opportunity opportunity) {
    final description = [
      if (opportunity.summaryKo.trim().isNotEmpty) opportunity.summaryKo.trim(),
      if (opportunity.rewardLabel.trim().isNotEmpty)
        'Reward: ${opportunity.rewardLabel.trim()}',
      if (opportunity.eligibilityKo.trim().isNotEmpty)
        'Eligibility: ${opportunity.eligibilityKo.trim()}',
      if (opportunity.tasksKo.isNotEmpty)
        'Steps: ${opportunity.tasksKo.join(' / ')}',
      if (opportunity.regionNoteKo != null &&
          opportunity.regionNoteKo!.trim().isNotEmpty)
        'Region: ${opportunity.regionNoteKo!.trim()}',
    ].join('\n');

    return _post({
      'exchange': opportunity.exchange,
      'title': opportunity.titleKo.trim().isNotEmpty
          ? opportunity.titleKo
          : (opportunity.titleEn ?? ''),
      'description': description,
      'tags': [opportunity.type.wire, opportunity.status.wire],
      'url': opportunity.officialUrl,
      'startDateTimestamp': opportunity.startsAt?.millisecondsSinceEpoch,
      'endDateTimestamp': opportunity.endsAt?.millisecondsSinceEpoch,
      'language': _activeLanguage,
    });
  }

  Future<EventAiAnalysis> _post(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$apiBaseUrl/api/event-analyze');
    debugPrint('[EventAi] POST $uri language=${payload['language']}');
    debugPrint('[EventAi] payload=${jsonEncode(payload)}');

    late final http.Response res;
    try {
      res = await _client
          .post(
            uri,
            headers: {
              'content-type': 'application/json; charset=utf-8',
              ...ApiAuth.headers,
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 60));
    } catch (error, stackTrace) {
      debugPrint('[EventAi] request failed: $error');
      debugPrint('$stackTrace');
      throw EventAiException(
        message: 'AI 요청 실패: $error',
        uri: uri,
        detail: error.toString(),
      );
    }

    debugPrint('[EventAi] status=${res.statusCode}');
    debugPrint('[EventAi] body=${res.body}');

    Map<String, dynamic>? body;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    } catch (error) {
      debugPrint('[EventAi] JSON parse error: $error');
      throw EventAiException(
        message: 'AI 응답 JSON 파싱 실패 (${res.statusCode})',
        statusCode: res.statusCode,
        uri: uri,
        detail: error.toString(),
        rawBody: res.body,
      );
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final error = body?['error']?.toString() ?? 'AI 분석 실패';
      final detail = body?['detail']?.toString();
      debugPrint('[EventAi] server error: $error');
      if (detail != null && detail.isNotEmpty) {
        debugPrint('[EventAi] server detail: $detail');
      }
      throw EventAiException(
        message: error,
        statusCode: res.statusCode,
        uri: uri,
        detail: detail,
        rawBody: res.body,
      );
    }

    final analysis = body?['analysis'];
    if (analysis is! Map<String, dynamic>) {
      debugPrint('[EventAi] missing analysis field in body=$body');
      throw EventAiException(
        message: 'AI 응답 형식이 올바르지 않습니다.',
        statusCode: res.statusCode,
        uri: uri,
        detail: 'analysis field missing or invalid',
        rawBody: res.body,
      );
    }
    return EventAiAnalysis.fromJson(analysis);
  }
}
