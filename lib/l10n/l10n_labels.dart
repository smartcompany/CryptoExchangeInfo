import '../models/opportunity.dart';
import '../services/exchange_events_service.dart';
import 'app_localizations.dart';

extension L10nLabels on AppLocalizations {
  String exchangeName(Exchange exchange) => switch (exchange) {
        Exchange.binance => exchangeBinance,
        Exchange.okx => exchangeOkx,
        Exchange.bybit => exchangeBybit,
        Exchange.gate => exchangeGate,
        Exchange.mexc => exchangeMexc,
        Exchange.bitget => exchangeBitget,
        Exchange.kucoin => exchangeKucoin,
        Exchange.coinbase => exchangeCoinbase,
        Exchange.htx => exchangeHtx,
        Exchange.upbit => exchangeUpbit,
        Exchange.bithumb => exchangeBithumb,
      };

  String exchangeNameFor(String exchange) {
    for (final value in Exchange.values) {
      if (value.name == exchange) return exchangeName(value);
    }
    return exchange;
  }

  String opportunityTypeLabel(OpportunityType type) => switch (type) {
    OpportunityType.event => typeEvent,
    OpportunityType.tradingContest => typeTradingContest,
    OpportunityType.earnBoost => typeEarnBoost,
    OpportunityType.depositBonus => typeDepositBonus,
    OpportunityType.convertChallenge => typeConvertChallenge,
    OpportunityType.dualChallenge => typeDualChallenge,
    OpportunityType.feePromo => typeFeePromo,
    OpportunityType.listing => typeListing,
    OpportunityType.other => typeOther,
  };

  String opportunityStatusLabel(OpportunityStatus status) => switch (status) {
    OpportunityStatus.upcoming => statusUpcoming,
    OpportunityStatus.live => statusLive,
    OpportunityStatus.endingSoon => statusEndingSoon,
    OpportunityStatus.ended => statusEnded,
  };

  String dDayLabel(int? days) {
    if (days == null) return '';
    if (days < 0) return closed;
    if (days == 0) return 'D-Day';
    return 'D-$days';
  }

  String eventTag(String tag) {
    switch (tag.trim().toLowerCase()) {
      case 'notice':
      case '공지':
      case '公告':
      case 'お知らせ':
        return categoryNotice;
      case 'event':
      case '이벤트':
      case '活动':
      case 'イベント':
        return typeEvent;
      default:
        return tag;
    }
  }
}
