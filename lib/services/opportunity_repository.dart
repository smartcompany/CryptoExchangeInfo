import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/opportunity.dart';
import 'contest_matcher.dart';
import 'exchange_event_fetchers.dart';
import 'exchange_events_service.dart';
import 'translate_service.dart';

class OpportunityRepository {
  OpportunityRepository({
    this.assetPath = 'assets/opportunities_pilot.json',
    ExchangeEventsService? events,
    TranslateService? translate,
  }) : // ignore: prefer_initializing_formals
       _events = events,
       _translate = translate ?? TranslateService();

  final String assetPath;
  final ExchangeEventsService? _events;
  final TranslateService _translate;

  List<Opportunity>? _rawCache;
  final Map<String, List<Opportunity>> _exchangeLocaleCache = {};
  List<Opportunity>? _liveContestCache;
  DateTime? _liveContestFetchedAt;
  DateTime? asOf;

  static const _liveContestTtl = Duration(minutes: 20);

  String get _activeLocale => TranslateService.normalizeLang(
        PlatformDispatcher.instance.locale.languageCode,
      );

  /// Loads + localizes opportunities for [exchange] only (not every exchange).
  Future<List<Opportunity>> forExchange(
    Exchange exchange, {
    OpportunityType? type,
  }) async {
    final locale = _activeLocale;
    final cacheKey = '${exchange.name}|$locale';
    var localized = _exchangeLocaleCache[cacheKey];
    if (localized != null && !_looksLocalized(localized, locale)) {
      _exchangeLocaleCache.remove(cacheKey);
      localized = null;
    }

    if (localized == null) {
      final raw = await _loadRaw();
      // Pilot JSON keeps non-contest curated cards; contests come from live feeds.
      final pilot = raw
          .where(
            (o) =>
                o.exchange == exchange.name &&
                o.type != OpportunityType.tradingContest,
          )
          .toList(growable: false);
      final live = await _liveContests(
        exchanges: [exchange],
      );

      final merged = [...pilot, ...live];
      if (locale == 'ko') {
        localized = List<Opportunity>.from(merged);
      } else {
        localized = <Opportunity>[];
        for (final item in merged) {
          localized.add(await localize(item, locale: locale));
        }
      }
      _exchangeLocaleCache[cacheKey] = localized;
    }

    final filtered = localized.where((o) {
      if (type == null) return true;
      return o.type == type;
    }).toList();
    filtered.sort(_byEndingSoon);
    return filtered;
  }

  /// Loads + localizes opportunities of [type] across every exchange.
  Future<List<Opportunity>> forType(
    OpportunityType type, {
    bool forceRefresh = false,
  }) async {
    if (type == OpportunityType.tradingContest) {
      final live = await _liveContests(
        forceRefresh: forceRefresh,
      );
      final locale = _activeLocale;
      if (locale == 'ko') {
        final sorted = List<Opportunity>.from(live)..sort(_byEndingSoon);
        return sorted;
      }
      final localized = <Opportunity>[];
      for (final item in live) {
        localized.add(await localize(item, locale: locale));
      }
      localized.sort(_byEndingSoon);
      return localized;
    }

    final locale = _activeLocale;
    final cacheKey = 'type:${type.wire}|$locale';
    if (forceRefresh) {
      _exchangeLocaleCache.remove(cacheKey);
    }
    var localized = _exchangeLocaleCache[cacheKey];
    if (localized != null && !_looksLocalized(localized, locale)) {
      _exchangeLocaleCache.remove(cacheKey);
      localized = null;
    }

    if (localized == null) {
      final raw = await _loadRaw();
      final matched =
          raw.where((o) => o.type == type).toList(growable: false);
      if (locale == 'ko') {
        localized = List<Opportunity>.from(matched);
      } else {
        localized = <Opportunity>[];
        for (final item in matched) {
          localized.add(await localize(item, locale: locale));
        }
      }
      _exchangeLocaleCache[cacheKey] = localized;
    }

    final sorted = List<Opportunity>.from(localized)..sort(_byEndingSoon);
    return sorted;
  }

