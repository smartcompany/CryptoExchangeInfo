import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_labels.dart';
import '../models/opportunity.dart';
import '../services/ad_gate.dart';
import '../services/event_ai_service.dart';
import '../services/opportunity_repository.dart';
import '../services/translate_service.dart';
import '../theme/app_colors.dart';
import 'ai_summary_button.dart';
import 'event_ai_sheet.dart';

class OpportunityCard extends StatefulWidget {
  const OpportunityCard({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  State<OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<OpportunityCard> {
  var _analyzing = false;

  Opportunity get opportunity => widget.opportunity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exchangeLabel = l10n.exchangeNameFor(opportunity.exchange);
    final dateLabel = _dateLabel(l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppColors.contentInset,
        vertical: 6,
      ),
      child: Material(
        color: AppColors.card,
        elevation: 0,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => _showDetail(context),
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.line),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _TagPill(
                                  label: exchangeLabel,
                                  foreground: AppColors.brand,
                                  background: AppColors.brandSoft,
                                ),
                                _TagPill(
                                  label: l10n.opportunityTypeLabel(
                                    opportunity.type,
                                  ),
                                  foreground: AppColors.muted,
                                  background: AppColors.chipIdle,
                                ),
                                if (opportunity.status ==
                                    OpportunityStatus.endingSoon)
                                  _TagPill(
                                    label: l10n.endingSoonBadge,
                                    foreground: const Color(0xFFB42318),
                                    background: const Color(0xFFFEE4E2),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              opportunity.titleKo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _ThumbArt(type: opportunity.type),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.brand.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.card_giftcard_rounded,
                          size: 18,
                          color: AppColors.brand,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.rewardLabel(opportunity.rewardLabel),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (opportunity.eligibilityKo.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _InfoLine(
                      icon: Icons.info_outline_rounded,
                      text: opportunity.eligibilityKo,
                    ),
                  ],
                  if (dateLabel != null) ...[
                    const SizedBox(height: 6),
                    _InfoLine(
                      icon: Icons.calendar_today_outlined,
                      text: dateLabel,
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: AiSummaryButton(
                          busy: _analyzing,
                          onPressed: _analyzing ? null : _runAi,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: OfficialLinkButton(
                          onPressed: () => _openOfficial(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _dateLabel(AppLocalizations l10n) {
    final format = DateFormat('yyyy.MM.dd');
    final start = opportunity.startsAt;
    final end = opportunity.endsAt;
    final days = opportunity.daysRemaining;
    final dDay = days == null ? null : l10n.dDayLabel(days);
    if (start == null && end == null) {
      return dDay == null ? null : l10n.deadlineLabel(dDay);
    }
    final startText = start != null ? format.format(start.toLocal()) : '?';
    final endText = end != null ? format.format(end.toLocal()) : '?';
    final suffix = dDay == null ? '' : ' · $dDay';
    return l10n.periodRange(startText, endText, suffix);
  }

  Future<void> _runAi() async {
    if (_analyzing) return;
    final confirmed = await AdGate.confirmAndShowAdForAi(context);
    if (!confirmed || !mounted) return;
    final l10n = AppLocalizations.of(context);

    setState(() => _analyzing = true);
    try {
      final analysis = await EventAiService().analyzeOpportunity(opportunity);
      if (!mounted) return;
      await presentEventAiAnalysis(
        context,
        analysis: analysis,
        sourceUrl: opportunity.officialUrl,
      );
    } catch (error, stackTrace) {
      debugPrint('[OpportunityCard] AI analysis failed: $error');
      debugPrint('$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.aiFailed(error.toString()))));
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  Future<void> _showDetail(BuildContext context) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    final locale = TranslateService.normalizeLang(
      Localizations.localeOf(context).languageCode,
    );

    // Always localize for the open sheet so detail never stays stuck in Korean
    // when the list cache still has raw pilot JSON strings.
    var detail = opportunity;
    if (locale != 'ko') {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.brand),
        ),
      );
      try {
        detail = await OpportunityRepository().localize(
          opportunity,
          locale: locale,
        );
      } finally {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
      if (!context.mounted) return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.card,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  detail.titleKo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (detail.summaryKo.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    detail.summaryKo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _DetailRow(
                  label: l10n.detailReward,
                  value: detail.rewardLabel,
                ),
                _DetailRow(
                  label: l10n.detailType,
                  value: l10n.opportunityTypeLabel(detail.type),
                ),
                _DetailRow(
                  label: l10n.detailStatus,
                  value: l10n.opportunityStatusLabel(detail.status),
                ),
                if (detail.startsAt != null)
                  _DetailRow(
                    label: l10n.detailStart,
                    value: dateFormat.format(detail.startsAt!.toLocal()),
                  ),
                if (detail.endsAt != null)
                  _DetailRow(
                    label: l10n.detailEnd,
                    value: dateFormat.format(detail.endsAt!.toLocal()),
                  ),
                _DetailRow(
                  label: l10n.detailEligibility,
                  value: detail.eligibilityKo,
                ),
                if (detail.regionNoteKo != null &&
                    detail.regionNoteKo!.trim().isNotEmpty)
                  _DetailRow(
                    label: l10n.detailRegion,
                    value: detail.regionNoteKo!,
                  ),
                if (detail.tasksKo.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.detailTasks,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final task in detail.tasksKo)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('· ', style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Text(
                              task,
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                if (detail.asOf != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.detailAsOf(
                      dateFormat.format(detail.asOf!.toLocal()),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: AiSummaryButton(
                        busy: _analyzing,
                        onPressed: _analyzing
                            ? null
                            : () async {
                                Navigator.pop(sheetContext);
                                await _runAi();
                              },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: OfficialLinkButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _openOfficial(context);
                        },
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

  Future<void> _openOfficial(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri.tryParse(opportunity.officialUrl.trim());
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.invalidLink)));
      }
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cannotOpenLink)));
    }
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThumbArt extends StatelessWidget {
  const _ThumbArt({required this.type});

  final OpportunityType type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      OpportunityType.event => Icons.campaign_outlined,
      OpportunityType.earnBoost => Icons.savings_outlined,
      OpportunityType.tradingContest => Icons.emoji_events_outlined,
      OpportunityType.dualChallenge => Icons.swap_vert_circle_outlined,
      OpportunityType.convertChallenge => Icons.currency_exchange,
      OpportunityType.listing => Icons.rocket_launch_outlined,
      OpportunityType.feePromo => Icons.percent,
      OpportunityType.depositBonus => Icons.account_balance_wallet_outlined,
      OpportunityType.other => Icons.campaign_outlined,
    };

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.bannerEnd, AppColors.brandDark],
        ),
      ),
      child: Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 32),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
