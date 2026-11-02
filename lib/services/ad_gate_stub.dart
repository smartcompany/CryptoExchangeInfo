import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Web / non-IO stub: ads are skipped so AI flow can continue.
abstract final class AdGate {
  static Future<void> initialize(String apiBaseUrl) async {
    debugPrint('[AdGate] stub initialize (no mobile ads)');
  }

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
      debugPrint('[AdGate] stub user cancelled AI ad confirm');
      return false;
    }
    await showAdForAi();
    return true;
  }

  static Future<void> showAdForAi() async {
    debugPrint('[AdGate] stub showAd — skipping');
  }
}
