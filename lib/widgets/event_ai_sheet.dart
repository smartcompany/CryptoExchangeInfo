import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/event_ai_service.dart';
import '../services/exchange_referral.dart';
import '../theme/app_colors.dart';

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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                    _AiMarkdownBody(
                      data: analysis.summary,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (analysis.reward.isNotEmpty)
                    _Section(
                      icon: '🎁',
                      label: l10n.aiSectionReward,
                      body: analysis.reward,
                    ),
                  if (analysis.period.isNotEmpty)
                    _Section(
                      icon: '📅',
                      label: l10n.aiSectionPeriod,
                      body: analysis.period,
                    ),
                  if (analysis.conditions.isNotEmpty)
                    _BulletSection(
                      icon: '✅',
                      label: l10n.aiSectionConditions,
                      items: analysis.conditions,
                    ),
                  if (analysis.cautions.isNotEmpty)
                    _BulletSection(
                      icon: '⚠️',
                      label: l10n.aiSectionCautions,
                      items: analysis.cautions,
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  backgroundColor: AppColors.card,
                  side: const BorderSide(color: AppColors.line),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  l10n.aiClose,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            if (_hasSourceUrl) ...[
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => _openSource(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    l10n.aiGoToSource,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
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

class _AiMarkdownBody extends StatelessWidget {
  const _AiMarkdownBody({required this.data, this.style});

  final String data;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyMedium;
    final mdStyle = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: base?.copyWith(height: 1.45),
      strong: base?.copyWith(fontWeight: FontWeight.w800, height: 1.45),
      listBullet: base,
      pPadding: const EdgeInsets.only(bottom: 10),
      blockSpacing: 8,
    );
    return MarkdownBody(
      data: data,
      selectable: true,
      softLineBreak: true,
      styleSheet: mdStyle,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.body,
    this.icon,
  });

  final String label;
  final String body;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon == null ? label : '$icon $label',
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.brand),
          ),
          const SizedBox(height: 6),
          _AiMarkdownBody(data: body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.label,
    required this.items,
    this.icon,
  });

  final String label;
  final List<String> items;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon == null ? label : '$icon $label',
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.brand),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('· ', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: _AiMarkdownBody(
                      data: item,
                      style: theme.textTheme.bodyMedium,
                    ),
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
