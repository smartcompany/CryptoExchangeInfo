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
  String get sectionEarning => 'Earning（Flexible USDT）';

  @override
  String get sectionEarningShort => 'Flexible USDT';

  @override
  String get menuSelect => 'メニューを選択';

  @override
  String get searchEventsHint => 'イベントを検索';

  @override
  String get searchTooltip => '検索';

  @override
  String get searchCloseTooltip => '検索を閉じる';

  @override
  String get notificationsTooltip => '通知';

  @override
  String get notificationsComingSoon => '通知機能は近日公開予定です。';

  @override
  String get refreshTooltip => '更新';

  @override
  String get loadingEvents => 'イベントを読み込み中…';

  @override
  String get loadingEarn => 'Flexible USDT Earn を読み込み中…';

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
  String get aiSummary => 'AI要約';

  @override
  String get aiAnalyzing => '分析中';

  @override
  String get aiEasyExplainTitle => 'AIかんたん解説';

  @override
  String get aiDisclaimer => '下書きであり投資助言ではありません。条件・報酬は原文を優先してください。';

  @override
  String get aiGoToSource => '本文へ移動';

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
  String get adConfirmTitle => 'AI要約';

  @override
  String get adConfirmMessage => '広告を視聴するとAI要約を確認できます。続けますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get adConfirmContinue => '広告を見て続行';

  @override
  String get earnHeroTitle => 'Flexible USDT';

  @override
  String get earnHeroBody =>
      '取引所ごとのFlexible USDT利回りです。階層・時点により実効利回りが変わる場合があります。';

  @override
  String earnMinAmount(String amount) {
    return '最低 $amount USDT';
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
  String get earnUnavailableUpbit => 'Upbitに公開Flexible USDT Earn APIはありません。';

  @override
  String get earnUnavailableBithumb =>
      'Bithumbに公開Flexible USDT Earn APIはありません。';

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
  String get exchangeHtx => 'HTX';

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

  @override
  String get bannerHtxTitle => 'HTXアクティビティ';

  @override
  String get bannerHtxBody => '最新キャンペーンとリワード';
}
