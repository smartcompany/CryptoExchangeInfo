import 'package:flutter/material.dart';

/// Espresso Stone — boutique warm stone + espresso accent,
/// with liquid-glass translucency tokens for iOS-like surfaces.
abstract final class AppColors {
  static const brand = Color(0xFF3B2F2A);
  static const brandDark = Color(0xFF2A211C);
  static const brandSoft = Color(0xFFEDE6DF);
  static const page = Color(0xFFF3EFEA);
  static const card = Color(0xFFFFFCF9);
  static const ink = Color(0xFF2A211C);
  static const muted = Color(0xFF7A6F66);
  static const line = Color(0xFFE4DCD4);
  static const chipIdle = Color(0xFFECE5DE);

  /// Hero / banner espresso wash (contests / exchange).
  static const bannerStart = Color(0xFF2A211C);
  static const bannerMid = Color(0xFF3B2F2A);
  static const bannerEnd = Color(0xFF53443B);
  static const bannerMist = Color(0xFFE8D9C8);

  /// Stable Coin Earn hub — moss stone (distinct from espresso contests).
  static const earnBannerStart = Color(0xFF24352C);
  static const earnBannerMid = Color(0xFF355244);
  static const earnBannerEnd = Color(0xFF4E6B5A);

  /// Liquid glass fills (use with [BackdropFilter]).
  static const glassFill = Color(0xCCFFFCF9); // ~80% cream
  static const glassFillStrong = Color(0xE6FFFCF9);
  /// Bottom tab / floating chrome — see-through frosting.
  static const glassFillLight = Color(0x59FFFCF9); // ~35% cream
  static const glassStroke = Color(0x66FFFFFF);
  static const glassStrokeDark = Color(0x33E4DCD4);
  static const glassChip = Color(0x55FFFFFF);
  static const glassChipSelected = Color(0xE63B2F2A);

  /// Soft page wash (top → bottom).
  static const pageWashTop = Color(0xFFF7F3EE);
  static const pageWashBottom = Color(0xFFEDE6DF);

  /// Shared horizontal inset for banner, filters, and list cards.
  static const double contentInset = 16;

  /// Space reserved so list content clears the floating exchange bar.
  static const double exchangeBarClearance = 88;
}
