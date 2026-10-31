class EarnTier {
  const EarnTier({
    required this.min,
    required this.max,
    required this.aprDisplay,
  });

  final String? min;
  final String? max;
  final String? aprDisplay;

  factory EarnTier.fromJson(Map<String, dynamic> json) {
    return EarnTier(
      min: json['min']?.toString(),
      max: json['max']?.toString(),
      aprDisplay: json['aprDisplay']?.toString(),
    );
  }

  String get rangeLabel {
    final start = min ?? '?';
    final end = (max == null || max == '-1' || max == '') ? '∞' : max!;
    return '$start ~ $end USDT';
  }
}

class EarnProduct {
  const EarnProduct({
    required this.exchange,
    required this.coin,
    required this.productType,
    required this.available,
    required this.tiers,
    this.aprPercent,
    this.aprDisplay,
    this.marketAprDisplay,
    this.avgAprDisplay,
    this.prevAprDisplay,
    this.minAmount,
    this.maxAmount,
    this.maxAmountPerUser,
    this.status,
    this.productId,
    this.hasTieredApr = false,
    this.note,
  });

  final String exchange;
  final String coin;
  final String productType;
  final bool available;
  final double? aprPercent;
  final String? aprDisplay;
  final String? marketAprDisplay;
  final String? avgAprDisplay;
  final String? prevAprDisplay;
  final String? minAmount;
  final String? maxAmount;
  final String? maxAmountPerUser;
  final String? status;
  final String? productId;
  final bool hasTieredApr;
  final List<EarnTier> tiers;
  final String? note;

  String get exchangeLabel => switch (exchange) {
        'bybit' => '바이비트',
        'binance' => '바이낸스',
        'okx' => 'OKX',
        'upbit' => '업비트',
        'bithumb' => '빗썸',
        'bitget' => 'Bitget',
        _ => exchange,
      };

  /// Official Flexible / Earn page for this exchange.
  String? get earnPageUrl => switch (exchange) {
        'bybit' => 'https://www.bybit.com/earn/savings',
        'binance' => 'https://www.binance.com/en/simple-earn',
        'okx' => 'https://www.okx.com/earn',
        'bitget' => 'https://www.bitget.com/earn/savings',
        'upbit' => 'https://upbit.com/earn',
        'bithumb' => 'https://www.bithumb.com/react/earn',
        _ => null,
      };

  factory EarnProduct.fromJson(Map<String, dynamic> json) {
    return EarnProduct(
      exchange: (json['exchange'] as String?) ?? '',
      coin: (json['coin'] as String?) ?? 'USDT',
      productType: (json['productType'] as String?) ?? 'flexible',
      available: json['available'] == true,
      aprPercent: (json['aprPercent'] as num?)?.toDouble(),
      aprDisplay: json['aprDisplay']?.toString(),
      marketAprDisplay: json['marketAprDisplay']?.toString(),
      avgAprDisplay: json['avgAprDisplay']?.toString(),
      prevAprDisplay: json['prevAprDisplay']?.toString(),
      minAmount: json['minAmount']?.toString(),
      maxAmount: json['maxAmount']?.toString(),
      maxAmountPerUser: json['maxAmountPerUser']?.toString(),
      status: json['status']?.toString(),
      productId: json['productId']?.toString(),
      hasTieredApr: json['hasTieredApr'] == true,
      tiers: (json['tiers'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(EarnTier.fromJson)
          .toList(),
      note: json['note']?.toString(),
    );
  }
}
