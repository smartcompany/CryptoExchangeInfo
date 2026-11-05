import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_labels.dart';
import '../models/exchange_event.dart';
import '../services/ad_gate.dart';
import '../services/event_ai_service.dart';
import '../services/exchange_events_service.dart';
import '../services/exchange_referral.dart';
import '../theme/app_colors.dart';
import 'ai_summary_button.dart';
import 'event_ai_sheet.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.service,
    this.exchange,
  });

  final ExchangeEvent event;
  final ExchangeEventsService service;
  final Exchange? exchange;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  static final _dateFormat = DateFormat('yyyy.MM.dd');

  String? _imageUrl;
  var _imageFailed = false;
  var _imageRequestInFlight = false;
  var _analyzing = false;

  ExchangeEvent get event => widget.event;

  @override
  void initState() {
    super.initState();
    _bootstrapImage();
  }

  @override
  void didUpdateWidget(covariant EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.url != event.url ||
        oldWidget.event.imageUrl != event.imageUrl) {
      _bootstrapImage();
    }
  }

  void _bootstrapImage() {
    _imageFailed = false;
    _imageRequestInFlight = false;
    final cached = widget.service.displayImageUrl(event.imageUrl);
    _imageUrl = cached;
    if (_imageUrl == null && event.url.trim().isNotEmpty) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (_imageRequestInFlight || event.url.trim().isEmpty) return;
    Exchange? resolved = widget.exchange;
    if (resolved == null) {
      for (final value in Exchange.values) {
        if (value.name == event.exchange) {
          resolved = value;
          break;
        }
      }
    }
    if (resolved == null) {
      if (mounted) setState(() => _imageFailed = true);
      return;
    }

    _imageRequestInFlight = true;
    try {
      final imageUrl = await widget.service.fetchEventImage(
        exchange: resolved,
        url: event.url,
      );
      if (!mounted) return;
      setState(() {
        _imageUrl = imageUrl;
        _imageFailed = imageUrl == null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _imageFailed = true);
    } finally {
      _imageRequestInFlight = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final period = _periodLabel(l10n);
    // Hide the media slot entirely when missing / 403 / failed — empty gray
    // blocks look worse than a text-only card.
    final showThumb = _imageUrl != null && !_imageFailed;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppColors.contentInset,
        vertical: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showThumb)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  gaplessPlayback: true,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted || _imageFailed) return;
                      setState(() {
                        _imageFailed = true;
                        _imageUrl = null;
                      });
                    });
                    return const SizedBox.shrink();
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _TagPill(
                        label: widget.exchange != null
                            ? l10n.exchangeName(widget.exchange!)
                            : l10n.typeEvent,
                        foreground: AppColors.brand,
                        background: AppColors.brandSoft,
                      ),
                      for (final tag in event.displayTags.take(2))
                        _TagPill(
                          label: l10n.eventTag(tag),
                          foreground: AppColors.muted,
                          background: AppColors.chipIdle,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(event.displayTitle, style: theme.textTheme.titleMedium),
                  if (event.displayDescription.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      event.displayDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (period != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            period,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                          onPressed: () => _openExternal(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  String? _periodLabel(AppLocalizations l10n) {
    final start = event.startAt;
    final end = event.endAt;
    if (start == null && end == null) {
      final published = event.publishedAt;
      if (published == null) return null;
      return l10n.publishedAt(_dateFormat.format(published));
    }
    final startText = start != null ? _dateFormat.format(start) : '?';
    final endText = end != null ? _dateFormat.format(end) : '?';
    return l10n.periodRange(startText, endText, '');
  }

  Future<void> _runAi() async {
    if (_analyzing) return;
    final confirmed = await AdGate.confirmAndShowAdForAi(context);
    if (!confirmed || !mounted) return;
    final l10n = AppLocalizations.of(context);

    setState(() => _analyzing = true);
    try {
      final analysis = await EventAiService().analyze(event);
      if (!mounted) return;
      await presentEventAiAnalysis(
        context,
        analysis: analysis,
        sourceUrl: event.url,
      );
    } catch (error, stackTrace) {
      debugPrint('[EventCard] AI analysis failed: $error');
      debugPrint('$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.aiFailed(error.toString()))));
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  Future<void> _openExternal(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final parsed = Uri.tryParse(event.url.trim());
    if (parsed == null ||
        (parsed.scheme != 'http' && parsed.scheme != 'https') ||
        parsed.host.isEmpty) {
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
