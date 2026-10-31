import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/opportunity.dart';
import 'exchange_events_service.dart';

class OpportunityRepository {
  OpportunityRepository({
    this.assetPath = 'assets/opportunities_pilot.json',
  });

  final String assetPath;

  List<Opportunity>? _cache;
  DateTime? asOf;

  Future<List<Opportunity>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(assetPath);
    final body = jsonDecode(raw) as Map<String, dynamic>;
    asOf = DateTime.tryParse(body['asOf']?.toString() ?? '');
    final items = (body['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Opportunity.fromJson)
        .where((o) => o.id.isNotEmpty && o.status != OpportunityStatus.ended)
        .toList();
    _cache = items;
    return items;
  }

  Future<List<Opportunity>> forExchange(
    Exchange exchange, {
    OpportunityType? type,
  }) async {
    final all = await loadAll();
    final filtered = all.where((o) => o.exchange == exchange.name).where((o) {
      if (type == null) return true;
      return o.type == type;
    }).toList();
    filtered.sort(_byEndingSoon);
    return filtered;
  }

  static int _byEndingSoon(Opportunity a, Opportunity b) {
    final ae = a.endsAt;
    final be = b.endsAt;
    if (ae == null && be == null) {
      final statusCmp = _statusRank(a.status).compareTo(_statusRank(b.status));
      if (statusCmp != 0) return statusCmp;
      return a.titleKo.compareTo(b.titleKo);
    }
    if (ae == null) return 1;
    if (be == null) return -1;
    final cmp = ae.compareTo(be);
    if (cmp != 0) return cmp;
    return a.titleKo.compareTo(b.titleKo);
  }

  static int _statusRank(OpportunityStatus status) {
    return switch (status) {
      OpportunityStatus.endingSoon => 0,
      OpportunityStatus.live => 1,
      OpportunityStatus.upcoming => 2,
      OpportunityStatus.ended => 3,
    };
  }
}
