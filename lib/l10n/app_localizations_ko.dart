// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Exora';

  @override
  String get sectionEvents => '거래소 이벤트';

  @override
  String get sectionEarning => 'Stable Coin Earn';

  @override
  String get sectionEarningShort => 'Stable Coin Earn';

  @override
  String get menuSelect => '메뉴 선택';

  @override
  String get searchEventsHint => '이벤트 검색';

  @override
  String get searchTooltip => '검색';

  @override
  String get searchCloseTooltip => '검색 닫기';

  @override
  String get shareTooltip => '공유';

  @override
  String shareMessage(String url) {
    return 'Exora — 암호화폐 거래소 허브를 확인해 보세요\n$url';
  }

  @override
  String get notificationsTooltip => '알림';

  @override
  String get notificationsComingSoon => '알림 기능은 곧 제공됩니다.';

  @override
  String get pushSettingsTitle => '푸시 알림';

  @override
  String get pushSettingsIntro =>
      '앱을 켜지 않아도 유용한 거래소 기회를 받아보세요. 관심 있는 항목만 켜 두세요.';

  @override
  String get pushMasterTitle => '푸시 알림 전체 켜기/끄기';

  @override
  String get pushMasterSubtitle => '푸시 알림 전체 켜기/끄기';

  @override
  String get pushPermissionDenied => '알림 권한이 거부되었습니다.';

  @override
  String get pushCategoriesSection => '어떤 소식을 받을까요';

  @override
  String get pushExchangesSection => '어느 거래소';

  @override
  String get pushExchangesHint => '카테고리와 거래소를 모두 켠 조합만 알림이 갑니다.';

  @override
  String get pushOtherExchangesNote =>
      'Gate, MEXC 등 다른 거래소는 아직 서버 폴링 대상이 아닙니다.';

  @override
  String get pushCatContest => '거래 대회 / 컨테스트';

  @override
  String get pushCatContestDesc => '거래량·PNL 대회, 보상 캠페인';

  @override
  String get pushCatEarn => 'Earn · APR 부스트';

  @override
  String get pushCatEarnDesc => 'Flexible/Fixed 프로모, Launchpool 성격 이벤트';

  @override
  String get pushCatListing => '신규 상장 · Launchpad';

  @override
  String get pushCatListingDesc => '상장·런치 공지';

  @override
  String get pushCatDeposit => '입금·가입 보너스';

  @override
  String get pushCatDepositDesc => '웰컴·입금 보너스 (알림이 많을 수 있음)';

  @override
  String get pushCatOther => '기타 캠페인';

  @override
  String get pushCatOtherDesc => '수수료 할인, Convert 챌린지 등';

  @override
  String get pushDigestTitle => '새 기회 알림';

  @override
  String pushDigestBody(String exchanges, String categories) {
    return '$exchanges에 새로운 $categories 소식이 있습니다.';
  }

  @override
  String pushDigestListTwo(String a, String b) {
    return '$a, $b';
  }

  @override
  String pushDigestListTwoMore(String a, String b) {
    return '$a, $b 등';
  }

  @override
  String get pushDigestCatContest => '대회';

  @override
  String get pushDigestCatEarn => 'Earn';

  @override
  String get pushDigestCatListing => '상장';

  @override
  String get pushDigestCatDeposit => '입금 보너스';

  @override
  String get pushDigestCatOther => '이벤트';

  @override
  String get pushDigestExBinance => '바이낸스';

  @override
  String get pushDigestExBybit => 'Bybit';

  @override
  String get pushDigestExOkx => 'OKX';

  @override
  String get refreshTooltip => '새로고침';

  @override
  String get loadingEvents => '이벤트 불러오는 중…';

  @override
  String get loadingEarn => 'Stable Coin Earn 불러오는 중…';

  @override
  String get noMatchingItems => '조건에 맞는 항목이 없습니다.';

  @override
  String get noEvents => '표시할 이벤트가 없습니다.';

  @override
  String get noEarnProducts => '표시할 Earn 상품이 없습니다.';

  @override
  String get eventsLoadFailed => '이벤트를 불러오지 못했습니다.';

  @override
  String get earnLoadFailed => 'Earn 정보를 불러오지 못했습니다.';

  @override
  String get networkRetryHint => '네트워크 상태를 확인한 뒤 다시 시도해 주세요.';

  @override
  String get retry => '다시 시도';

  @override
  String get filterAll => '전체';

  @override
  String get sortNewest => '최신순';

  @override
  String get sortEndingSoon => '마감 임박순';

  @override
  String get exchangeBybit => '바이비트';

  @override
  String get exchangeBinance => '바이낸스';

  @override
  String get exchangeOkx => 'OKX';

  @override
  String get exchangeUpbit => '업비트';

  @override
  String get exchangeBithumb => '빗썸';

  @override
  String get exchangeBitget => 'Bitget';

  @override
  String get typeEvent => '이벤트';

  @override
  String get typeTradingContest => '거래대회';

  @override
  String get contestsHubTitle => '거래대회';

  @override
  String get contestsHubBody => '전 거래소 거래대회를 한곳에서 비교하세요.';

  @override
  String get noContests => '표시할 거래대회가 없습니다.';

  @override
  String get typeEarnBoost => 'Earn부스트';

  @override
  String get typeDepositBonus => '입금보너스';

  @override
  String get typeConvertChallenge => 'Convert';

  @override
  String get typeDualChallenge => '듀얼';

  @override
  String get typeFeePromo => '수수료';

  @override
  String get typeListing => '상장';

  @override
  String get typeOther => '기타';

  @override
  String get statusUpcoming => '예정';

  @override
  String get statusLive => '진행중';

  @override
  String get statusEndingSoon => '곧마감';

  @override
  String get statusEnded => '종료';

  @override
  String get endingSoonBadge => '곧 마감';

  @override
  String rewardLabel(String value) {
    return '보상 $value';
  }

  @override
  String deadlineLabel(String value) {
    return '마감 $value';
  }

  @override
  String periodRange(String start, String end, String suffix) {
    return '기간 $start ~ $end$suffix';
  }

  @override
  String publishedAt(String date) {
    return '게시 $date';
  }

  @override
  String get closed => '마감';

  @override
  String get detailReward => '보상';

  @override
  String get detailType => '유형';

  @override
  String get detailStatus => '상태';

  @override
  String get detailStart => '시작';

  @override
  String get detailEnd => '마감';

  @override
  String get detailEligibility => '자격';

  @override
  String get detailRegion => '지역';

  @override
  String get detailTasks => '참여 단계';

  @override
  String detailAsOf(String date) {
    return '기준 $date · 투자 권유 아님 · 조건은 원문 우선';
  }

  @override
  String get invalidLink => '유효한 링크가 없습니다.';

  @override
  String get cannotOpenLink => '링크를 열 수 없습니다.';

  @override
  String get cannotOpenEarnPage => 'Earn 페이지를 열 수 없습니다.';

  @override
  String get aiSummary => 'AI 요약';

  @override
  String get aiAnalyzing => '분석 중';

  @override
  String get aiEasyExplainTitle => 'AI 쉬운 설명';

  @override
  String get aiDisclaimer => '초안이며 투자 권유가 아닙니다. 조건·보상은 원문을 우선하세요.';

  @override
  String get aiGoToSource => '본문으로 이동';

  @override
  String get aiSectionReward => '보상';

  @override
  String get aiSectionPeriod => '기간';

  @override
  String get aiSectionConditions => '참여 조건';

  @override
  String get aiSectionCautions => '주의';

  @override
  String aiFailed(String error) {
    return 'AI 분석 실패: $error';
  }

  @override
  String get viewOriginal => '원문 보기';

  @override
  String get bannerSignUp => '가입하기';

  @override
  String get appIconExperimentTooltip => '앱 아이콘 실험';

  @override
  String get appIconExperimentTitle => '앱 아이콘 실험';

  @override
  String get appIconExperimentBody =>
      '홈 화면 아이콘을 Hub / Portal 중 골라 비교해 보세요. 언제든 바꿀 수 있습니다.';

  @override
  String get appIconHub => 'Hub';

  @override
  String get appIconPortal => 'Portal';

  @override
  String get appIconSelected => '선택됨';

  @override
  String get appIconChanged => '앱 아이콘을 바꿨습니다.';

  @override
  String get appIconChangedAndroid => '앱을 나간 뒤에 아이콘이 반영됩니다.';

  @override
  String get appIconUnsupported => '이 기기에서는 아이콘 교체를 지원하지 않습니다.';

  @override
  String appIconChangeFailed(String error) {
    return '아이콘을 바꾸지 못했습니다: $error';
  }

  @override
  String get adConfirmTitle => 'AI 요약';

  @override
  String get adConfirmMessage => '광고를 시청한 뒤 AI 요약을 확인할 수 있습니다. 계속할까요?';

  @override
  String get cancel => '취소';

  @override
  String get adConfirmContinue => '광고 보고 계속';

  @override
  String get earnHeroTitle => 'Stable Coin Earn';

  @override
  String get earnHeroBody =>
      '거래소별 유연(Flexible) 스테이블코인 거치 금리입니다. 아래에서 코인을 고르세요. 구간·시점에 따라 실효 금리가 달라질 수 있습니다.';

  @override
  String get earnFlexibleBadge => 'Flexible';

  @override
  String earnMinAmount(String amount, String coin) {
    return '최소 $amount $coin';
  }

  @override
  String earnMarketApr(String value) {
    return 'Market APR $value';
  }

  @override
  String get earnOpenPage => 'Earn 페이지로 이동';

  @override
  String get earnUnavailableBitget => 'Bitget Savings 상품 조회는 API 키가 필요합니다.';

  @override
  String get earnUnavailableUpbit => '업비트는 공개 Flexible Earn API가 없습니다.';

  @override
  String get earnUnavailableBithumb => '빗썸은 공개 Flexible Earn API가 없습니다.';

  @override
  String get earnTierNote => '금액 구간에 따라 적용 APR이 달라질 수 있습니다.';

  @override
  String get bannerBybitTitle => '트레이딩 캠페인';

  @override
  String get bannerBybitBody => '최신 리워드와 대회를 한눈에';

  @override
  String get bannerBinanceTitle => '글로벌 이벤트 허브';

  @override
  String get bannerBinanceBody => '바이낸스 캠페인을 한곳에서';

  @override
  String get bannerOkxTitle => '심플한 기회 보드';

  @override
  String get bannerOkxBody => '캠페인·리워드를 군더더기 없이';

  @override
  String get bannerUpbitTitle => '국내 공지·이벤트';

  @override
  String get bannerUpbitBody => '상장·이벤트 소식을 빠르게 확인하세요';

  @override
  String get bannerBithumbTitle => '핫한 프로모션';

  @override
  String get bannerBithumbBody => '이벤트·공지를 따뜻하게 모아봤어요';

  @override
  String get bannerBitgetTitle => '카피·이벤트 존';

  @override
  String get bannerBitgetBody => '리워드와 캠페인을 네온처럼 선명하게';

  @override
  String activeCount(int count) {
    return '$count개 진행 중';
  }

  @override
  String get earnUnsupported => '미지원';

  @override
  String get earnAprLabel => '예상/고시 APR (Flexible)';

  @override
  String earnAvgApr(String value) {
    return '평균 $value';
  }

  @override
  String earnPrevApr(String value) {
    return ' · 직전 $value';
  }

  @override
  String get earnTierRates => '구간별 금리';

  @override
  String get categoryNotice => '공지';

  @override
  String get exchangeGate => 'Gate';

  @override
  String get exchangeMexc => 'MEXC';

  @override
  String get exchangeKucoin => 'KuCoin';

  @override
  String get exchangeCoinbase => 'Coinbase';

  @override
  String get bannerGateTitle => '상장·캠페인';

  @override
  String get bannerGateBody => 'Gate 프로모션과 거래 대회를 한곳에서';

  @override
  String get bannerMexcTitle => '이벤트 레이더';

  @override
  String get bannerMexcBody => 'MEXC 상장과 수수료 이벤트를 빠르게';

  @override
  String get bannerKucoinTitle => 'KuCoin 소식';

  @override
  String get bannerKucoinBody => '상장, Earn 부스트, 플랫폼 공지';

  @override
  String get bannerCoinbaseTitle => '거래소 공지';

  @override
  String get bannerCoinbaseBody => '상태 업데이트와 예정된 점검 안내';
}
