import 'dart:ui' show Locale, PlatformDispatcher;

import '../l10n/app_localizations.dart';
import 'push_preferences.dart';
import 'push_topics.dart';

/// Builds localized digest title/body from FCM data + local prefs.
class PushDigestCopy {
  const PushDigestCopy._();

  static const typeDigest = 'opportunity_digest';

  /// Returns null when nothing matches local prefs (skip notification).
  static ({String title, String body, String url})? fromMessageData(
    Map<String, dynamic> data, {
    required PushPreferences prefs,
    AppLocalizations? l10n,
  }) {
    if (!prefs.masterEnabled) return null;
    if (data['type']?.toString() != typeDigest) return null;

    final loc =
        l10n ??
        lookupAppLocalizations(
          Locale(PlatformDispatcher.instance.locale.languageCode),
        );

    final pairs = _parsePairs(data);
    final filtered = <({PushExchange exchange, PushCategory category})>[];
    for (final p in pairs) {
      if (!prefs.exchanges.contains(p.exchange)) continue;
      if (!prefs.categories.contains(p.category)) continue;
      filtered.add(p);
    }
    if (filtered.isEmpty) return null;

    final exchanges = <PushExchange>[];
    final categories = <PushCategory>[];
    for (final p in filtered) {
      if (!exchanges.contains(p.exchange)) exchanges.add(p.exchange);
      if (!categories.contains(p.category)) categories.add(p.category);
    }

    final exPhrase = _joinLabels(
      loc,
      exchanges.map((e) => _exchangeLabel(loc, e)).toList(),
    );
    final catPhrase = _joinLabels(
      loc,
      categories.map((c) => _categoryLabel(loc, c)).toList(),
    );

    return (
      title: loc.pushDigestTitle,
      body: loc.pushDigestBody(exPhrase, catPhrase),
      url: data['url']?.toString().trim() ?? '',
    );
  }

  static List<({PushExchange exchange, PushCategory category})> _parsePairs(
    Map<String, dynamic> data,
  ) {
    final raw = data['pairs']?.toString().trim() ?? '';
    if (raw.isNotEmpty) {
      final out = <({PushExchange exchange, PushCategory category})>[];
      for (final part in raw.split(',')) {
        final bits = part.trim().split(':');
        if (bits.length != 2) continue;
        final ex = _parseExchange(bits[0]);
        final cat = _parseCategory(bits[1]);
        if (ex == null || cat == null) continue;
        out.add((exchange: ex, category: cat));
      }
      if (out.isNotEmpty) return out;
    }

    // Fallback: cartesian of exchanges × categories from payload.
    final exchanges = (data['exchanges']?.toString() ?? '')
        .split(',')
        .map(_parseExchange)
        .whereType<PushExchange>()
        .toList();
    final categories = (data['categories']?.toString() ?? '')
        .split(',')
        .map(_parseCategory)
        .whereType<PushCategory>()
        .toList();
    final out = <({PushExchange exchange, PushCategory category})>[];
    for (final ex in exchanges) {
      for (final cat in categories) {
        out.add((exchange: ex, category: cat));
      }
    }
    return out;
  }

  static String _joinLabels(AppLocalizations loc, List<String> labels) {
    if (labels.isEmpty) return '';
    if (labels.length == 1) return labels.first;
    if (labels.length == 2) {
      return loc.pushDigestListTwo(labels[0], labels[1]);
    }
    return loc.pushDigestListTwoMore(labels[0], labels[1]);
  }

  static String _exchangeLabel(AppLocalizations loc, PushExchange ex) {
    return switch (ex) {
      PushExchange.binance => loc.pushDigestExBinance,
      PushExchange.bybit => loc.pushDigestExBybit,
      PushExchange.okx => loc.pushDigestExOkx,
    };
  }

  static String _categoryLabel(AppLocalizations loc, PushCategory cat) {
    return switch (cat) {
      PushCategory.contest => loc.pushDigestCatContest,
      PushCategory.earn => loc.pushDigestCatEarn,
      PushCategory.listing => loc.pushDigestCatListing,
      PushCategory.deposit => loc.pushDigestCatDeposit,
      PushCategory.other => loc.pushDigestCatOther,
    };
  }

  static PushExchange? _parseExchange(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'binance':
        return PushExchange.binance;
      case 'bybit':
        return PushExchange.bybit;
      case 'okx':
        return PushExchange.okx;
      default:
        return null;
    }
  }

  static PushCategory? _parseCategory(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'contest':
        return PushCategory.contest;
      case 'earn':
        return PushCategory.earn;
      case 'listing':
        return PushCategory.listing;
      case 'deposit':
        return PushCategory.deposit;
      case 'other':
        return PushCategory.other;
      default:
        return null;
    }
  }
}
