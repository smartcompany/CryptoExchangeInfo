import 'package:flutter/material.dart';

import '../services/exchange_events_service.dart';
import '../theme/app_colors.dart';

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
        Exchange.bybit => const _BybitBanner(),
        Exchange.binance => const _BinanceBanner(),
        Exchange.okx => const _OkxBanner(),
        Exchange.upbit => const _UpbitBanner(),
        Exchange.bithumb => const _BithumbBanner(),
        Exchange.bitget => const _BitgetBanner(),
      },
    );
  }
}

class _BannerShell extends StatelessWidget {
  const _BannerShell({
    required this.gradient,
    required this.child,
    this.border,
  });

  final Gradient gradient;
  final Widget child;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        border: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
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
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
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
    return _BannerShell(
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
            right: 16,
            bottom: 16,
            child: _GlyphRow(
              const [
                Icons.candlestick_chart_outlined,
                Icons.speed_rounded,
                Icons.emoji_events_outlined,
              ],
              color: const Color(0xFFF7A600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag('바이비트', fg: Color(0xFF1C1C1E), bg: Color(0xFFF7A600)),
                SizedBox(height: 12),
                Text(
                  '트레이딩 캠페인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'WSOT·거래 대회와 보상 이벤트를 한눈에',
                  style: TextStyle(color: Color(0xFFD6D3D1), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Binance — signature yellow / near-black
class _BinanceBanner extends StatelessWidget {
  const _BinanceBanner();

  @override
  Widget build(BuildContext context) {
    return _BannerShell(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF0B90B), Color(0xFFC99400)],
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
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _GlyphRow(
              const [
                Icons.card_giftcard_rounded,
                Icons.savings_outlined,
                Icons.currency_bitcoin,
              ],
              color: const Color(0xFF1E2026),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag('바이낸스', fg: Color(0xFFF0B90B), bg: Color(0xFF1E2026)),
                SizedBox(height: 12),
                Text(
                  '글로벌 이벤트 허브',
                  style: TextStyle(
                    color: Color(0xFF1E2026),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Earn 부스트·거래 토너먼트·에어드롭까지',
                  style: TextStyle(
                    color: Color(0xFF3D2E00),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
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
    return _BannerShell(
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF0A0A0A), Color(0xFF161B22)],
      ),
      border: Border.all(color: const Color(0xFF2F81F7).withValues(alpha: 0.35)),
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
            right: 18,
            bottom: 18,
            child: _GlyphRow(
              [
                Icons.grid_view_rounded,
                Icons.show_chart,
                Icons.layers_outlined,
              ],
              color: Color(0xFF79B8FF),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag('OKX', fg: Colors.white, bg: Color(0xFF2F81F7)),
                SizedBox(height: 12),
                Text(
                  '심플한 기회 보드',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '캠페인·리워드를 군더더기 없이',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
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
    return _BannerShell(
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
            right: 18,
            bottom: 16,
            child: _GlyphRow(
              [
                Icons.notifications_active_outlined,
                Icons.article_outlined,
                Icons.flag_outlined,
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag('업비트'),
                SizedBox(height: 12),
                Text(
                  '국내 공지·이벤트',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '상장·이벤트 소식을 빠르게 확인하세요',
                  style: TextStyle(color: Color(0xFFD6E4FF), fontSize: 13),
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
    return _BannerShell(
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
            right: 16,
            bottom: 16,
            child: _GlyphRow(
              [
                Icons.campaign_outlined,
                Icons.card_giftcard_rounded,
                Icons.favorite_border,
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag('빗썸', fg: Color(0xFFC1121F), bg: Colors.white),
                SizedBox(height: 12),
                Text(
                  '핫한 프로모션',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '이벤트·공지를 따뜻하게 모아봤어요',
                  style: TextStyle(color: Color(0xFFFFE5D9), fontSize: 13),
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
    return _BannerShell(
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
            right: 16,
            bottom: 16,
            child: _GlyphRow(
              const [
                Icons.swipe_rounded,
                Icons.trending_up,
                Icons.workspace_premium_outlined,
              ],
              color: const Color(0xFF00F0FF),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 120, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag('Bitget', fg: Color(0xFF041E26), bg: Color(0xFF00F0FF)),
                SizedBox(height: 12),
                Text(
                  '카피·이벤트 존',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '리워드와 캠페인을 네온처럼 선명하게',
                  style: TextStyle(color: Color(0xFF9DE8ED), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
