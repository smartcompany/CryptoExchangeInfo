import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_labels.dart';
import '../models/earn_product.dart';
import '../services/exchange_referral.dart';

class EarnProductCard extends StatelessWidget {
  const EarnProductCard({super.key, required this.product});

  final EarnProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final note = _localizedNote(l10n, product.note);
    final apr = product.aprDisplay ?? '-';
    final canOpenEarnPage = product.earnPageUrl != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.exchangeNameFor(product.exchange),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: product.available
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    product.available
                        ? l10n.earnFlexibleBadge
                        : l10n.earnUnsupported,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: product.available
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (product.available) ...[
              Text(
                apr,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                l10n.earnAprLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (product.marketAprDisplay != null) ...[
                const SizedBox(height: 6),
                Text(l10n.earnMarketApr(product.marketAprDisplay!)),
              ],
              if (product.avgAprDisplay != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.earnAvgApr(product.avgAprDisplay!) +
                      (product.prevAprDisplay != null
                          ? l10n.earnPrevApr(product.prevAprDisplay!)
                          : ''),
                ),
              ],
              if (product.minAmount != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.earnMinAmount(product.minAmount!, product.coin),
                ),
              ],
              if (product.tiers.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.earnTierRates,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                for (final tier in product.tiers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(tier.rangeLabel(product.coin)),
                        ),
                        Text(
                          tier.aprDisplay ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
            if (note != null && note.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                note,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
            if (canOpenEarnPage) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: product.available
                    ? FilledButton.tonalIcon(
                        onPressed: () => _openEarnPage(context),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text(l10n.earnOpenPage),
                      )
                    : TextButton.icon(
                        onPressed: () => _openEarnPage(context),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text(l10n.earnOpenPage),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Maps note keys from [EarnService] to localized text; raw notes pass through.
  static String? _localizedNote(AppLocalizations l10n, String? note) {
    return switch (note) {
      'unavailable_bitget' => l10n.earnUnavailableBitget,
      'unavailable_upbit' => l10n.earnUnavailableUpbit,
      'unavailable_bithumb' => l10n.earnUnavailableBithumb,
      'tier_note' => l10n.earnTierNote,
      _ => note,
    };
  }

  Future<void> _openEarnPage(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final raw = product.earnPageUrl;
    final parsed = raw == null ? null : Uri.tryParse(raw);
    if (parsed == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.invalidLink)));
      }
      return;
    }
    final uri = ExchangeReferral.apply(parsed);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cannotOpenEarnPage)));
    }
  }
}
