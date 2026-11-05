import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

/// Runtime app-icon A/B experiment.
///
/// - Primary / hub: [AppIconChoice.hub] (`exora_icon_v2_08_multi_token_hub`)
/// - Alternate / portal: [AppIconChoice.portal] (`exora_icon_v2_03_coin_portal`)
enum AppIconChoice { hub, portal }

extension AppIconChoiceX on AppIconChoice {
  /// Native alternate icon name. `null` restores the primary (hub) icon.
  String? get nativeName => switch (this) {
        AppIconChoice.hub => null,
        AppIconChoice.portal => 'AppIconPortal',
      };

  String get assetPath => switch (this) {
        AppIconChoice.hub => 'assets/branding/app_icon_hub.png',
        AppIconChoice.portal => 'assets/branding/app_icon_portal.png',
      };
}

abstract final class AppIconExperiment {
  static Future<bool> get isSupported async {
    if (kIsWeb) return false;
    if (!(Platform.isIOS || Platform.isAndroid)) return false;
    try {
      return await FlutterDynamicIconPlus.supportsAlternateIcons;
    } catch (_) {
      return false;
    }
  }

  static Future<AppIconChoice> current() async {
    try {
      final name = await FlutterDynamicIconPlus.alternateIconName;
      if (name == null || name.isEmpty || name == 'DEFAULT') {
        return AppIconChoice.hub;
      }
      final normalized = name.replaceFirst(RegExp(r'^\.'), '');
      if (normalized == 'AppIconPortal') return AppIconChoice.portal;
      return AppIconChoice.hub;
    } catch (_) {
      return AppIconChoice.hub;
    }
  }

  static Future<void> setChoice(AppIconChoice choice) async {
    await FlutterDynamicIconPlus.setAlternateIconName(
      iconName: choice.nativeName,
      isSilent: true,
      // Some OEMs kill the process on icon swap; blacklist reduces crashes.
      blacklistBrands: const ['Xiaomi', 'Redmi'],
      blacklistManufactures: const ['Xiaomi'],
    );
  }
}
