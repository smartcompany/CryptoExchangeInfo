import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/earn_product.dart';

class FlexibleUsdtEarnResult {
  const FlexibleUsdtEarnResult({required this.items, required this.fetchedAt});

  final List<EarnProduct> items;
  final DateTime? fetchedAt;
}

class EarnService {
  EarnService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _browserHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.9,ko;q=0.8',
  };

  /// Client-side live Flexible USDT rates for every tab exchange.
  Future<FlexibleUsdtEarnResult> fetchFlexibleUsdt() async {
    final results = await Future.wait([
      _fetchBinance(),
      _fetchBybit(),
      _fetchOkx(),
      _fetchGate(),
      Future.value(
        _unavailable(exchange: 'mexc', note: 'unavailable_public_api'),
      ),
      Future.value(
        _unavailable(exchange: 'bitget', note: 'unavailable_auth_required'),
      ),
      Future.value(
        _unavailable(exchange: 'kucoin', note: 'unavailable_auth_required'),
      ),
      Future.value(
        _unavailable(exchange: 'coinbase', note: 'unavailable_no_flexible_usdt'),
      ),
      Future.value(_unavailable(exchange: 'upbit', note: 'unavailable_upbit')),
      Future.value(
        _unavailable(exchange: 'bithumb', note: 'unavailable_bithumb'),
      ),
    ]);

    results.sort((a, b) {
      final ap = a.available ? (a.aprPercent ?? -1) : -2;
      final bp = b.available ? (b.aprPercent ?? -1) : -2;
      return bp.compareTo(ap);
    });

    return FlexibleUsdtEarnResult(
      items: results,
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  EarnProduct _unavailable({required String exchange, required String note}) {
    return EarnProduct.fromJson({
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
    });
  }

  Future<EarnProduct> _fetchBybit() async {
    try {
      final uri = Uri.parse('https://api.bybit.com/v5/earn/product').replace(
        queryParameters: {'category': 'FlexibleSaving', 'coin': 'USDT'},
      );
      final res = await _client.get(uri).timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        return _unavailable(
          exchange: 'bybit',
          note: 'Bybit HTTP ${res.statusCode}',
        );
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['retCode'] != 0) {
        return _unavailable(
          exchange: 'bybit',
          note: body['retMsg']?.toString() ?? 'Bybit error',
        );
      }
      final list = ((body['result'] as Map?)?['list'] as List?) ?? [];
      if (list.isEmpty) {
        return _unavailable(
          exchange: 'bybit',
          note: 'No USDT Flexible product',
        );
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
      return EarnProduct.fromJson({
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
        'note': tiers.isNotEmpty ? 'tier_note' : null,
      });
    } catch (e) {
      return _unavailable(exchange: 'bybit', note: e.toString());
    }
  }

  Future<EarnProduct> _fetchBinance() async {
    try {
      final uri =
          Uri.parse(
            'https://www.binance.com/bapi/earn/v1/friendly/lending/daily/product/list',
          ).replace(
            queryParameters: {
              'pageSize': '5',
              'pageIndex': '1',
              'asset': 'USDT',
            },
          );
      final res = await _client
          .get(
            uri,
            headers: {
              ..._browserHeaders,
              'Origin': 'https://www.binance.com',
              'Referer': 'https://www.binance.com/en/earn',
              'clienttype': 'web',
              'lang': 'en',
            },
          )
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        return _unavailable(
          exchange: 'binance',
          note: 'Binance HTTP ${res.statusCode}',
        );
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['code']?.toString() != '000000') {
        return _unavailable(
          exchange: 'binance',
          note: body['message']?.toString() ?? 'Binance error',
        );
      }
      final list = (body['data'] as List? ?? []).cast<Map<String, dynamic>>();
      if (list.isEmpty) {
        return _unavailable(
          exchange: 'binance',
          note: 'No USDT Flexible product',
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
      return EarnProduct.fromJson({
        'exchange': 'binance',
        'coin': 'USDT',
        'productType': 'flexible',
        'available': true,
        'aprPercent': aprPercent,
        'aprDisplay': aprPercent == null ? null : '${_fmtPct(aprPercent)}%',
        'marketAprDisplay': market == null ? null : '${_fmtPct(market * 100)}%',
        'minAmount': raw['minPurchaseAmount']?.toString(),
        'maxAmountPerUser': raw['upLimitPerUser']?.toString(),
        'status': raw['status']?.toString(),
        'productId': raw['id']?.toString(),
        'hasTieredApr': raw['hasTierInterest'] == true,
        'tiers': tiers,
        'note': 'Easy Earn Flexible. Published APR may differ from tier rates.',
      });
    } catch (e) {
      return _unavailable(exchange: 'binance', note: e.toString());
    }
  }

  Future<EarnProduct> _fetchOkx() async {
    try {
      final uri = Uri.parse(
        'https://www.okx.com/api/v5/finance/savings/lending-rate-summary',
      ).replace(queryParameters: {'ccy': 'USDT'});
      final res = await _client
          .get(uri, headers: _browserHeaders)
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        return _unavailable(
          exchange: 'okx',
          note: 'OKX HTTP ${res.statusCode}',
        );
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['code']?.toString() != '0') {
        return _unavailable(
          exchange: 'okx',
          note: body['msg']?.toString() ?? 'OKX error',
        );
      }
      final list = (body['data'] as List? ?? []).cast<Map<String, dynamic>>();
      if (list.isEmpty) {
        return _unavailable(exchange: 'okx', note: 'No USDT Flexible rate');
      }
      final raw = list.first;
      final est = _asDouble(raw['estRate']);
      final avg = _asDouble(raw['avgRate']);
      final pre = _asDouble(raw['preRate']);
      final aprPercent = est == null ? null : est * 100;
      return EarnProduct.fromJson({
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
        'note':
            'OKX Simple Earn / Savings estimated and average rates (annualized, decimal to %).',
      });
    } catch (e) {
      return _unavailable(exchange: 'okx', note: e.toString());
    }
  }

  /// Gate Uni public hourly rate → approximate APR%.
  Future<EarnProduct> _fetchGate() async {
    try {
      final uri = Uri.parse(
        'https://api.gateio.ws/api/v4/earn/uni/currencies/USDT',
      );
      final res = await _client
          .get(uri, headers: _browserHeaders)
          .timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        return _unavailable(
          exchange: 'gate',
          note: 'Gate HTTP ${res.statusCode}',
        );
      }
      final body = jsonDecode(res.body);
      final raw = body is Map<String, dynamic>
          ? body
          : (body is List && body.isNotEmpty
                ? body.first as Map<String, dynamic>
                : <String, dynamic>{});
      if (raw.isEmpty) {
        return _unavailable(exchange: 'gate', note: 'No USDT Uni product');
      }
      final maxHourly = _asDouble(raw['max_rate']);
      final minHourly = _asDouble(raw['min_rate']);
      // Gate Uni lend rate is hourly; APR% ≈ hourly * 24 * 365 * 100.
      final aprPercent =
          maxHourly == null ? null : maxHourly * 24 * 365 * 100;
      final minApr =
          minHourly == null ? null : minHourly * 24 * 365 * 100;
      return EarnProduct.fromJson({
        'exchange': 'gate',
        'coin': 'USDT',
        'productType': 'flexible',
        'available': aprPercent != null,
        'aprPercent': aprPercent,
        'aprDisplay': aprPercent == null ? null : '${_fmtPct(aprPercent)}%',
        'avgAprDisplay': minApr == null ? null : '${_fmtPct(minApr)}%',
        'minAmount': raw['min_lend_amount']?.toString(),
        'maxAmount': raw['max_lend_amount']?.toString(),
        'status': 'Available',
        'productId': 'uni-usdt',
        'hasTieredApr': false,
        'tiers': <Map<String, dynamic>>[],
        'note':
            'Gate Simple Earn / Uni approximate APR from public hourly max rate.',
      });
    } catch (e) {
      return _unavailable(exchange: 'gate', note: e.toString());
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
    if (value >= 1) return value.toStringAsFixed(2);
    return value.toStringAsFixed(4);
  }
}