  /// Localizes one opportunity into [locale] (defaults to app language).
  Future<Opportunity> localize(
    Opportunity item, {
    String? locale,
  }) async {
    final target = TranslateService.normalizeLang(
      locale ?? _activeLocale,
    );
    if (target == 'ko') return item;

    final title = target == 'en' && (item.titleEn?.trim().isNotEmpty ?? false)
        ? item.titleEn!.trim()
        : await _translate.translate(item.titleKo, targetLanguage: target);

    final summary = await _translate.translate(
      item.summaryKo,
      targetLanguage: target,
    );
    final eligibility = await _translate.translate(
      item.eligibilityKo,
      targetLanguage: target,
    );
    final reward = await _translate.translate(
      item.rewardLabel,
      targetLanguage: target,
    );
    final region =
        item.regionNoteKo == null || item.regionNoteKo!.trim().isEmpty
        ? item.regionNoteKo
        : await _translate.translate(
            item.regionNoteKo!,
            targetLanguage: target,
          );

    final tasks = <String>[];
    for (final task in item.tasksKo) {
      tasks.add(await _translate.translate(task, targetLanguage: target));
    }

    return item.copyWith(
      titleKo: title,
      summaryKo: summary,
      eligibilityKo: eligibility,
      rewardLabel: reward,
      regionNoteKo: region,
      tasksKo: tasks,
    );
  }

  Future<List<Opportunity>> _liveContests({
    List<Exchange>? exchanges,
    bool forceRefresh = false,
  }) async {
    final scope = exchanges ?? Exchange.values;
    final useGlobalCache = exchanges == null ||
        (exchanges.length == Exchange.values.length);

    if (useGlobalCache &&
        !forceRefresh &&
        _liveContestCache != null &&
        _liveContestFetchedAt != null &&
        DateTime.now().difference(_liveContestFetchedAt!) <= _liveContestTtl) {
      return List<Opportunity>.from(_liveContestCache!);
    }

    final eventsService = _events ?? ExchangeEventsService();
    final pages = await Future.wait(
      scope.map((exchange) async {
        try {
          return await eventsService.loadEvents(
            exchange,
            limit: ExchangeEventFetchers.defaultPageSize,
            forceRefresh: forceRefresh,
          );
        } catch (error) {
          debugPrint(
            '[OpportunityRepository] contest fetch ${exchange.name}: $error',
          );
          return null;
        }
      }),
    );

    final seen = <String>{};
    final contests = <Opportunity>[];
    for (final page in pages) {
      if (page == null) continue;
      for (final event in page.items) {
        if (!ContestMatcher.looksLikeContest(event)) continue;
        final opp = ContestMatcher.toOpportunity(event);
        if (opp.status == OpportunityStatus.ended) continue;
        if (!seen.add(opp.officialUrl.isNotEmpty ? opp.officialUrl : opp.id)) {
          continue;
        }
        contests.add(opp);
      }
    }
    contests.sort(_byEndingSoon);
    asOf = DateTime.now().toUtc();

    if (useGlobalCache) {
      _liveContestCache = contests;
      _liveContestFetchedAt = DateTime.now();
    }
    return contests;
  }

  Future<List<Opportunity>> _loadRaw() async {
    if (_rawCache != null) return _rawCache!;
    final raw = await rootBundle.loadString(assetPath);
    final body = jsonDecode(raw) as Map<String, dynamic>;
    asOf = DateTime.tryParse(body['asOf']?.toString() ?? '') ?? asOf;
    final items = (body['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Opportunity.fromJson)
        .where((o) => o.id.isNotEmpty && o.status != OpportunityStatus.ended)
        .toList();
    _rawCache = items;
    return items;
  }

  bool _looksLocalized(List<Opportunity> items, String locale) {
    if (locale == 'ko' || items.isEmpty) return true;
    var sample = 0;
    var wrong = 0;
    for (final item in items.take(8)) {
      for (final text in [
        item.summaryKo,
        item.eligibilityKo,
        ...item.tasksKo.take(1),
      ]) {
        final value = text.trim();
        if (value.isEmpty) continue;
        sample++;
        if (TranslateService.detectLanguage(value) != locale) wrong++;
      }
    }
    if (sample == 0) return true;
    final ok = wrong * 2 < sample;
    if (!ok) {
      debugPrint(
        '[OpportunityRepository] dropping bad $locale cache '
        '(wrong=$wrong/$sample)',
      );
    }
    return ok;
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
