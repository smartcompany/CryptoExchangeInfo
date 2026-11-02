// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Exora';

  @override
  String get sectionEvents => 'Exchange events';

  @override
  String get sectionEarning => 'Earning (Flexible USDT)';

  @override
  String get sectionEarningShort => 'Flexible USDT';

  @override
  String get menuSelect => 'Choose a menu';

  @override
  String get searchEventsHint => 'Search events';

  @override
  String get searchTooltip => 'Search';

  @override
  String get searchCloseTooltip => 'Close search';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get notificationsComingSoon => 'Notifications are coming soon.';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get loadingEvents => 'Loading events…';

  @override
  String get loadingEarn => 'Loading Flexible USDT Earn…';

  @override
  String get noMatchingItems => 'No items match your filters.';

  @override
  String get noEvents => 'No events to show.';

  @override
  String get noEarnProducts => 'No Earn products to show.';

  @override
  String get eventsLoadFailed => 'Couldn\'t load events.';

  @override
  String get earnLoadFailed => 'Couldn\'t load Earn info.';

  @override
  String get networkRetryHint => 'Check your connection and try again.';

  @override
  String get retry => 'Try again';

  @override
  String get filterAll => 'All';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortEndingSoon => 'Ending soon';

  @override
  String get exchangeBybit => 'Bybit';

  @override
  String get exchangeBinance => 'Binance';

  @override
  String get exchangeOkx => 'OKX';

  @override
  String get exchangeUpbit => 'Upbit';

  @override
  String get exchangeBithumb => 'Bithumb';

  @override
  String get exchangeBitget => 'Bitget';

  @override
  String get typeEvent => 'Event';

  @override
  String get typeTradingContest => 'Trading contest';

  @override
  String get contestsHubTitle => 'Trading contests';

  @override
  String get contestsHubBody =>
      'Compare live contests across exchanges in one feed.';

  @override
  String get noContests => 'No trading contests to show.';

  @override
  String get typeEarnBoost => 'Earn boost';

  @override
  String get typeDepositBonus => 'Deposit bonus';

  @override
  String get typeConvertChallenge => 'Convert';

  @override
  String get typeDualChallenge => 'Dual';

  @override
  String get typeFeePromo => 'Fees';

  @override
  String get typeListing => 'Listing';

  @override
  String get typeOther => 'Other';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusLive => 'Live';

  @override
  String get statusEndingSoon => 'Ending soon';

  @override
  String get statusEnded => 'Ended';

  @override
  String get endingSoonBadge => 'Ending soon';

  @override
  String rewardLabel(String value) {
    return 'Reward $value';
  }

  @override
  String deadlineLabel(String value) {
    return 'Ends $value';
  }

  @override
  String periodRange(String start, String end, String suffix) {
    return 'Period $start ~ $end$suffix';
  }

  @override
  String publishedAt(String date) {
    return 'Posted $date';
  }

  @override
  String get closed => 'Closed';

  @override
  String get detailReward => 'Reward';

  @override
  String get detailType => 'Type';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailStart => 'Starts';

  @override
  String get detailEnd => 'Ends';

  @override
  String get detailEligibility => 'Eligibility';

  @override
  String get detailRegion => 'Region';

  @override
  String get detailTasks => 'How to join';

  @override
  String detailAsOf(String date) {
    return 'As of $date · Not investment advice · Prefer the original terms';
  }

  @override
  String get invalidLink => 'No valid link.';

  @override
  String get cannotOpenLink => 'Couldn\'t open the link.';

  @override
  String get cannotOpenEarnPage => 'Couldn\'t open the Earn page.';

  @override
  String get aiSummary => 'AI summary';

  @override
  String get aiAnalyzing => 'Analyzing';

  @override
  String get aiEasyExplainTitle => 'AI simple guide';

  @override
  String get aiDisclaimer =>
      'Draft only — not investment advice. Prefer the original terms and rewards.';

  @override
  String get aiGoToSource => 'Open original';

  @override
  String get aiSectionReward => 'Reward';

  @override
  String get aiSectionPeriod => 'Period';

  @override
  String get aiSectionConditions => 'Requirements';

  @override
  String get aiSectionCautions => 'Notes';

  @override
  String aiFailed(String error) {
    return 'AI analysis failed: $error';
  }

  @override
  String get viewOriginal => 'View original';

  @override
  String get adConfirmTitle => 'AI summary';

  @override
  String get adConfirmMessage =>
      'Watch an ad to unlock the AI summary. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get adConfirmContinue => 'Watch ad & continue';

  @override
  String get earnHeroTitle => 'Flexible USDT';

  @override
  String get earnHeroBody =>
      'Flexible USDT rates by exchange. Effective APR can vary by tier and timing.';

  @override
  String earnMinAmount(String amount) {
    return 'Min $amount USDT';
  }

  @override
  String earnMarketApr(String value) {
    return 'Market APR $value';
  }

  @override
  String get earnOpenPage => 'Open Earn page';

  @override
  String get earnUnavailableBitget => 'Bitget Savings requires an API key.';

  @override
  String get earnUnavailableUpbit =>
      'Upbit has no public Flexible USDT Earn API.';

  @override
  String get earnUnavailableBithumb =>
      'Bithumb has no public Flexible USDT Earn API.';

  @override
  String get earnTierNote => 'Applied APR may vary by balance tier.';

  @override
  String get bannerBybitTitle => 'Trading campaigns';

  @override
  String get bannerBybitBody => 'Catch the latest Bybit rewards and contests';

  @override
  String get bannerBinanceTitle => 'Global event hub';

  @override
  String get bannerBinanceBody => 'Browse Binance campaigns in one place';

  @override
  String get bannerOkxTitle => 'Simple opportunity board';

  @override
  String get bannerOkxBody => 'Campaigns and rewards, without the noise';

  @override
  String get bannerUpbitTitle => 'Local notices & events';

  @override
  String get bannerUpbitBody => 'Spot listing and event news quickly';

  @override
  String get bannerBithumbTitle => 'Hot promotions';

  @override
  String get bannerBithumbBody => 'A warm roundup of events and notices';

  @override
  String get bannerBitgetTitle => 'Copy & event zone';

  @override
  String get bannerBitgetBody => 'Rewards and campaigns, neon-clear';

  @override
  String activeCount(int count) {
    return '$count live';
  }

  @override
  String get earnUnsupported => 'Unavailable';

  @override
  String get earnAprLabel => 'Listed APR (Flexible)';

  @override
  String earnAvgApr(String value) {
    return 'Avg $value';
  }

  @override
  String earnPrevApr(String value) {
    return ' · Prev $value';
  }

  @override
  String get earnTierRates => 'Tier rates';

  @override
  String get categoryNotice => 'Notice';

  @override
  String get exchangeGate => 'Gate';

  @override
  String get exchangeMexc => 'MEXC';

  @override
  String get exchangeKucoin => 'KuCoin';

  @override
  String get exchangeCoinbase => 'Coinbase';

  @override
  String get exchangeHtx => 'HTX';

  @override
  String get bannerGateTitle => 'Listings & campaigns';

  @override
  String get bannerGateBody =>
      'Gate promotions and trading contests in one feed';

  @override
  String get bannerMexcTitle => 'Event radar';

  @override
  String get bannerMexcBody => 'Catch MEXC listings and zero-fee campaigns';

  @override
  String get bannerKucoinTitle => 'KuCoin pulse';

  @override
  String get bannerKucoinBody => 'Listings, earn boosts, and platform news';

  @override
  String get bannerCoinbaseTitle => 'Exchange notices';

  @override
  String get bannerCoinbaseBody => 'Status updates and scheduled maintenance';

  @override
  String get bannerHtxTitle => 'HTX activities';

  @override
  String get bannerHtxBody => 'Latest campaigns and platform rewards';
}
