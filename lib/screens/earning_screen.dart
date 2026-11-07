import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/stable_coin.dart';
import '../services/earn_service.dart';
import '../theme/app_colors.dart';
import '../widgets/earn_product_card.dart';
import '../widgets/liquid_glass.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key, this.service, this.active = true});

  final EarnService? service;

  /// When false (IndexedStack offstage), skip network until the tab is shown.
  final bool active;

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  late final EarnService _service = widget.service ?? EarnService();

  var _started = false;
  var _catalogLoading = false;
  Object? _catalogError;
  List<StableCoin> _visibleCoins = const [];
  var _coinIndex = 0;
  final Map<StableCoin, FlexibleEarnResult> _results = {};

  StableCoin? get _coin =>
      _visibleCoins.isEmpty ? null : _visibleCoins[_coinIndex];

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _startLoad();
    }
  }

  @override
  void didUpdateWidget(covariant EarningScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _startLoad();
    }
  }

  void _startLoad() {
    if (_started) return;
    _started = true;
    _loadCatalog();
  }

  Future<void> _loadCatalog({bool forceRefresh = false}) async {
    setState(() {
      _catalogLoading = true;
      _catalogError = null;
    });
    try {
      final all = StableCoin.values;
      final fetched = await Future.wait(
        all.map(
          (coin) => _service.fetchFlexible(coin, forceRefresh: forceRefresh),
        ),
      );
      if (!mounted) return;

      final results = <StableCoin, FlexibleEarnResult>{};
      final visible = <StableCoin>[];
      for (var i = 0; i < all.length; i++) {
        final coin = all[i];
        final result = fetched[i];
        results[coin] = result;
        if (result.items.isNotEmpty) {
          visible.add(coin);
        }
      }

      var index = 0;
      final previous = _coin;
      if (previous != null) {
        final kept = visible.indexOf(previous);
        if (kept >= 0) index = kept;
      }

      setState(() {
        _results
          ..clear()
          ..addAll(results);
        _visibleCoins = visible;
        _coinIndex = index;
        _catalogLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _catalogError = e;
        _catalogLoading = false;
      });
    }
  }

  void _selectCoin(int index) {
    if (index == _coinIndex || index < 0 || index >= _visibleCoins.length) {
      return;
    }
    setState(() => _coinIndex = index);
  }

  Future<void> _reload() => _loadCatalog(forceRefresh: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_started) {
      return const SizedBox.shrink();
    }

    if (_catalogLoading && _results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.loadingEarn),
          ],
        ),
      );
    }

    if (_catalogError != null && _results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.earnLoadFailed),
              const SizedBox(height: 8),
              Text(
                _catalogError.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_visibleCoins.isEmpty) {
      return Center(child: Text(l10n.noEarnProducts));
    }

    final coin = _coin!;
    final data = _results[coin]!;
    final showPillBar = _visibleCoins.length > 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 8,
                bottom: showPillBar
                    ? AppColors.exchangeBarClearance + 24
                    : 24,
              ),
              itemCount: data.items.length + 1,
                    itemBuilder: (context, index) {
                if (index == 0) {
                  return const _EarnHubBanner();
                }
                return EarnProductCard(product: data.items[index - 1]);
              },
            ),
          ),
          if (showPillBar)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _StableCoinPillBar(
                coins: _visibleCoins,
                selectedIndex: _coinIndex,
                onSelected: _selectCoin,
              ),
            ),
        ],
      ),
    );
  }
}

class _EarnHubBanner extends StatelessWidget {
  const _EarnHubBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        12,
        AppColors.contentInset,
        4,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.earnBannerStart,
              AppColors.earnBannerMid,
              AppColors.earnBannerEnd,
            ],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.earnHeroTitle,
                style: const TextStyle(
                  color: Color(0xFFF4F7F4),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.earnHeroBody,
                style: TextStyle(
                  color: const Color(0xFFF4F7F4).withValues(alpha: 0.88),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StableCoinPillBar extends StatelessWidget {
  const _StableCoinPillBar({
    required this.coins,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<StableCoin> coins;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const capsuleBottomGap = 10.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IgnorePointer(
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.pageWashBottom.withValues(alpha: 0),
                  AppColors.glassFillLight.withValues(alpha: 0.35),
                ],
              ),
            ),
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.22),
                    AppColors.glassFillLight,
                    AppColors.glassFillLight.withValues(alpha: 0.55),
                  ],
                  stops: const [0, 0.4, 1],
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.40)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppColors.contentInset,
                  10,
                  AppColors.contentInset,
                  bottomInset + capsuleBottomGap,
                ),
                child: LiquidGlass(
                  borderRadius: 28,
                  blur: 20,
                  shadow: false,
                  fill: AppColors.glassFillLight,
                  stroke: Colors.white.withValues(alpha: 0.50),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < coins.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          _CoinPill(
                            label: coins[i].symbol,
                            selected: i == selectedIndex,
                            onTap: () => onSelected(i),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinPill extends StatelessWidget {
  const _CoinPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.glassChipSelected : AppColors.glassChip,
      elevation: 0,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.35),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
