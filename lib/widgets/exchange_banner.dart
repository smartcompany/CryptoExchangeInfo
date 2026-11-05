import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_labels.dart';
import '../services/exchange_events_service.dart';
import '../services/exchange_referral.dart';
import '../theme/app_colors.dart';

/// Room for the bottom-right glyph row so copy does not overlap it.
const double _bannerCopyRightInset = 152;

String? _bannerDestination(Exchange exchange) {
  final signup = ExchangeReferral.signupLink(exchange.name);
  if (signup != null && signup.trim().isNotEmpty) return signup.trim();
  return switch (exchange) {
    Exchange.upbit => 'https://upbit.com',
    Exchange.bithumb => 'https://www.bithumb.com',
    _ => null,
  };
}

Future<void> _openBannerDestination(
  BuildContext context,
  Exchange exchange,
) async {
  final l10n = AppLocalizations.of(context);
  final parsed = Uri.tryParse(_bannerDestination(exchange) ?? '');
  if (parsed == null ||
      (parsed.scheme != 'http' && parsed.scheme != 'https') ||
      parsed.host.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.invalidLink)));
    }
    return;
  }
  final ok = await launchUrl(parsed, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.cannotOpenLink)));
  }
}

class ExchangeBanner extends StatelessWidget {
  const ExchangeBanner({super.key, required this.exchange});

  final Exchange exchange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        12,
        AppColors.contentInset,
        4,
      ),
      child: switch (exchange) {
        Exchange.binance => const _BinanceBanner(),
        Exchange.okx => const _OkxBanner(),
        Exchange.bybit => const _BybitBanner(),
        Exchange.gate => const _GateBanner(),
        Exchange.mexc => const _MexcBanner(),
        Exchange.bitget => const _BitgetBanner(),
        Exchange.kucoin => const _KucoinBanner(),
        Exchange.coinbase => const _CoinbaseBanner(),
        Exchange.upbit => const _UpbitBanner(),
        Exchange.bithumb => const _BithumbBanner(),
      },
    );
  }
}

class _BannerShell extends StatelessWidget {
  const _BannerShell({
    required this.exchange,
    required this.gradient,
    required this.child,
    this.border,
    this.signupForeground,
    this.signupBackground,
    this.signupBorder,
  });

  final Exchange exchange;
  final Gradient gradient;
  final Widget child;
  final BoxBorder? border;
  final Color? signupForeground;
  final Color? signupBackground;
  final Color? signupBorder;

  @override
  Widget build(BuildContext context) {
    final hasSignup = ExchangeReferral.signupLink(exchange.name) != null;
    final canOpen = _bannerDestination(exchange) != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canOpen ? () => _openBannerDestination(context, exchange) : null,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: gradient,
            border: border,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 132),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  child,
                  if (hasSignup)
                    Positioned(
                      right: 14,
                      top: 14,
                      child: _BannerSignupCta(
                        exchange,
                        foreground: signupForeground,
                        background: signupBackground,
                        border: signupBorder,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerSignupCta extends StatelessWidget {
  const _BannerSignupCta(
    this.exchange, {
    this.foreground,
    this.background,
    this.border,
  });

  final Exchange exchange;
  final Color? foreground;
  final Color? background;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    if (ExchangeReferral.signupLink(exchange.name) == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final fg = foreground ?? Colors.white;
    final bg = background ?? Colors.white.withValues(alpha: 0.16);
    final edge = border ?? Colors.white.withValues(alpha: 0.38);
    return FilledButton(
      onPressed: () => _openBannerDestination(context, exchange),
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        side: BorderSide(color: edge),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        l10n.bannerSignUp,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, {this.fg = Colors.white, this.bg});

  final String label;
  final Color fg;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg ?? Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _GlyphRow extends StatelessWidget {
  const _GlyphRow(this.icons, {this.color = Colors.white});

  final List<IconData> icons;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < icons.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icons[i], color: color, size: 20),
          ),
        ],
      ],
    );
  }
}

