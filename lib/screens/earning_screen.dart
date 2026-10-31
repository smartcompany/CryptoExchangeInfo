import 'package:flutter/material.dart';

import '../services/earn_service.dart';
import '../widgets/earn_product_card.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key, this.service});

  final EarnService? service;

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  late final EarnService _service = widget.service ?? EarnService();
  Future<FlexibleUsdtEarnResult>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _future = _service.fetchFlexibleUsdt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FlexibleUsdtEarnResult>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Flexible USDT Earn 불러오는 중…'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Earn 정보를 불러오지 못했습니다.'),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data;
          if (data == null || data.items.isEmpty) {
            return const Center(child: Text('표시할 Earn 상품이 없습니다.'));
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: data.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flexible USDT',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '거래소별 유연(Flexible) USDT 거치 금리입니다. '
                          '구간·시점에 따라 실효 금리가 달라질 수 있습니다.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return EarnProductCard(product: data.items[index - 1]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'earn_refresh',
        tooltip: '새로고침',
        onPressed: _reload,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
