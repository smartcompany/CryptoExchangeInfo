import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/app_icon_experiment.dart';
import '../theme/app_colors.dart';

Future<void> showAppIconExperimentSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final supported = await AppIconExperiment.isSupported;
  if (!context.mounted) return;

  if (!supported) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.appIconUnsupported)),
    );
    return;
  }

  final current = await AppIconExperiment.current();
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appIconExperimentTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.appIconExperimentBody,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _IconOption(
                      choice: AppIconChoice.hub,
                      label: l10n.appIconHub,
                      selected: current == AppIconChoice.hub,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IconOption(
                      choice: AppIconChoice.portal,
                      label: l10n.appIconPortal,
                      selected: current == AppIconChoice.portal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.choice,
    required this.label,
    required this.selected,
  });

  final AppIconChoice choice;
  final String label;
  final bool selected;

  Future<void> _select(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await AppIconExperiment.setChoice(choice);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      final hint = (!Platform.isIOS)
          ? l10n.appIconChangedAndroid
          : l10n.appIconChanged;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hint)));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.appIconChangeFailed(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brandSoft : AppColors.chipIdle,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: selected ? null : () => _select(context),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  choice.assetPath,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: selected ? AppColors.brand : AppColors.ink,
                ),
              ),
              if (selected) ...[
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).appIconSelected,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
