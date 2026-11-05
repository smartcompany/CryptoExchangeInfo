import 'package:shared_preferences/shared_preferences.dart';

import 'push_topics.dart';

/// Local push prefs. Defaults: contest/earn/listing ON; deposit/other OFF.
/// Exchange filter UI is deferred — always subscribe Binance/Bybit/OKX.
class PushPreferences {
  PushPreferences({
    this.masterEnabled = false,
    Set<PushCategory>? categories,
  }) : categories =
           categories ??
           {PushCategory.contest, PushCategory.earn, PushCategory.listing},
       exchanges = Set<PushExchange>.from(PushExchange.values);

  bool masterEnabled;
  Set<PushCategory> categories;

  /// Always all polled exchanges until exchange picker ships.
  final Set<PushExchange> exchanges;

  static const _kMaster = 'exora_push_master';
  static const _kCats = 'exora_push_categories';

  static Future<PushPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final master = prefs.getBool(_kMaster) ?? false;
    final catRaw = prefs.getStringList(_kCats);

    final cats = <PushCategory>{};
    if (catRaw == null) {
      cats.addAll({
        PushCategory.contest,
        PushCategory.earn,
        PushCategory.listing,
      });
    } else {
      for (final id in catRaw) {
        final match = PushCategory.values.where((c) => c.name == id);
        if (match.isNotEmpty) cats.add(match.first);
      }
    }

    return PushPreferences(masterEnabled: master, categories: cats);
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kMaster, masterEnabled);
    await prefs.setStringList(
      _kCats,
      categories.map((c) => c.name).toList()..sort(),
    );
  }

  bool categoryEnabled(PushCategory c) => categories.contains(c);

  bool exchangeEnabled(PushExchange e) => exchanges.contains(e);

  /// Topics that should be subscribed when master is on.
  Set<String> desiredTopics() {
    if (!masterEnabled) return {};
    final topics = <String>{};
    for (final c in categories) {
      topics.add(c.topic);
    }
    for (final e in exchanges) {
      topics.add(e.topic);
    }
    return topics;
  }
}
