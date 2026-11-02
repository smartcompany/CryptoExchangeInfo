enum OpportunityType {
  /// Exchange announcement feed (API notices).
  event,
  tradingContest,
  earnBoost,
  depositBonus,
  convertChallenge,
  dualChallenge,
  feePromo,
  listing,
  other;

  static OpportunityType fromWire(String? value) {
    return switch (value) {
      'event' => OpportunityType.event,
      'trading_contest' => OpportunityType.tradingContest,
      'earn_boost' => OpportunityType.earnBoost,
      'deposit_bonus' => OpportunityType.depositBonus,
      'convert_challenge' => OpportunityType.convertChallenge,
      'dual_challenge' => OpportunityType.dualChallenge,
      'fee_promo' => OpportunityType.feePromo,
      'listing' => OpportunityType.listing,
      _ => OpportunityType.other,
    };
  }

  String get wire => switch (this) {
    OpportunityType.event => 'event',
    OpportunityType.tradingContest => 'trading_contest',
    OpportunityType.earnBoost => 'earn_boost',
    OpportunityType.depositBonus => 'deposit_bonus',
    OpportunityType.convertChallenge => 'convert_challenge',
    OpportunityType.dualChallenge => 'dual_challenge',
    OpportunityType.feePromo => 'fee_promo',
    OpportunityType.listing => 'listing',
    OpportunityType.other => 'other',
  };

  String get labelKo => switch (this) {
    OpportunityType.event => '이벤트',
    OpportunityType.tradingContest => '거래대회',
    OpportunityType.earnBoost => 'Earn부스트',
    OpportunityType.depositBonus => '입금보너스',
    OpportunityType.convertChallenge => 'Convert',
    OpportunityType.dualChallenge => '듀얼',
    OpportunityType.feePromo => '수수료',
    OpportunityType.listing => '상장',
    OpportunityType.other => '기타',
  };
}

enum OpportunityStatus {
  upcoming,
  live,
  endingSoon,
  ended;

  static OpportunityStatus fromWire(String? value) {
    return switch (value) {
      'upcoming' => OpportunityStatus.upcoming,
      'ending_soon' => OpportunityStatus.endingSoon,
      'ended' => OpportunityStatus.ended,
      _ => OpportunityStatus.live,
    };
  }

  String get wire => switch (this) {
    OpportunityStatus.upcoming => 'upcoming',
    OpportunityStatus.live => 'live',
    OpportunityStatus.endingSoon => 'ending_soon',
    OpportunityStatus.ended => 'ended',
  };

  String get labelKo => switch (this) {
    OpportunityStatus.upcoming => '예정',
    OpportunityStatus.live => '진행중',
    OpportunityStatus.endingSoon => '곧마감',
    OpportunityStatus.ended => '종료',
  };
}

class Opportunity {
  const Opportunity({
    required this.id,
    required this.exchange,
    required this.titleKo,
    required this.summaryKo,
    required this.type,
    required this.rewardLabel,
    required this.status,
    required this.eligibilityKo,
    required this.tasksKo,
    required this.officialUrl,
    this.titleEn,
    this.startsAt,
    this.endsAt,
    this.sourceNoticeUrl,
    this.relatedProductId,
    this.regionNoteKo,
    this.reviewedAt,
    this.asOf,
    this.reviewStatus = 'draft',
  });

  final String id;
  final String exchange;
  final String titleKo;
  final String? titleEn;
  final String summaryKo;
  final OpportunityType type;
  final String rewardLabel;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final OpportunityStatus status;
  final String eligibilityKo;
  final List<String> tasksKo;
  final String officialUrl;
  final String? sourceNoticeUrl;
  final String? relatedProductId;
  final String? regionNoteKo;
  final DateTime? reviewedAt;
  final DateTime? asOf;
  final String reviewStatus;

  /// Days until [endsAt] (0 = today). Null if no end date.
  int? get daysRemaining {
    final end = endsAt;
    if (end == null) return null;
    final now = DateTime.now().toUtc();
    final endUtc = end.toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final endDay = DateTime.utc(endUtc.year, endUtc.month, endUtc.day);
    return endDay.difference(today).inDays;
  }

  String? get dDayLabel {
    final days = daysRemaining;
    if (days == null) return null;
    if (days < 0) return '마감';
    if (days == 0) return 'D-Day';
    return 'D-$days';
  }

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id']?.toString() ?? '',
      exchange: json['exchange']?.toString() ?? '',
      titleKo: json['titleKo']?.toString() ?? '',
      titleEn: json['titleEn']?.toString(),
      summaryKo: json['summaryKo']?.toString() ?? '',
      type: OpportunityType.fromWire(json['type']?.toString()),
      rewardLabel: json['rewardLabel']?.toString() ?? '',
      startsAt: _parseDate(json['startsAt']),
      endsAt: _parseDate(json['endsAt']),
      status: OpportunityStatus.fromWire(json['status']?.toString()),
      eligibilityKo: json['eligibilityKo']?.toString() ?? '',
      tasksKo: (json['tasksKo'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      officialUrl: json['officialUrl']?.toString() ?? '',
      sourceNoticeUrl: json['sourceNoticeUrl']?.toString(),
      relatedProductId: json['relatedProductId']?.toString(),
      regionNoteKo: json['regionNoteKo']?.toString(),
      reviewedAt: _parseDate(json['reviewedAt']),
      asOf: _parseDate(json['asOf']),
      reviewStatus: json['reviewStatus']?.toString() ?? 'draft',
    );
  }

  Opportunity copyWith({
    String? titleKo,
    String? titleEn,
    String? summaryKo,
    String? rewardLabel,
    String? eligibilityKo,
    List<String>? tasksKo,
    String? regionNoteKo,
  }) {
    return Opportunity(
      id: id,
      exchange: exchange,
      titleKo: titleKo ?? this.titleKo,
      titleEn: titleEn ?? this.titleEn,
      summaryKo: summaryKo ?? this.summaryKo,
      type: type,
      rewardLabel: rewardLabel ?? this.rewardLabel,
      startsAt: startsAt,
      endsAt: endsAt,
      status: status,
      eligibilityKo: eligibilityKo ?? this.eligibilityKo,
      tasksKo: tasksKo ?? this.tasksKo,
      officialUrl: officialUrl,
      sourceNoticeUrl: sourceNoticeUrl,
      relatedProductId: relatedProductId,
      regionNoteKo: regionNoteKo ?? this.regionNoteKo,
      reviewedAt: reviewedAt,
      asOf: asOf,
      reviewStatus: reviewStatus,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
