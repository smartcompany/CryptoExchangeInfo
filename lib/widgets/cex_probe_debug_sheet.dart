import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../services/api_auth.dart';
import '../services/exchange_events_service.dart';
import '../theme/app_colors.dart';

/// Debug-only sheet: calls `GET /api/cex-probe` on the active API host.
Future<void> showCexProbeDebugSheet(BuildContext context) {
  assert(kDebugMode, 'CEX probe sheet is debug-only');
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.card,
    builder: (context) => const _CexProbeDebugSheet(),
  );
}

class _CexProbeDebugSheet extends StatefulWidget {
  const _CexProbeDebugSheet();

  @override
  State<_CexProbeDebugSheet> createState() => _CexProbeDebugSheetState();
}

class _CexProbeDebugSheetState extends State<_CexProbeDebugSheet> {
  var _loading = false;
  String? _error;
  Map<String, dynamic>? _payload;
  final _base = ExchangeEventsService.productionApiBaseUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uri = Uri.parse('$_base/api/cex-probe').replace(
        queryParameters: {'exchange': 'all'},
      );
      final res = await http
          .get(uri, headers: {...ApiAuth.headers, 'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected JSON');
      }
      if (!mounted) return;
      setState(() {
        _payload = decoded;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final results = _payload?['results'];
    final resultMap = results is Map<String, dynamic>
        ? results
        : <String, dynamic>{};

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CEX probe (debug)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _base,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            if (_payload != null) ...[
              const SizedBox(height: 6),
              Text(
                _egressSummary(_payload!),
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: _run, child: const Text('Retry')),
            ] else ...[
              Row(
                children: [
                  Icon(
                    (_payload?['ok'] == true)
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    color: (_payload?['ok'] == true)
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _payload?['ok'] == true
                        ? 'All probed exchanges OK'
                        : 'One or more exchanges failed',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final entry in resultMap.entries)
                _ExchangeProbeTile(
                  name: entry.key,
                  data: entry.value is Map<String, dynamic>
                      ? entry.value as Map<String, dynamic>
                      : const {},
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      final pretty = const JsonEncoder.withIndent(
                        '  ',
                      ).convert(_payload);
                      Clipboard.setData(ClipboardData(text: pretty));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('JSON copied')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy JSON'),
                  ),
                  const Spacer(),
                  FilledButton(onPressed: _run, child: const Text('Run again')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _egressSummary(Map<String, dynamic> payload) {
  final egress = payload['egress'];
  final runtime = payload['runtime']?.toString();
  final parts = <String>[];
  if (runtime != null && runtime.isNotEmpty) {
    parts.add('runtime=$runtime');
  }
  if (egress is Map) {
    final loc = egress['loc']?.toString();
    final colo = egress['colo']?.toString();
    final ip = egress['ip']?.toString();
    if (loc != null && loc.isNotEmpty) parts.add('egress loc=$loc');
    if (colo != null && colo.isNotEmpty) parts.add('colo=$colo');
    if (ip != null && ip.isNotEmpty) parts.add('ip=$ip');
  }
  return parts.isEmpty ? 'egress: (unknown)' : parts.join(' · ');
}

class _ExchangeProbeTile extends StatelessWidget {
  const _ExchangeProbeTile({required this.name, required this.data});

  final String name;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final ok = data['ok'] == true;
    final title = data['sampleTitle']?.toString();
    final err = data['error']?.toString();
    final ms = data['latencyMs'];
    final status = data['httpStatus'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.page,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                ok ? Icons.check_circle_outline : Icons.error_outline,
                size: 18,
                color: ok ? Colors.green.shade700 : Colors.redAccent,
              ),
              const SizedBox(width: 6),
              Text(
                name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                'HTTP $status · ${ms ?? '—'}ms',
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
          if (data['annType'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'annType=${data['annType']}',
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
          if (title != null && title.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 13)),
          ],
          if (err != null && err.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              err,
              style: const TextStyle(fontSize: 12, color: Colors.redAccent),
            ),
          ],
        ],
      ),
    );
  }
}
