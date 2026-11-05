/// FCM topic names — must match server/poller classification + send.
class PushTopics {
  const PushTopics._();

  static const catContest = 'exora_cat_contest';
  static const catEarn = 'exora_cat_earn';
  static const catListing = 'exora_cat_listing';
  static const catDeposit = 'exora_cat_deposit';
  static const catOther = 'exora_cat_other';

  static const exBinance = 'exora_ex_binance';
  static const exBybit = 'exora_ex_bybit';
  static const exOkx = 'exora_ex_okx';

  static const allCategory = [
    catContest,
    catEarn,
    catListing,
    catDeposit,
    catOther,
  ];

  static const allExchange = [exBinance, exBybit, exOkx];
}

enum PushCategory { contest, earn, listing, deposit, other }

enum PushExchange { binance, bybit, okx }

extension PushCategoryX on PushCategory {
  String get topic => switch (this) {
    PushCategory.contest => PushTopics.catContest,
    PushCategory.earn => PushTopics.catEarn,
    PushCategory.listing => PushTopics.catListing,
    PushCategory.deposit => PushTopics.catDeposit,
    PushCategory.other => PushTopics.catOther,
  };
}

extension PushExchangeX on PushExchange {
  String get topic => switch (this) {
    PushExchange.binance => PushTopics.exBinance,
    PushExchange.bybit => PushTopics.exBybit,
    PushExchange.okx => PushTopics.exOkx,
  };

  String get id => name;
}
