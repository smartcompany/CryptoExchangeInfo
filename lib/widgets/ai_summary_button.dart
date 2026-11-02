import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Premium primary CTA for AI event summary.
class AiSummaryButton extends StatelessWidget {
  const AiSummaryButton({
    super.key,
    required this.onPressed,
    this.busy = false,
    this.expanded = true,
    this.height = 48,
  });

  final VoidCallback? onPressed;
  final bool busy;
  final bool expanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = onPressed != null && !busy;
    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: enabled ? AppColors.brand : const Color(0xFFB5A99F),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.brand.withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (busy)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: Colors.white.withValues(alpha: enabled ? 0.95 : 0.75),
                  ),
                const SizedBox(width: 8),
                Text(
                  busy ? l10n.aiAnalyzing : l10n.aiSummary,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: enabled ? 1 : 0.85),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!expanded) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}

/// Quiet secondary action next to [AiSummaryButton].
class OfficialLinkButton extends StatelessWidget {
  const OfficialLinkButton({
    super.key,
    required this.onPressed,
    this.label,
    this.height = 48,
  });

  final VoidCallback? onPressed;
  final String? label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.card,
          side: const BorderSide(color: AppColors.line),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          label ?? AppLocalizations.of(context).viewOriginal,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
