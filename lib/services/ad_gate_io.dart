import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_lib/share_lib.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Mobile ads via flutter_share_lib [AdService].
abstract final class AdGate {
  static var _initialized = false;

  static Future<void> initialize(String apiBaseUrl) async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      AdService.shared.setBaseUrl(apiBaseUrl);
      final loaded = await AdService.shared.loadSettings();
      debugPrint(
        '[AdGate] settings loaded=$loaded '
        'rewarded=${AdService.shared.rewardedAdId} '
        'initial=${AdService.shared.initialAdId}',
      );
      if (loaded) {
        unawaited(AdService.shared.preloadAd());
      }
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('[AdGate] initialize error: $error');
      debugPrint('$stackTrace');
    }
  }

  /// Asks whether to watch an ad; on confirm shows the ad then returns true.
  /// Cancel returns false. Ad failures still return true so AI can proceed.
  static Future<bool> confirmAndShowAdForAi(BuildContext context) async {
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.adConfirmTitle),
          content: Text(l10n.adConfirmMessage),
          // When English labels wrap vertically, keep the primary action on top
          // and Cancel underneath (horizontal layout stays Cancel | Continue).
          actionsOverflowDirection: VerticalDirection.up,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.adConfirmContinue),
            ),
          ],
        );
      },
    );

    if (proceed != true) {
      debugPrint('[AdGate] user cancelled AI ad confirm');
      return false;
    }
    if (!context.mounted) return false;

    await showAdForAi();
    return true;
  }

  /// Shows configured ad; failures never block the AI flow (Tabata pattern).
  static Future<void> showAdForAi() async {
    final completer = Completer<void>();
    try {
      await AdService.shared.showAd(
        onAdDismissed: () {
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToShow: () {
          if (!completer.isCompleted) completer.complete();
        },
        onUserEarnedReward: (_) {},
      );
      await completer.future.timeout(const Duration(seconds: 90));
    } catch (error) {
      debugPrint('[AdGate] showAd error: $error');
      if (!completer.isCompleted) completer.complete();
    }
  }
}
