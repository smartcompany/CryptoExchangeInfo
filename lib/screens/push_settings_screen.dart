import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/push_notification_service.dart';
import '../services/push_preferences.dart';
import '../services/push_topics.dart';
import '../theme/app_colors.dart';

class PushSettingsScreen extends StatefulWidget {
  const PushSettingsScreen({super.key});

  @override
  State<PushSettingsScreen> createState() => _PushSettingsScreenState();
}

class _PushSettingsScreenState extends State<PushSettingsScreen> {
  final _push = PushNotificationService.instance;
  var _busy = false;

  PushPreferences get _prefs => _push.prefs;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final masterOn = _prefs.masterEnabled;

    return Scaffold(
      backgroundColor: AppColors.page,
      appBar: AppBar(title: Text(l10n.pushSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(
            l10n.pushSettingsIntro,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 16),
          _card(
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Text(
                l10n.pushMasterTitle,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              value: masterOn,
              activeThumbColor: AppColors.brand,
              onChanged: _busy
                  ? null
                  : (v) => _run(() async {
                      final ok = await _push.setMasterEnabled(v);
                      if (!mounted) return;
                      if (!ok && v) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.pushPermissionDenied),
                          ),
                        );
                      }
                      setState(() {});
                    }),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.pushCategoriesSection,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          _card(
            child: Column(
              children: [
                for (final cat in PushCategory.values)
                  // Material (not adaptive): iOS green stays vivid when disabled+on.
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      _categoryTitle(l10n, cat),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(_categorySubtitle(l10n, cat)),
                    value: _prefs.categoryEnabled(cat),
                    activeThumbColor: masterOn ? AppColors.brand : AppColors.muted,
                    activeTrackColor: masterOn
                        ? AppColors.brand.withValues(alpha: 0.45)
                        : AppColors.line,
                    inactiveThumbColor: AppColors.card,
                    inactiveTrackColor: AppColors.chipIdle,
                    onChanged: !masterOn || _busy
                        ? null
                        : (v) => _run(() async {
                            await _push.setCategory(cat, v);
                            if (mounted) setState(() {});
                          }),
                  ),
              ],
            ),
          ),
          if (_busy) ...[
            const SizedBox(height: 16),
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    // Material (not DecoratedBox) so ListTile ink/splash paint correctly.
    return Material(
      color: AppColors.glassFill,
      elevation: 2,
      shadowColor: AppColors.brandDark.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.glassStroke),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  String _categoryTitle(AppLocalizations l10n, PushCategory c) => switch (c) {
    PushCategory.contest => l10n.pushCatContest,
    PushCategory.earn => l10n.pushCatEarn,
    PushCategory.listing => l10n.pushCatListing,
    PushCategory.deposit => l10n.pushCatDeposit,
    PushCategory.other => l10n.pushCatOther,
  };

  String _categorySubtitle(AppLocalizations l10n, PushCategory c) =>
      switch (c) {
        PushCategory.contest => l10n.pushCatContestDesc,
        PushCategory.earn => l10n.pushCatEarnDesc,
        PushCategory.listing => l10n.pushCatListingDesc,
        PushCategory.deposit => l10n.pushCatDepositDesc,
        PushCategory.other => l10n.pushCatOtherDesc,
      };
}