/// Bybit — dark charcoal + amber, trading-floor feel
class _BybitBanner extends StatelessWidget {
  const _BybitBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.bybit,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1C1C1E), Color(0xFF2A2118)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -16,
            child: Icon(
              Icons.bolt_rounded,
              size: 140,
              color: const Color(0xFFF7A600).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.candlestick_chart_outlined,
              Icons.speed_rounded,
              Icons.emoji_events_outlined,
            ], color: const Color(0xFFF7A600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.bybit),
                  fg: const Color(0xFF1C1C1E),
                  bg: const Color(0xFFF7A600),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerBybitTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerBybitBody,
                  style: const TextStyle(
                    color: Color(0xFFD6D3D1),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Binance — espresso stone hero (quiet boutique)
class _BinanceBanner extends StatelessWidget {
  const _BinanceBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.binance,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.bannerStart,
          AppColors.bannerMid,
          AppColors.bannerEnd,
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -28,
            child: Transform.rotate(
              angle: 0.4,
              child: Icon(
                Icons.hexagon_outlined,
                size: 150,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.card_giftcard_rounded,
              Icons.savings_outlined,
              Icons.currency_bitcoin,
            ], color: AppColors.bannerMist),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.binance),
                  fg: AppColors.ink,
                  bg: AppColors.bannerMist,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerBinanceTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerBinanceBody,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// OKX — minimal black / electric blue
class _OkxBanner extends StatelessWidget {
  const _OkxBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.okx,
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF0A0A0A), Color(0xFF161B22)],
      ),
      border: Border.all(
        color: const Color(0xFF2F81F7).withValues(alpha: 0.35),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 110,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF2F81F7).withValues(alpha: 0.22),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow([
              Icons.grid_view_rounded,
              Icons.show_chart,
              Icons.layers_outlined,
            ], color: Color(0xFF79B8FF)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.okx),
                  fg: Colors.white,
                  bg: const Color(0xFF2F81F7),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerOkxTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerOkxBody,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Upbit — deep Korean blue
class _UpbitBanner extends StatelessWidget {
  const _UpbitBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.upbit,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF093687), Color(0xFF0B4DB8)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: 10,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 18,
                ),
              ),
            ),
          ),
          const Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow([
              Icons.notifications_active_outlined,
              Icons.article_outlined,
              Icons.flag_outlined,
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(l10n.exchangeName(Exchange.upbit)),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerUpbitTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerUpbitBody,
                  style: const TextStyle(
                    color: Color(0xFFD6E4FF),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bithumb — warm coral / orange
class _BithumbBanner extends StatelessWidget {
  const _BithumbBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.bithumb,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE85D04), Color(0xFFC1121F)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 8,
            top: -20,
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 130,
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          const Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow([
              Icons.campaign_outlined,
              Icons.card_giftcard_rounded,
              Icons.favorite_border,
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.bithumb),
                  fg: const Color(0xFFC1121F),
                  bg: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerBithumbTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerBithumbBody,
                  style: const TextStyle(
                    color: Color(0xFFFFE5D9),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bitget — neon teal on deep navy
class _BitgetBanner extends StatelessWidget {
  const _BitgetBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.bitget,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF041E26), Color(0xFF0A3A3A)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -40,
            child: Icon(
              Icons.auto_graph_rounded,
              size: 150,
              color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.swipe_rounded,
              Icons.trending_up,
              Icons.workspace_premium_outlined,
            ], color: const Color(0xFF00F0FF)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.bitget),
                  fg: const Color(0xFF041E26),
                  bg: const Color(0xFF00F0FF),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerBitgetTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerBitgetBody,
                  style: const TextStyle(
                    color: Color(0xFF9DE8ED),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GateBanner extends StatelessWidget {
  const _GateBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.gate,
      signupForeground: Colors.white,
      signupBackground: const Color(0xFF063D31),
      signupBorder: const Color(0xFF063D31),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF17E6A1), Color(0xFF0B8F6B)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.emoji_events_outlined,
              Icons.campaign_outlined,
              Icons.stacked_line_chart,
            ], color: const Color(0xFF063D31)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.gate),
                  fg: const Color(0xFF063D31),
                  bg: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerGateTitle,
                  style: const TextStyle(
                    color: Color(0xFF063D31),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerGateBody,
                  style: const TextStyle(
                    color: Color(0xFF0A4F40),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MexcBanner extends StatelessWidget {
  const _MexcBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.mexc,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1B1F2A), Color(0xFF2B3347)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.bolt_rounded,
              Icons.rocket_launch_outlined,
              Icons.insights_outlined,
            ], color: const Color(0xFF1EE3A0)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.mexc),
                  fg: const Color(0xFF1B1F2A),
                  bg: const Color(0xFF1EE3A0),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerMexcTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerMexcBody,
                  style: const TextStyle(color: Color(0xFFB7C0D4), fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KucoinBanner extends StatelessWidget {
  const _KucoinBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.kucoin,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF23AF91), Color(0xFF147A66)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.savings_outlined,
              Icons.new_releases_outlined,
              Icons.public,
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.kucoin),
                  fg: Colors.white,
                  bg: const Color(0xFF0E5A4B),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerKucoinTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerKucoinBody,
                  style: const TextStyle(color: Color(0xFFD7FFF4), fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinbaseBanner extends StatelessWidget {
  const _CoinbaseBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _BannerShell(
      exchange: Exchange.coinbase,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0052FF), Color(0xFF0036B3)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 14,
            bottom: 16,
            child: _GlyphRow(const [
              Icons.shield_outlined,
              Icons.notifications_active_outlined,
              Icons.schedule,
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, _bannerCopyRightInset, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(
                  l10n.exchangeName(Exchange.coinbase),
                  fg: const Color(0xFF0052FF),
                  bg: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.bannerCoinbaseTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.bannerCoinbaseBody,
                  style: const TextStyle(color: Color(0xFFD6E4FF), fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
