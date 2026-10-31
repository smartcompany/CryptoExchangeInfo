import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/opportunity.dart';
import '../services/exchange_events_service.dart';
import '../theme/app_colors.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    final exchangeLabel = _exchangeLabel(opportunity.exchange);
    final dateLabel = _dateLabel();

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
                                  label: opportunity.type.labelKo,
                                  foreground: AppColors.muted,
                                  background: AppColors.chipIdle,
                                ),
                                if (opportunity.status ==
                                    OpportunityStatus.endingSoon)
                                  const _TagPill(
                                    label: '곧 마감',
                                    foreground: Color(0xFFB42318),
                                    background: Color(0xFFFEE4E2),
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
                            '보상 ${opportunity.rewardLabel}',
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _openOfficial(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text(
                        '원문 보기  ›',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _dateLabel() {
    final format = DateFormat('yyyy.MM.dd');
    final start = opportunity.startsAt;
    final end = opportunity.endsAt;
    if (start == null && end == null) {
      final dDay = opportunity.dDayLabel;
      return dDay == null ? null : '마감 $dDay';
    }
    final startText = start != null ? format.format(start.toLocal()) : '?';
    final endText = end != null ? format.format(end.toLocal()) : '?';
    final dDay = opportunity.dDayLabel;
    final suffix = dDay == null ? '' : ' · $dDay';
    return '기간 $startText ~ $endText$suffix';
  }

  String _exchangeLabel(String exchange) {
    for (final value in Exchange.values) {
      if (value.name == exchange) return value.labelKo;
    }
    return exchange;
  }

  Future<void> _showDetail(BuildContext context) async {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.card,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  opportunity.titleKo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (opportunity.summaryKo.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    opportunity.summaryKo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _DetailRow(label: '보상', value: opportunity.rewardLabel),
                _DetailRow(label: '유형', value: opportunity.type.labelKo),
                _DetailRow(label: '상태', value: opportunity.status.labelKo),
                if (opportunity.startsAt != null)
                  _DetailRow(
                    label: '시작',
                    value: dateFormat.format(opportunity.startsAt!.toLocal()),
                  ),
                if (opportunity.endsAt != null)
                  _DetailRow(
                    label: '마감',
                    value: dateFormat.format(opportunity.endsAt!.toLocal()),
                  ),
                _DetailRow(label: '자격', value: opportunity.eligibilityKo),
                if (opportunity.regionNoteKo != null &&
                    opportunity.regionNoteKo!.trim().isNotEmpty)
                  _DetailRow(label: '지역', value: opportunity.regionNoteKo!),
                if (opportunity.tasksKo.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '참여 단계',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final task in opportunity.tasksKo)
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
                if (opportunity.asOf != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    '기준 ${dateFormat.format(opportunity.asOf!.toLocal())} · 투자 권유 아님 · 조건은 원문 우선',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _openOfficial(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    '원문 보기  ›',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openOfficial(BuildContext context) async {
    final uri = Uri.tryParse(opportunity.officialUrl.trim());
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
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
        const SnackBar(content: Text('링크를 열 수 없습니다.')),
      );
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
          colors: [Color(0xFF128C85), Color(0xFF0A4F4B)],
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
            width: 48,
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
