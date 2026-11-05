import '../models/exchange_event.dart';
import '../models/opportunity.dart';

/// Client-side heuristics: turn announcement feeds into trading-contest cards.
abstract final class ContestMatcher {
  static final _keywords = <String>[
    'tournament',
    'contest',
    'competition',
    'championship',
    'wsot',
    'trade to share',
    'trade to win',
    'trading competition',
    'trading tournament',
    'spot trading tournament',
    'futures tournament',
    '거래 대회',
    '거래대회',
    '토너먼트',
    '트레이딩 대회',
    '交易大赛',
    '交易赛',
    '锦标赛',
    'コンテスト',
    'トレーディング大会',
  ];

  static final _exclude = <String>[
    'maintenance',
    'wallet maintenance',
    'delist',
    'will list',
    'will support',
    'hard fork',
    'api update',
    '점검',
    '상장 안내',
  ];

  static bool looksLikeContest(ExchangeEvent event) {
    final hay = [
      event.title,
      event.titleKo,
      event.description,
      event.descriptionKo,
      event.typeTitle,
      ...event.tags,
      ...event.tagsKo,
    ].join(' ').toLowerCase();
    if (hay.trim().isEmpty) return false;
    if (_exclude.any(hay.contains)) return false;
    return _keywords.any(hay.contains);
  }

  static Opportunity toOpportunity(ExchangeEvent event) {
    final title = event.displayTitle.trim().isNotEmpty
        ? event.displayTitle.trim()
        : event.title.trim();
    final reward = _guessReward(title) ?? '원문 확인';
    final ends = event.endAt;
    final starts = event.startAt;
    final now = DateTime.now();
    final status = () {
      if (ends != null && !ends.isAfter(now)) return OpportunityStatus.ended;
      if (starts != null && starts.isAfter(now)) {
        return OpportunityStatus.upcoming;
      }
      if (ends != null && ends.difference(now).inHours <= 72) {
        return OpportunityStatus.endingSoon;
      }
      return OpportunityStatus.live;
    }();

    final idSeed = event.url.isNotEmpty ? event.url : title;
    return Opportunity(
      id: 'live:${event.exchange}:${idSeed.hashCode.toUnsigned(32).toRadixString(16)}',
      exchange: event.exchange,
      titleKo: title,
      titleEn: event.title.trim().isNotEmpty ? event.title.trim() : null,
      summaryKo: event.displayDescription.trim().isNotEmpty
          ? event.displayDescription.trim()
          : title,
      type: OpportunityType.tradingContest,
      rewardLabel: reward,
      startsAt: starts,
      endsAt: ends,
      status: status,
      eligibilityKo: '공식 공지 조건 확인',
      tasksKo: const ['공식 페이지에서 참여 조건 확인', '거래소 계정으로 참여'],
      officialUrl: event.url,
      sourceNoticeUrl: event.url,
      reviewedAt: DateTime.now().toUtc(),
      asOf: DateTime.now().toUtc(),
      reviewStatus: 'live',
    );
  }

  static String? _guessReward(String title) {
    final match = RegExp(
      r'(?:up to |share (?:up to )?|최대\s*)?'
      r'(\$?[\d,.]+(?:\s*[KkMm])?\s*(?:USDT|USDC|USD|BNB|BTC|ETH|\$)?)',
      caseSensitive: false,
    ).firstMatch(title);
    final value = match?.group(1)?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.length > 40) return null;
    return value;
  }
}
