import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Exora'**
  String get appTitle;

  /// No description provided for @sectionEvents.
  ///
  /// In en, this message translates to:
  /// **'Exchange events'**
  String get sectionEvents;

  /// No description provided for @sectionEarning.
  ///
  /// In en, this message translates to:
  /// **'Stable Coin Earn'**
  String get sectionEarning;

  /// No description provided for @sectionEarningShort.
  ///
  /// In en, this message translates to:
  /// **'Stable Coin Earn'**
  String get sectionEarningShort;

  /// No description provided for @menuSelect.
  ///
  /// In en, this message translates to:
  /// **'Choose a menu'**
  String get menuSelect;

  /// No description provided for @searchEventsHint.
  ///
  /// In en, this message translates to:
  /// **'Search events'**
  String get searchEventsHint;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// No description provided for @searchCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get searchCloseTooltip;

  /// No description provided for @shareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTooltip;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out Exora — crypto exchange hub\n{url}'**
  String shareMessage(String url);

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications are coming soon.'**
  String get notificationsComingSoon;

  /// No description provided for @pushSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Push alerts'**
  String get pushSettingsTitle;

  /// No description provided for @pushSettingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Get notified about useful exchange opportunities without opening the app. Turn on only what you care about.'**
  String get pushSettingsIntro;

  /// No description provided for @pushMasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn all push alerts on/off'**
  String get pushMasterTitle;

  /// No description provided for @pushMasterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Master switch for push notifications'**
  String get pushMasterSubtitle;

  /// No description provided for @pushPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was denied.'**
  String get pushPermissionDenied;

  /// No description provided for @pushCategoriesSection.
  ///
  /// In en, this message translates to:
  /// **'What to receive'**
  String get pushCategoriesSection;

  /// No description provided for @pushExchangesSection.
  ///
  /// In en, this message translates to:
  /// **'Which exchanges'**
  String get pushExchangesSection;

  /// No description provided for @pushExchangesHint.
  ///
  /// In en, this message translates to:
  /// **'Alerts only fire when both a category and an exchange are enabled.'**
  String get pushExchangesHint;

  /// No description provided for @pushOtherExchangesNote.
  ///
  /// In en, this message translates to:
  /// **'Other exchanges (Gate, MEXC, …) are not covered by server polling yet.'**
  String get pushOtherExchangesNote;

  /// No description provided for @pushCatContest.
  ///
  /// In en, this message translates to:
  /// **'Trading contests'**
  String get pushCatContest;

  /// No description provided for @pushCatContestDesc.
  ///
  /// In en, this message translates to:
  /// **'Volume / PnL contests and reward campaigns'**
  String get pushCatContestDesc;

  /// No description provided for @pushCatEarn.
  ///
  /// In en, this message translates to:
  /// **'Earn · APR boosts'**
  String get pushCatEarn;

  /// No description provided for @pushCatEarnDesc.
  ///
  /// In en, this message translates to:
  /// **'Flexible / Fixed earn promos and Launchpool-style offers'**
  String get pushCatEarnDesc;

  /// No description provided for @pushCatListing.
  ///
  /// In en, this message translates to:
  /// **'New listings · Launchpad'**
  String get pushCatListing;

  /// No description provided for @pushCatListingDesc.
  ///
  /// In en, this message translates to:
  /// **'Listing and launch announcements'**
  String get pushCatListingDesc;

  /// No description provided for @pushCatDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit · signup bonuses'**
  String get pushCatDeposit;

  /// No description provided for @pushCatDepositDesc.
  ///
  /// In en, this message translates to:
  /// **'Welcome and deposit bonus campaigns (can be noisy)'**
  String get pushCatDepositDesc;

  /// No description provided for @pushCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other campaigns'**
  String get pushCatOther;

  /// No description provided for @pushCatOtherDesc.
  ///
  /// In en, this message translates to:
  /// **'Fee discounts, convert challenges, and the rest'**
  String get pushCatOtherDesc;

  /// No description provided for @pushDigestTitle.
  ///
  /// In en, this message translates to:
  /// **'New opportunities'**
  String get pushDigestTitle;

  /// No description provided for @pushDigestBody.
  ///
  /// In en, this message translates to:
  /// **'New {categories} on {exchanges}.'**
  String pushDigestBody(String exchanges, String categories);

  /// No description provided for @pushDigestListTwo.
  ///
  /// In en, this message translates to:
  /// **'{a}, {b}'**
  String pushDigestListTwo(String a, String b);

  /// No description provided for @pushDigestListTwoMore.
  ///
  /// In en, this message translates to:
  /// **'{a}, {b}, and more'**
  String pushDigestListTwoMore(String a, String b);

  /// No description provided for @pushDigestCatContest.
  ///
  /// In en, this message translates to:
  /// **'contests'**
  String get pushDigestCatContest;

  /// No description provided for @pushDigestCatEarn.
  ///
  /// In en, this message translates to:
  /// **'Earn'**
  String get pushDigestCatEarn;

  /// No description provided for @pushDigestCatListing.
  ///
  /// In en, this message translates to:
  /// **'listings'**
  String get pushDigestCatListing;

  /// No description provided for @pushDigestCatDeposit.
  ///
  /// In en, this message translates to:
  /// **'deposit bonuses'**
  String get pushDigestCatDeposit;

  /// No description provided for @pushDigestCatOther.
  ///
  /// In en, this message translates to:
  /// **'campaigns'**
  String get pushDigestCatOther;

  /// No description provided for @pushDigestExBinance.
  ///
  /// In en, this message translates to:
  /// **'Binance'**
  String get pushDigestExBinance;

  /// No description provided for @pushDigestExBybit.
  ///
  /// In en, this message translates to:
  /// **'Bybit'**
  String get pushDigestExBybit;

  /// No description provided for @pushDigestExOkx.
  ///
  /// In en, this message translates to:
  /// **'OKX'**
  String get pushDigestExOkx;

  /// No description provided for @refreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// No description provided for @loadingEvents.
  ///
  /// In en, this message translates to:
  /// **'Loading events…'**
  String get loadingEvents;

  /// No description provided for @loadingEarn.
  ///
  /// In en, this message translates to:
  /// **'Loading Stable Coin Earn…'**
  String get loadingEarn;

  /// No description provided for @noMatchingItems.
  ///
  /// In en, this message translates to:
  /// **'No items match your filters.'**
  String get noMatchingItems;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events to show.'**
  String get noEvents;

  /// No description provided for @noEarnProducts.
  ///
  /// In en, this message translates to:
  /// **'No Earn products to show.'**
  String get noEarnProducts;

  /// No description provided for @eventsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load events.'**
  String get eventsLoadFailed;

  /// No description provided for @earnLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load Earn info.'**
  String get earnLoadFailed;

  /// No description provided for @networkRetryHint.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get networkRetryHint;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortEndingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get sortEndingSoon;

  /// No description provided for @exchangeBybit.
  ///
  /// In en, this message translates to:
  /// **'Bybit'**
  String get exchangeBybit;

  /// No description provided for @exchangeBinance.
  ///
  /// In en, this message translates to:
  /// **'Binance'**
  String get exchangeBinance;

  /// No description provided for @exchangeOkx.
  ///
  /// In en, this message translates to:
  /// **'OKX'**
  String get exchangeOkx;

  /// No description provided for @exchangeUpbit.
  ///
  /// In en, this message translates to:
  /// **'Upbit'**
  String get exchangeUpbit;

  /// No description provided for @exchangeBithumb.
  ///
  /// In en, this message translates to:
  /// **'Bithumb'**
  String get exchangeBithumb;

  /// No description provided for @exchangeBitget.
  ///
  /// In en, this message translates to:
  /// **'Bitget'**
  String get exchangeBitget;

  /// No description provided for @typeEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get typeEvent;

  /// No description provided for @typeTradingContest.
  ///
  /// In en, this message translates to:
  /// **'Trading contest'**
  String get typeTradingContest;

  /// No description provided for @contestsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Trading contests'**
  String get contestsHubTitle;

  /// No description provided for @contestsHubBody.
  ///
  /// In en, this message translates to:
  /// **'Compare live contests across exchanges in one feed.'**
  String get contestsHubBody;

  /// No description provided for @noContests.
  ///
  /// In en, this message translates to:
  /// **'No trading contests to show.'**
  String get noContests;

  /// No description provided for @typeEarnBoost.
  ///
  /// In en, this message translates to:
  /// **'Earn boost'**
  String get typeEarnBoost;

  /// No description provided for @typeDepositBonus.
  ///
  /// In en, this message translates to:
  /// **'Deposit bonus'**
  String get typeDepositBonus;

  /// No description provided for @typeConvertChallenge.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get typeConvertChallenge;

  /// No description provided for @typeDualChallenge.
  ///
  /// In en, this message translates to:
  /// **'Dual'**
  String get typeDualChallenge;

  /// No description provided for @typeFeePromo.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get typeFeePromo;

  /// No description provided for @typeListing.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get typeListing;

  /// No description provided for @typeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get typeOther;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get statusLive;

  /// No description provided for @statusEndingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get statusEndingSoon;

  /// No description provided for @statusEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get statusEnded;

  /// No description provided for @endingSoonBadge.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get endingSoonBadge;

  /// No description provided for @rewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward {value}'**
  String rewardLabel(String value);

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends {value}'**
  String deadlineLabel(String value);

  /// No description provided for @periodRange.
  ///
  /// In en, this message translates to:
  /// **'Period {start} ~ {end}{suffix}'**
  String periodRange(String start, String end, String suffix);

  /// No description provided for @publishedAt.
  ///
  /// In en, this message translates to:
  /// **'Posted {date}'**
  String publishedAt(String date);

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @detailReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get detailReward;

  /// No description provided for @detailType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get detailType;

  /// No description provided for @detailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get detailStatus;

  /// No description provided for @detailStart.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get detailStart;

  /// No description provided for @detailEnd.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get detailEnd;

  /// No description provided for @detailEligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get detailEligibility;

  /// No description provided for @detailRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get detailRegion;

  /// No description provided for @detailTasks.
  ///
  /// In en, this message translates to:
  /// **'How to join'**
  String get detailTasks;

  /// No description provided for @detailAsOf.
  ///
  /// In en, this message translates to:
  /// **'As of {date} · Not investment advice · Prefer the original terms'**
  String detailAsOf(String date);

  /// No description provided for @invalidLink.
  ///
  /// In en, this message translates to:
  /// **'No valid link.'**
  String get invalidLink;

  /// No description provided for @cannotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link.'**
  String get cannotOpenLink;

  /// No description provided for @cannotOpenEarnPage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the Earn page.'**
  String get cannotOpenEarnPage;

  /// No description provided for @aiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI details'**
  String get aiSummary;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing'**
  String get aiAnalyzing;

  /// No description provided for @aiEasyExplainTitle.
  ///
  /// In en, this message translates to:
  /// **'AI detailed explanation'**
  String get aiEasyExplainTitle;

  /// No description provided for @aiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Draft only — not investment advice. Prefer the original terms and rewards.'**
  String get aiDisclaimer;

  /// No description provided for @aiGoToSource.
  ///
  /// In en, this message translates to:
  /// **'Participate'**
  String get aiGoToSource;

  /// No description provided for @aiClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get aiClose;

  /// No description provided for @aiSectionReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get aiSectionReward;

  /// No description provided for @aiSectionPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get aiSectionPeriod;

  /// No description provided for @aiSectionConditions.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get aiSectionConditions;

  /// No description provided for @aiSectionCautions.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get aiSectionCautions;

  /// No description provided for @aiFailed.
  ///
  /// In en, this message translates to:
  /// **'AI analysis failed: {error}'**
  String aiFailed(String error);

  /// No description provided for @viewOriginal.
  ///
  /// In en, this message translates to:
  /// **'View original'**
  String get viewOriginal;

  /// No description provided for @bannerSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get bannerSignUp;

  /// No description provided for @appIconExperimentTooltip.
  ///
  /// In en, this message translates to:
  /// **'App icon experiment'**
  String get appIconExperimentTooltip;

  /// No description provided for @appIconExperimentTitle.
  ///
  /// In en, this message translates to:
  /// **'App icon experiment'**
  String get appIconExperimentTitle;

  /// No description provided for @appIconExperimentBody.
  ///
  /// In en, this message translates to:
  /// **'Try Hub or Portal as the home-screen icon. You can switch anytime.'**
  String get appIconExperimentBody;

  /// No description provided for @appIconHub.
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get appIconHub;

  /// No description provided for @appIconPortal.
  ///
  /// In en, this message translates to:
  /// **'Portal'**
  String get appIconPortal;

  /// No description provided for @appIconSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get appIconSelected;

  /// No description provided for @appIconChanged.
  ///
  /// In en, this message translates to:
  /// **'App icon updated.'**
  String get appIconChanged;

  /// No description provided for @appIconChangedAndroid.
  ///
  /// In en, this message translates to:
  /// **'App icon will update after you leave the app.'**
  String get appIconChangedAndroid;

  /// No description provided for @appIconUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Icon switching isn’t supported on this device.'**
  String get appIconUnsupported;

  /// No description provided for @appIconChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t change icon: {error}'**
  String appIconChangeFailed(String error);

  /// No description provided for @adConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'AI details'**
  String get adConfirmTitle;

  /// No description provided for @adConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to unlock the AI detailed explanation. Continue?'**
  String get adConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @adConfirmContinue.
  ///
  /// In en, this message translates to:
  /// **'Watch ad & continue'**
  String get adConfirmContinue;

  /// No description provided for @earnHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Stable Coin Earn'**
  String get earnHeroTitle;

  /// No description provided for @earnHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Flexible stablecoin rates by exchange. Pick a coin below. Effective APR can vary by tier and timing.'**
  String get earnHeroBody;

  /// No description provided for @earnFlexibleBadge.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get earnFlexibleBadge;

  /// No description provided for @earnMinAmount.
  ///
  /// In en, this message translates to:
  /// **'Min {amount} {coin}'**
  String earnMinAmount(String amount, String coin);

  /// No description provided for @earnMarketApr.
  ///
  /// In en, this message translates to:
  /// **'Market APR {value}'**
  String earnMarketApr(String value);

  /// No description provided for @earnOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Open Earn page'**
  String get earnOpenPage;

  /// No description provided for @earnUnavailableBitget.
  ///
  /// In en, this message translates to:
  /// **'Bitget Savings requires an API key.'**
  String get earnUnavailableBitget;

  /// No description provided for @earnUnavailableUpbit.
  ///
  /// In en, this message translates to:
  /// **'Upbit has no public Flexible Earn API.'**
  String get earnUnavailableUpbit;

  /// No description provided for @earnUnavailableBithumb.
  ///
  /// In en, this message translates to:
  /// **'Bithumb has no public Flexible Earn API.'**
  String get earnUnavailableBithumb;

  /// No description provided for @earnTierNote.
  ///
  /// In en, this message translates to:
  /// **'Applied APR may vary by balance tier.'**
  String get earnTierNote;

  /// No description provided for @bannerBybitTitle.
  ///
  /// In en, this message translates to:
  /// **'Trading campaigns'**
  String get bannerBybitTitle;

  /// No description provided for @bannerBybitBody.
  ///
  /// In en, this message translates to:
  /// **'Catch the latest Bybit rewards and contests'**
  String get bannerBybitBody;

  /// No description provided for @bannerBinanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Global event hub'**
  String get bannerBinanceTitle;

  /// No description provided for @bannerBinanceBody.
  ///
  /// In en, this message translates to:
  /// **'Browse Binance campaigns in one place'**
  String get bannerBinanceBody;

  /// No description provided for @bannerOkxTitle.
  ///
  /// In en, this message translates to:
  /// **'Simple opportunity board'**
  String get bannerOkxTitle;

  /// No description provided for @bannerOkxBody.
  ///
  /// In en, this message translates to:
  /// **'Campaigns and rewards, without the noise'**
  String get bannerOkxBody;

  /// No description provided for @bannerUpbitTitle.
  ///
  /// In en, this message translates to:
  /// **'Local notices & events'**
  String get bannerUpbitTitle;

  /// No description provided for @bannerUpbitBody.
  ///
  /// In en, this message translates to:
  /// **'Spot listing and event news quickly'**
  String get bannerUpbitBody;

  /// No description provided for @bannerBithumbTitle.
  ///
  /// In en, this message translates to:
  /// **'Hot promotions'**
  String get bannerBithumbTitle;

  /// No description provided for @bannerBithumbBody.
  ///
  /// In en, this message translates to:
  /// **'A warm roundup of events and notices'**
  String get bannerBithumbBody;

  /// No description provided for @bannerBitgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy & event zone'**
  String get bannerBitgetTitle;

  /// No description provided for @bannerBitgetBody.
  ///
  /// In en, this message translates to:
  /// **'Rewards and campaigns, neon-clear'**
  String get bannerBitgetBody;

  /// No description provided for @activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} live'**
  String activeCount(int count);

  /// No description provided for @earnUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get earnUnsupported;

  /// No description provided for @earnAprLabel.
  ///
  /// In en, this message translates to:
  /// **'Listed APR (Flexible)'**
  String get earnAprLabel;

  /// No description provided for @earnAvgApr.
  ///
  /// In en, this message translates to:
  /// **'Avg {value}'**
  String earnAvgApr(String value);

  /// No description provided for @earnPrevApr.
  ///
  /// In en, this message translates to:
  /// **' · Prev {value}'**
  String earnPrevApr(String value);

  /// No description provided for @earnTierRates.
  ///
  /// In en, this message translates to:
  /// **'Tier rates'**
  String get earnTierRates;

  /// No description provided for @categoryNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get categoryNotice;

  /// No description provided for @exchangeGate.
  ///
  /// In en, this message translates to:
  /// **'Gate'**
  String get exchangeGate;

  /// No description provided for @exchangeMexc.
  ///
  /// In en, this message translates to:
  /// **'MEXC'**
  String get exchangeMexc;

  /// No description provided for @exchangeKucoin.
  ///
  /// In en, this message translates to:
  /// **'KuCoin'**
  String get exchangeKucoin;

  /// No description provided for @exchangeCoinbase.
  ///
  /// In en, this message translates to:
  /// **'Coinbase'**
  String get exchangeCoinbase;

  /// No description provided for @bannerGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Listings & campaigns'**
  String get bannerGateTitle;

  /// No description provided for @bannerGateBody.
  ///
  /// In en, this message translates to:
  /// **'Gate promotions and trading contests in one feed'**
  String get bannerGateBody;

  /// No description provided for @bannerMexcTitle.
  ///
  /// In en, this message translates to:
  /// **'Event radar'**
  String get bannerMexcTitle;

  /// No description provided for @bannerMexcBody.
  ///
  /// In en, this message translates to:
  /// **'Catch MEXC listings and zero-fee campaigns'**
  String get bannerMexcBody;

  /// No description provided for @bannerKucoinTitle.
  ///
  /// In en, this message translates to:
  /// **'KuCoin pulse'**
  String get bannerKucoinTitle;

  /// No description provided for @bannerKucoinBody.
  ///
  /// In en, this message translates to:
  /// **'Listings, earn boosts, and platform news'**
  String get bannerKucoinBody;

  /// No description provided for @bannerCoinbaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange notices'**
  String get bannerCoinbaseTitle;

  /// No description provided for @bannerCoinbaseBody.
  ///
  /// In en, this message translates to:
  /// **'Status updates and scheduled maintenance'**
  String get bannerCoinbaseBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
