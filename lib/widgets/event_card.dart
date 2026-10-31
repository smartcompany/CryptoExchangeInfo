import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/exchange_event.dart';
import '../services/exchange_events_service.dart';
import '../theme/app_colors.dart';

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
  var _fetchingImage = false;

  ExchangeEvent get event => widget.event;

  @override
  void initState() {
    super.initState();
    _imageUrl = _normalizedImageUrl(event.imageUrl);
    if (_imageUrl == null) {
      _loadImage();
    }
  }

  @override
  void didUpdateWidget(covariant EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.url != event.url ||
        oldWidget.event.imageUrl != event.imageUrl) {
      _imageUrl = _normalizedImageUrl(event.imageUrl);
      if (_imageUrl == null) {
        _loadImage();
      } else {
        _fetchingImage = false;
      }
    }
  }

  static String? _normalizedImageUrl(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  Future<void> _loadImage() async {
    if (_fetchingImage || event.url.trim().isEmpty) return;
    Exchange? resolved = widget.exchange;
    if (resolved == null) {
      for (final value in Exchange.values) {
        if (value.name == event.exchange) {
          resolved = value;
          break;
        }
      }
    }
    if (resolved == null) return;

    _fetchingImage = true;
    try {
      final imageUrl = await widget.service.fetchEventImage(
        exchange: resolved,
        url: event.url,
      );
      if (!mounted) return;
      setState(() {
        _imageUrl = _normalizedImageUrl(imageUrl);
        _fetchingImage = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _fetchingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final period = _periodLabel();
    final imageUrl = _imageUrl;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppColors.contentInset,
        vertical: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openExternal(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null) _EventThumbnail(url: imageUrl),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tag in event.displayTags.take(3))
                        Chip(
                          label:
                              Text(tag, style: const TextStyle(fontSize: 14)),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.displayTitle,
                    style: theme.textTheme.titleMedium,
                  ),
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _openExternal(context),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(
                        '원문 보기',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _periodLabel() {
    final start = event.startAt;
    final end = event.endAt;
    if (start == null && end == null) {
      final published = event.publishedAt;
      if (published == null) return null;
      return '게시 ${_dateFormat.format(published)}';
    }
    final startText = start != null ? _dateFormat.format(start) : '?';
    final endText = end != null ? _dateFormat.format(end) : '?';
    return '기간 $startText ~ $endText';
  }

  Future<void> _openExternal(BuildContext context) async {
    final uri = Uri.tryParse(event.url.trim());
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

/// Renders a 16:9 thumbnail only after the network image has decoded.
class _EventThumbnail extends StatelessWidget {
  const _EventThumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: child,
          );
        }
        return const SizedBox.shrink();
      },
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
