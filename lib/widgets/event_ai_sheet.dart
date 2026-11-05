import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/event_ai_service.dart';
import '../services/exchange_referral.dart';
import '../theme/app_colors.dart';
import 'ai_summary_button.dart';

/// Presents AI analysis as a fullscreen modal (iOS-style present).
Future<void> presentEventAiAnalysis(
  BuildContext context, {
  required EventAiAnalysis analysis,
  String? sourceUrl,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) =>
          EventAiAnalysisPage(analysis: analysis, sourceUrl: sourceUrl),
    ),
  );
}

@Deprecated('Use presentEventAiAnalysis')
Future<void> showEventAiSheet(
  BuildContext context, {
  required EventAiAnalysis analysis,
  String? sourceUrl,
}) {
  return presentEventAiAnalysis(
    context,
    analysis: analysis,
    sourceUrl: sourceUrl,
  );
}

class EventAiAnalysisPage extends StatelessWidget {
  const EventAiAnalysisPage({
    super.key,
    required this.analysis,
    this.sourceUrl,
  });

  final EventAiAnalysis analysis;
  final String? sourceUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.page,
      appBar: AppBar(
        title: Text(l10n.aiEasyExplainTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    l10n.aiDisclaimer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (analysis.summary.isNotEmpty) ...[
                    Text(analysis.summary, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 20),
                  ],
                  if (analysis.reward.isNotEmpty)
                    _Section(
                      label: l10n.aiSectionReward,
                      body: analysis.reward,
                    ),
                  if (analysis.period.isNotEmpty)
                    _Section(
                      label: l10n.aiSectionPeriod,
                      body: analysis.period,
                    ),
                  if (analysis.conditions.isNotEmpty)
                    _BulletSection(
                      label: l10n.aiSectionConditions,
                      items: analysis.conditions,
                    ),
                  if (analysis.cautions.isNotEmpty)
                    _BulletSection(
                      label: l10n.aiSectionCautions,
                      items: analysis.cautions,
                    ),
                  if (_hasSourceUrl) ...[
                    const SizedBox(height: 8),
                    OfficialLinkButton(
                      onPressed: () => _openSource(context),
                      label: l10n.aiGoToSource,
                    ),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasSourceUrl {
    final url = sourceUrl?.trim() ?? '';
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _openSource(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final parsed = Uri.tryParse(sourceUrl!.trim());
    if (parsed == null) return;
    final uri = ExchangeReferral.apply(parsed);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cannotOpenLink)));
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.brand),
          ),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.brand),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('· ', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
