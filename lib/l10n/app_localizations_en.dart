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
  String get sectionEarning => 'Stable Coin Earn';

  @override
  String get sectionEarningShort => 'Stable Coin Earn';

  @override
  String get menuSelect => 'Choose a menu';

  @override
  String get searchEventsHint => 'Search events';

  @override
  String get searchTooltip => 'Search';

  @override
  String get searchCloseTooltip => 'Close search';

  @override
  String get shareTooltip => 'Share';

  @override
  String shareMessage(String url) {
    return 'Check out Exora — crypto exchange hub\n$url';
  }

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get notificationsComingSoon => 'Notifications are coming soon.';

  @override
  String get pushSettingsTitle => 'Push alerts';

  @override
  String get pushSettingsIntro =>
      'Get notified about useful exchange opportunities without opening the app. Turn on only what you care about.';

  @override
  String get pushMasterTitle => 'Turn all push alerts on/off';

  @override
  String get pushMasterSubtitle => 'Master switch for push notifications';

  @override
  String get pushPermissionDenied => 'Notification permission was denied.';

  @override
  String get pushCategoriesSection => 'What to receive';

  @override
  String get pushExchangesSection => 'Which exchanges';

  @override
  String get pushExchangesHint =>
      'Alerts only fire when both a category and an exchange are enabled.';

  @override
  String get pushOtherExchangesNote =>
      'Other exchanges (Gate, MEXC, …) are not covered by server polling yet.';

  @override
  String get pushCatContest => 'Trading contests';

  @override
  String get pushCatContestDesc => 'Volume / PnL contests and reward campaigns';

  @override
  String get pushCatEarn => 'Earn · APR boosts';

  @override
  String get pushCatEarnDesc =>
      'Flexible / Fixed earn promos and Launchpool-style offers';

  @override
  String get pushCatListing => 'New listings · Launchpad';

  @override
  String get pushCatListingDesc => 'Listing and launch announcements';

  @override
  String get pushCatDeposit => 'Deposit · signup bonuses';

  @override
  String get pushCatDepositDesc =>
      'Welcome and deposit bonus campaigns (can be noisy)';

  @override
  String get pushCatOther => 'Other campaigns';

  @override
  String get pushCatOtherDesc =>
      'Fee discounts, convert challenges, and the rest';

  @override
  String get pushDigestTitle => 'New opportunities';

  @override
  String pushDigestBody(String exchanges, String categories) {
    return 'New $categories on $exchanges.';
  }

  @override
  String pushDigestListTwo(String a, String b) {
    return '$a, $b';
  }

  @override
  String pushDigestListTwoMore(String a, String b) {
    return '$a, $b, and more';
  }

  @override
  String get pushDigestCatContest => 'contests';

  @override
  String get pushDigestCatEarn => 'Earn';

  @override
  String get pushDigestCatListing => 'listings';

  @override
  String get pushDigestCatDeposit => 'deposit bonuses';

  @override
  String get pushDigestCatOther => 'campaigns';

  @override
  String get pushDigestExBinance => 'Binance';

  @override
  String get pushDigestExBybit => 'Bybit';

  @override
  String get pushDigestExOkx => 'OKX';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get loadingEvents => 'Loading events…';

  @override
  String get loadingEarn => 'Loading Stable Coin Earn…';

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
  String get aiSummary => 'AI details';

  @override
  String get aiAnalyzing => 'Analyzing';

  @override
  String get aiEasyExplainTitle => 'AI detailed explanation';

  @override
  String get aiDisclaimer =>
      'Draft only — not investment advice. Prefer the original terms and rewards.';

  @override
  String get aiGoToSource => 'Participate';

  @override
  String get aiClose => 'Close';

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
  String get bannerSignUp => 'Sign up';

  @override
  String get appIconExperimentTooltip => 'App icon experiment';

  @override
  String get appIconExperimentTitle => 'App icon experiment';

  @override
  String get appIconExperimentBody =>
      'Try Hub or Portal as the home-screen icon. You can switch anytime.';

  @override
  String get appIconHub => 'Hub';

  @override
  String get appIconPortal => 'Portal';

  @override
  String get appIconSelected => 'Selected';

  @override
  String get appIconChanged => 'App icon updated.';

  @override
  String get appIconChangedAndroid =>
      'App icon will update after you leave the app.';

  @override
  String get appIconUnsupported =>
      'Icon switching isn’t supported on this device.';

  @override
  String appIconChangeFailed(String error) {
    return 'Couldn’t change icon: $error';
  }

  @override
  String get adConfirmTitle => 'AI details';

  @override
  String get adConfirmMessage =>
      'Watch an ad to unlock the AI detailed explanation. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get adConfirmContinue => 'Watch ad & continue';

  @override
  String get earnHeroTitle => 'Stable Coin Earn';

  @override
  String get earnHeroBody =>
      'Flexible stablecoin rates by exchange. Pick a coin below. Effective APR can vary by tier and timing.';

  @override
  String get earnFlexibleBadge => 'Flexible';

  @override
  String earnMinAmount(String amount, String coin) {
    return 'Min $amount $coin';
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
  String get earnUnavailableUpbit => 'Upbit has no public Flexible Earn API.';

  @override
  String get earnUnavailableBithumb =>
      'Bithumb has no public Flexible Earn API.';

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
}
