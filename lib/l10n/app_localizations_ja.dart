// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Exora';

  @override
  String get sectionEvents => '取引所イベント';

  @override
  String get sectionEarning => 'Stable Coin Earn';

  @override
  String get sectionEarningShort => 'Stable Coin Earn';

  @override
  String get menuSelect => 'メニューを選択';

  @override
  String get searchEventsHint => 'イベントを検索';

  @override
  String get searchTooltip => '検索';

  @override
  String get searchCloseTooltip => '検索を閉じる';

  @override
  String get shareTooltip => '共有';

  @override
  String shareMessage(String url) {
    return 'Exora — 暗号資産取引所ハブをチェック\n$url';
  }

  @override
  String get notificationsTooltip => '通知';

  @override
  String get notificationsComingSoon => '通知機能は近日公開予定です。';

  @override
  String get pushSettingsTitle => 'プッシュ通知';

  @override
  String get pushSettingsIntro =>
      'アプリを開かなくても役立つ取引所の機会を受け取れます。必要な項目だけオンにしてください。';

  @override
  String get pushMasterTitle => 'プッシュ通知のオン/オフ';

  @override
  String get pushMasterSubtitle => 'プッシュ通知のマスタースイッチ';

  @override
  String get pushPermissionDenied => '通知の許可が拒否されました。';

  @override
  String get pushCategoriesSection => '受け取る内容';

  @override
  String get pushExchangesSection => '取引所';

  @override
  String get pushExchangesHint => 'カテゴリと取引所の両方がオンのときだけ通知されます。';

  @override
  String get pushOtherExchangesNote => 'Gate・MEXC などはまだサーバーポーリング対象外です。';

  @override
  String get pushCatContest => '取引コンテスト';

  @override
  String get pushCatContestDesc => '出来高・PNL大会、報酬キャンペーン';

  @override
  String get pushCatEarn => 'Earn · APRブースト';

  @override
  String get pushCatEarnDesc => 'Flexible/Fixed プロモ、Launchpool系';

  @override
  String get pushCatListing => '新規上場 · Launchpad';

  @override
  String get pushCatListingDesc => '上場・ローンチ告知';

  @override
  String get pushCatDeposit => '入金・登録ボーナス';

  @override
  String get pushCatDepositDesc => 'ウェルカム・入金ボーナス（多めになりがち）';

  @override
  String get pushCatOther => 'その他キャンペーン';

  @override
  String get pushCatOtherDesc => '手数料割引、Convertチャレンジなど';

  @override
  String get pushDigestTitle => '新しい機会';

  @override
  String pushDigestBody(String exchanges, String categories) {
    return '$exchangesに新しい$categoriesがあります。';
  }

  @override
  String pushDigestListTwo(String a, String b) {
    return '$a、$b';
  }

  @override
  String pushDigestListTwoMore(String a, String b) {
    return '$a、$bなど';
  }

  @override
  String get pushDigestCatContest => '大会';

  @override
  String get pushDigestCatEarn => 'Earn';

  @override
  String get pushDigestCatListing => '上場';

  @override
  String get pushDigestCatDeposit => '入金ボーナス';

  @override
  String get pushDigestCatOther => 'キャンペーン';

  @override
  String get pushDigestExBinance => 'Binance';

  @override
  String get pushDigestExBybit => 'Bybit';

  @override
  String get pushDigestExOkx => 'OKX';

  @override
  String get refreshTooltip => '更新';

  @override
  String get loadingEvents => 'イベントを読み込み中…';

  @override
  String get loadingEarn => 'Stable Coin Earn を読み込み中…';

  @override
  String get noMatchingItems => '条件に一致する項目がありません。';

  @override
  String get noEvents => '表示できるイベントがありません。';

  @override
  String get noEarnProducts => '表示できる Earn 商品がありません。';

  @override
  String get eventsLoadFailed => 'イベントを読み込めませんでした。';

  @override
  String get earnLoadFailed => 'Earn 情報を読み込めませんでした。';

  @override
  String get networkRetryHint => 'ネットワークを確認して再試行してください。';

  @override
  String get retry => '再試行';

  @override
  String get filterAll => 'すべて';

  @override
  String get sortNewest => '新しい順';

  @override
  String get sortEndingSoon => '終了間近';

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
  String get typeEvent => 'イベント';

  @override
  String get typeTradingContest => '取引大会';

  @override
  String get contestsHubTitle => '取引大会';

  @override
  String get contestsHubBody => '各取引所の大会をひとつのフィードで比較できます。';

  @override
  String get noContests => '表示できる取引大会がありません。';

  @override
  String get typeEarnBoost => 'Earnブースト';

  @override
  String get typeDepositBonus => '入金ボーナス';

  @override
  String get typeConvertChallenge => 'Convert';

  @override
  String get typeDualChallenge => 'デュアル';

  @override
  String get typeFeePromo => '手数料';

  @override
  String get typeListing => '上場';

  @override
  String get typeOther => 'その他';

  @override
  String get statusUpcoming => '予定';

  @override
  String get statusLive => '開催中';

  @override
  String get statusEndingSoon => 'まもなく終了';

  @override
  String get statusEnded => '終了';

  @override
  String get endingSoonBadge => 'まもなく終了';

  @override
  String rewardLabel(String value) {
    return '報酬 $value';
  }

  @override
  String deadlineLabel(String value) {
    return '締切 $value';
  }

  @override
  String periodRange(String start, String end, String suffix) {
    return '期間 $start ~ $end$suffix';
  }

  @override
  String publishedAt(String date) {
    return '公開 $date';
  }

  @override
  String get closed => '締切';

  @override
  String get detailReward => '報酬';

  @override
  String get detailType => '種別';

  @override
  String get detailStatus => 'ステータス';

  @override
  String get detailStart => '開始';

  @override
  String get detailEnd => '締切';

  @override
  String get detailEligibility => '参加資格';

  @override
  String get detailRegion => '地域';

  @override
  String get detailTasks => '参加手順';

  @override
  String detailAsOf(String date) {
    return '基準 $date · 投資助言ではありません · 条件は原文を優先';
  }

  @override
  String get invalidLink => '有効なリンクがありません。';

  @override
  String get cannotOpenLink => 'リンクを開けません。';

  @override
  String get cannotOpenEarnPage => 'Earn ページを開けません。';

  @override
  String get aiSummary => 'AI詳細';

  @override
  String get aiAnalyzing => '分析中';

  @override
  String get aiEasyExplainTitle => 'AI詳細な説明';

  @override
  String get aiDisclaimer => '下書きであり投資助言ではありません。条件・報酬は原文を優先してください。';

  @override
  String get aiGoToSource => '参加する';

  @override
  String get aiClose => '閉じる';

  @override
  String get aiSectionReward => '報酬';

  @override
  String get aiSectionPeriod => '期間';

  @override
  String get aiSectionConditions => '参加条件';

  @override
  String get aiSectionCautions => '注意';

  @override
  String aiFailed(String error) {
    return 'AI分析に失敗しました: $error';
  }

  @override
  String get viewOriginal => '原文を見る';

  @override
  String get bannerSignUp => '登録する';

  @override
  String get appIconExperimentTooltip => 'アプリアイコン実験';

  @override
  String get appIconExperimentTitle => 'アプリアイコン実験';

  @override
  String get appIconExperimentBody =>
      'ホーム画面アイコンを Hub / Portal で試せます。いつでも切り替え可能です。';

  @override
  String get appIconHub => 'Hub';

  @override
  String get appIconPortal => 'Portal';

  @override
  String get appIconSelected => '選択中';

  @override
  String get appIconChanged => 'アプリアイコンを更新しました。';

  @override
  String get appIconChangedAndroid => 'アプリを終了するとアイコンが反映されます。';

  @override
  String get appIconUnsupported => 'この端末ではアイコン切替に対応していません。';

  @override
  String appIconChangeFailed(String error) {
    return 'アイコンを変更できませんでした: $error';
  }

  @override
  String get adConfirmTitle => 'AI詳細';

  @override
  String get adConfirmMessage => '広告を視聴するとAI詳細な説明を確認できます。続けますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get adConfirmContinue => '広告を見て続行';

  @override
  String get earnHeroTitle => 'Stable Coin Earn';

  @override
  String get earnHeroBody =>
      '取引所ごとのFlexibleステーブルコイン利回りです。下でコインを選んでください。階層・時点により実効利回りが変わる場合があります。';

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
  String get earnOpenPage => 'Earnページへ';

  @override
  String get earnUnavailableBitget => 'Bitget Savingsの照会にはAPIキーが必要です。';

  @override
  String get earnUnavailableUpbit => 'Upbitに公開Flexible Earn APIはありません。';

  @override
  String get earnUnavailableBithumb => 'Bithumbに公開Flexible Earn APIはありません。';

  @override
  String get earnTierNote => '金額帯により適用APRが異なる場合があります。';

  @override
  String get bannerBybitTitle => 'トレーディングキャンペーン';

  @override
  String get bannerBybitBody => '最新の報酬と大会を一覧で';

  @override
  String get bannerBinanceTitle => 'グローバルイベントハブ';

  @override
  String get bannerBinanceBody => 'Binanceキャンペーンを一か所で';

  @override
  String get bannerOkxTitle => 'シンプルな機会ボード';

  @override
  String get bannerOkxBody => 'キャンペーンと報酬をすっきりと';

  @override
  String get bannerUpbitTitle => '国内のお知らせ・イベント';

  @override
  String get bannerUpbitBody => '上場・イベント情報をすばやく確認';

  @override
  String get bannerBithumbTitle => '注目プロモーション';

  @override
  String get bannerBithumbBody => 'イベントとお知らせをやさしくまとめました';

  @override
  String get bannerBitgetTitle => 'コピー＆イベントゾーン';

  @override
  String get bannerBitgetBody => '報酬とキャンペーンをくっきりと';

  @override
  String activeCount(int count) {
    return '$count件 開催中';
  }

  @override
  String get earnUnsupported => '非対応';

  @override
  String get earnAprLabel => '想定/表示APR（フレキシブル）';

  @override
  String earnAvgApr(String value) {
    return '平均 $value';
  }

  @override
  String earnPrevApr(String value) {
    return ' · 前回 $value';
  }

  @override
  String get earnTierRates => '金額帯別金利';

  @override
  String get categoryNotice => 'お知らせ';

  @override
  String get exchangeGate => 'Gate';

  @override
  String get exchangeMexc => 'MEXC';

  @override
  String get exchangeKucoin => 'KuCoin';

  @override
  String get exchangeCoinbase => 'Coinbase';

  @override
  String get bannerGateTitle => '上場・キャンペーン';

  @override
  String get bannerGateBody => 'Gateのプロモと取引大会をまとめて';

  @override
  String get bannerMexcTitle => 'イベントレーダー';

  @override
  String get bannerMexcBody => 'MEXCの上場と手数料キャンペーン';

  @override
  String get bannerKucoinTitle => 'KuCoinニュース';

  @override
  String get bannerKucoinBody => '上場、Earnブースト、公式お知らせ';

  @override
  String get bannerCoinbaseTitle => '取引所のお知らせ';

  @override
  String get bannerCoinbaseBody => 'ステータス更新と予定メンテナンス';
}
