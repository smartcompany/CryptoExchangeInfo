import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Frosted translucent surface (iOS liquid-glass style).
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 28,
    this.padding,
    this.fill = AppColors.glassFill,
    this.stroke = AppColors.glassStroke,
    this.strokeWidth = 1,
    this.shadow = true,
  });

  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final Color fill;
  final Color stroke;
  final double strokeWidth;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return Container(
      decoration: shadow
          ? BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandDark.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.45),
                  blurRadius: 1,
                  offset: const Offset(0, -0.5),
                ),
              ],
            )
          : null,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(
                    alpha: (fill.a * 0.55).clamp(0.12, 0.45),
                  ),
                  fill,
                  fill.withValues(alpha: (fill.a * 0.7).clamp(0.08, 0.55)),
                ],
                stops: const [0, 0.45, 1],
              ),
              border: Border.all(color: stroke, width: strokeWidth),
            ),
            child: padding == null
                ? child
                : Padding(padding: padding!, child: child),
          ),
        ),
      ),
    );
  }
}

/// Full-bleed frosted bar (AppBar / bottom strip) without rounded capsule.
class LiquidGlassBar extends StatelessWidget {
  const LiquidGlassBar({
    super.key,
    required this.child,
    this.blur = 36,
    this.fill = AppColors.glassFillLight,
  });

  final Widget child;
  final double blur;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: ColoredBox(
          color: fill,
          child: child,
        ),
      ),
    );
  }
}
