// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Exora';

  @override
  String get sectionEvents => '交易所活动';

  @override
  String get sectionEarning => 'Stable Coin Earn';

  @override
  String get sectionEarningShort => 'Stable Coin Earn';

  @override
  String get menuSelect => '选择菜单';

  @override
  String get searchEventsHint => '搜索活动';

  @override
  String get searchTooltip => '搜索';

  @override
  String get searchCloseTooltip => '关闭搜索';

  @override
  String get shareTooltip => '分享';

  @override
  String shareMessage(String url) {
    return '来看看 Exora — 加密货币交易所中心\n$url';
  }

  @override
  String get notificationsTooltip => '通知';

  @override
  String get notificationsComingSoon => '通知功能即将推出。';

  @override
  String get pushSettingsTitle => '推送通知';

  @override
  String get pushSettingsIntro => '即使不打开应用，也能收到有用的交易所机会。只打开你关心的项目。';

  @override
  String get pushMasterTitle => '推送通知总开关';

  @override
  String get pushMasterSubtitle => '推送总开关';

  @override
  String get pushPermissionDenied => '通知权限被拒绝。';

  @override
  String get pushCategoriesSection => '接收哪些消息';

  @override
  String get pushExchangesSection => '哪些交易所';

  @override
  String get pushExchangesHint => '仅当类别与交易所都开启时才会推送。';

  @override
  String get pushOtherExchangesNote => 'Gate、MEXC 等交易所暂未纳入服务器轮询。';

  @override
  String get pushCatContest => '交易大赛';

  @override
  String get pushCatContestDesc => '交易量/盈亏大赛、奖励活动';

  @override
  String get pushCatEarn => 'Earn · APR 加成';

  @override
  String get pushCatEarnDesc => '活期/定期促销、Launchpool 类';

  @override
  String get pushCatListing => '新上线 · Launchpad';

  @override
  String get pushCatListingDesc => '上币与启动公告';

  @override
  String get pushCatDeposit => '入金·注册奖励';

  @override
  String get pushCatDepositDesc => '欢迎礼与入金奖励（可能较多）';

  @override
  String get pushCatOther => '其他活动';

  @override
  String get pushCatOtherDesc => '手续费优惠、闪兑挑战等';

  @override
  String get pushDigestTitle => '新机会提醒';

  @override
  String pushDigestBody(String exchanges, String categories) {
    return '$exchanges有新的$categories。';
  }

  @override
  String pushDigestListTwo(String a, String b) {
    return '$a、$b';
  }

  @override
  String pushDigestListTwoMore(String a, String b) {
    return '$a、$b等';
  }

  @override
  String get pushDigestCatContest => '大赛';

  @override
  String get pushDigestCatEarn => 'Earn';

  @override
  String get pushDigestCatListing => '上币';

  @override
  String get pushDigestCatDeposit => '入金奖励';

  @override
  String get pushDigestCatOther => '活动';

  @override
  String get pushDigestExBinance => '币安';

  @override
  String get pushDigestExBybit => 'Bybit';

  @override
  String get pushDigestExOkx => 'OKX';

  @override
  String get refreshTooltip => '刷新';

  @override
  String get loadingEvents => '正在加载活动…';

  @override
  String get loadingEarn => '正在加载 Stable Coin Earn…';

  @override
  String get noMatchingItems => '没有符合条件的项目。';

  @override
  String get noEvents => '暂无可显示的活动。';

  @override
  String get noEarnProducts => '暂无可显示的 Earn 产品。';

  @override
  String get eventsLoadFailed => '无法加载活动。';

  @override
  String get earnLoadFailed => '无法加载 Earn 信息。';

  @override
  String get networkRetryHint => '请检查网络后重试。';

  @override
  String get retry => '重试';

  @override
  String get filterAll => '全部';

  @override
  String get sortNewest => '最新';

  @override
  String get sortEndingSoon => '即将结束';

  @override
  String get exchangeBybit => 'Bybit';

  @override
  String get exchangeBinance => '币安';

  @override
  String get exchangeOkx => 'OKX';

  @override
  String get exchangeUpbit => 'Upbit';

  @override
  String get exchangeBithumb => 'Bithumb';

  @override
  String get exchangeBitget => 'Bitget';

  @override
  String get typeEvent => '活动';

  @override
  String get typeTradingContest => '交易大赛';

  @override
  String get contestsHubTitle => '交易大赛';

  @override
  String get contestsHubBody => '在一个列表中比较各交易所的进行中大赛。';

  @override
  String get noContests => '暂无交易大赛。';

  @override
  String get typeEarnBoost => 'Earn 加成';

  @override
  String get typeDepositBonus => '充值奖励';

  @override
  String get typeConvertChallenge => 'Convert';

  @override
  String get typeDualChallenge => '双币';

  @override
  String get typeFeePromo => '手续费';

  @override
  String get typeListing => '上新';

  @override
  String get typeOther => '其他';

  @override
  String get statusUpcoming => '即将开始';

  @override
  String get statusLive => '进行中';

  @override
  String get statusEndingSoon => '即将结束';

  @override
  String get statusEnded => '已结束';

  @override
  String get endingSoonBadge => '即将结束';

  @override
  String rewardLabel(String value) {
    return '奖励 $value';
  }

  @override
  String deadlineLabel(String value) {
    return '截止 $value';
  }

  @override
  String periodRange(String start, String end, String suffix) {
    return '期间 $start ~ $end$suffix';
  }

  @override
  String publishedAt(String date) {
    return '发布 $date';
  }

  @override
  String get closed => '已截止';

  @override
  String get detailReward => '奖励';

  @override
  String get detailType => '类型';

  @override
  String get detailStatus => '状态';

  @override
  String get detailStart => '开始';

  @override
  String get detailEnd => '截止';

  @override
  String get detailEligibility => '资格';

  @override
  String get detailRegion => '地区';

  @override
  String get detailTasks => '参与步骤';

  @override
  String detailAsOf(String date) {
    return '截至 $date · 非投资建议 · 请以原文条款为准';
  }

  @override
  String get invalidLink => '没有有效链接。';

  @override
  String get cannotOpenLink => '无法打开链接。';

  @override
  String get cannotOpenEarnPage => '无法打开 Earn 页面。';

  @override
  String get aiSummary => 'AI 详情';

  @override
  String get aiAnalyzing => '分析中';

  @override
  String get aiEasyExplainTitle => 'AI 详细说明';

  @override
  String get aiDisclaimer => '仅为草稿，不构成投资建议。请优先查看原文条件与奖励。';

  @override
  String get aiGoToSource => '去参与';

  @override
  String get aiClose => '关闭';

  @override
  String get aiSectionReward => '奖励';

  @override
  String get aiSectionPeriod => '期间';

  @override
  String get aiSectionConditions => '参与条件';

  @override
  String get aiSectionCautions => '注意';

  @override
  String aiFailed(String error) {
    return 'AI 分析失败：$error';
  }

  @override
  String get viewOriginal => '查看原文';

  @override
  String get bannerSignUp => '注册';

  @override
  String get appIconExperimentTooltip => '应用图标实验';

  @override
  String get appIconExperimentTitle => '应用图标实验';

  @override
  String get appIconExperimentBody => '可在 Hub / Portal 之间切换主屏幕图标，随时可改。';

  @override
  String get appIconHub => 'Hub';

  @override
  String get appIconPortal => 'Portal';

  @override
  String get appIconSelected => '已选';

  @override
  String get appIconChanged => '应用图标已更新。';

  @override
  String get appIconChangedAndroid => '离开应用后图标才会生效。';

  @override
  String get appIconUnsupported => '此设备不支持切换图标。';

  @override
  String appIconChangeFailed(String error) {
    return '无法更改图标：$error';
  }

  @override
  String get adConfirmTitle => 'AI 详情';

  @override
  String get adConfirmMessage => '观看广告后即可查看 AI 详细说明。是否继续？';

  @override
  String get cancel => '取消';

  @override
  String get adConfirmContinue => '观看广告并继续';

  @override
  String get earnHeroTitle => 'Stable Coin Earn';

  @override
  String get earnHeroBody => '各交易所灵活稳定币理财利率。请在下方选择币种。实际年化可能因档位与时间而异。';

  @override
  String get earnFlexibleBadge => 'Flexible';

  @override
  String earnMinAmount(String amount, String coin) {
    return '最低 $amount $coin';
  }

  @override
  String earnMarketApr(String value) {
    return 'Market APR $value';
  }

  @override
  String get earnOpenPage => '前往 Earn 页面';

  @override
  String get earnUnavailableBitget => 'Bitget Savings 查询需要 API 密钥。';

  @override
  String get earnUnavailableUpbit => 'Upbit 无公开 Flexible Earn API。';

  @override
  String get earnUnavailableBithumb => 'Bithumb 无公开 Flexible Earn API。';

  @override
  String get earnTierNote => '适用年化可能因金额档位而异。';

  @override
  String get bannerBybitTitle => '交易活动';

  @override
  String get bannerBybitBody => '一眼查看最新奖励与赛事';

  @override
  String get bannerBinanceTitle => '全球活动中心';

  @override
  String get bannerBinanceBody => '在一处浏览币安活动';

  @override
  String get bannerOkxTitle => '简洁机会看板';

  @override
  String get bannerOkxBody => '活动与奖励，干净利落';

  @override
  String get bannerUpbitTitle => '本地公告与活动';

  @override
  String get bannerUpbitBody => '快速掌握上新与活动资讯';

  @override
  String get bannerBithumbTitle => '热门促销';

  @override
  String get bannerBithumbBody => '温暖汇集活动与公告';

  @override
  String get bannerBitgetTitle => '跟单与活动区';

  @override
  String get bannerBitgetBody => '奖励与活动，清晰醒目';

  @override
  String activeCount(int count) {
    return '$count 个进行中';
  }

  @override
  String get earnUnsupported => '不支持';

  @override
  String get earnAprLabel => '预计/公示年化（活期）';

  @override
  String earnAvgApr(String value) {
    return '平均 $value';
  }

  @override
  String earnPrevApr(String value) {
    return ' · 上次 $value';
  }

  @override
  String get earnTierRates => '分档利率';

  @override
  String get categoryNotice => '公告';

  @override
  String get exchangeGate => 'Gate';

  @override
  String get exchangeMexc => 'MEXC';

  @override
  String get exchangeKucoin => 'KuCoin';

  @override
  String get exchangeCoinbase => 'Coinbase';

  @override
  String get bannerGateTitle => '上币与活动';

  @override
  String get bannerGateBody => '集中查看 Gate 促销与交易赛';

  @override
  String get bannerMexcTitle => '活动雷达';

  @override
  String get bannerMexcBody => '快速跟踪 MEXC 上币与零费率活动';

  @override
  String get bannerKucoinTitle => 'KuCoin 动态';

  @override
  String get bannerKucoinBody => '上币、Earn 加成与平台公告';

  @override
  String get bannerCoinbaseTitle => '交易所公告';

  @override
  String get bannerCoinbaseBody => '状态更新与计划维护通知';
}
