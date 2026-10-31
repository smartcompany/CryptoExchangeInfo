import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/earn_product.dart';

class EarnProductCard extends StatelessWidget {
  const EarnProductCard({super.key, required this.product});

  final EarnProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    product.exchangeLabel,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.available
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    product.available ? 'Flexible USDT' : '미지원',
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
                '예상/고시 APR (Flexible)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (product.marketAprDisplay != null) ...[
                const SizedBox(height: 6),
                Text('Market APR ${product.marketAprDisplay}'),
              ],
              if (product.avgAprDisplay != null) ...[
                const SizedBox(height: 6),
                Text(
                  '평균 ${product.avgAprDisplay}'
                  '${product.prevAprDisplay != null ? ' · 직전 ${product.prevAprDisplay}' : ''}',
                ),
              ],
              if (product.minAmount != null) ...[
                const SizedBox(height: 6),
                Text('최소 ${product.minAmount} USDT'),
              ],
              if (product.tiers.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '구간별 금리',
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
                        Expanded(child: Text(tier.rangeLabel)),
                        Text(
                          tier.aprDisplay ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
            if (product.note != null && product.note!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                product.note!,
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
                        label: const Text('Earn 페이지로 이동'),
                      )
                    : TextButton.icon(
                        onPressed: () => _openEarnPage(context),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Earn 페이지로 이동'),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openEarnPage(BuildContext context) async {
    final raw = product.earnPageUrl;
    final uri = raw == null ? null : Uri.tryParse(raw);
    if (uri == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('유효한 링크가 없습니다.')),
        );
      }
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Earn 페이지를 열 수 없습니다.')),
      );
    }
  }
}
