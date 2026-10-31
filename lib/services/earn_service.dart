import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/earn_product.dart';
import 'exchange_events_service.dart';

class FlexibleUsdtEarnResult {
  const FlexibleUsdtEarnResult({
    required this.items,
    required this.fetchedAt,
  });

  final List<EarnProduct> items;
  final DateTime? fetchedAt;
}

class EarnService {
  EarnService({String? apiBaseUrl, http.Client? client})
      : apiBaseUrl = apiBaseUrl ?? ExchangeEventsService.defaultApiBaseUrl,
        _client = client ?? http.Client();

  final String apiBaseUrl;
  final http.Client _client;

  Future<FlexibleUsdtEarnResult> fetchFlexibleUsdt() async {
    final uri = Uri.parse('$apiBaseUrl/api/earn/flexible-usdt');
    final response =
        await _client.get(uri).timeout(const Duration(seconds: 45));
    if (response.statusCode != 200) {
      throw Exception('Earn 조회 실패 (${response.statusCode}): ${response.body}');
    }

    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (body['error'] != null) {
      throw Exception(body['error'].toString());
    }

    final items = (body['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(EarnProduct.fromJson)
        .toList()
      ..sort((a, b) {
        final ap = a.aprPercent ?? -1;
        final bp = b.aprPercent ?? -1;
        return bp.compareTo(ap);
      });

    return FlexibleUsdtEarnResult(
      items: items,
      fetchedAt: DateTime.tryParse(body['fetchedAt']?.toString() ?? ''),
    );
  }
}
