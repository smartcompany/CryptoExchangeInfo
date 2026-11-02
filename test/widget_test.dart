import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coininfo/data/app_database.dart';
import 'package:coininfo/main.dart';
import 'package:coininfo/models/exchange_event.dart';
import 'package:coininfo/services/exchange_events_service.dart';

class _FakeEventsService extends ExchangeEventsService {
  _FakeEventsService() : super(database: AppDatabase(NativeDatabase.memory()));

  @override
  Future<ExchangeEventsResult> loadEvents(
    Exchange exchange, {
    int limit = 20,
    bool forceRefresh = false,
    void Function(ExchangeEventsResult cached)? onCache,
  }) async {
    return ExchangeEventsResult(
      exchange: exchange,
      total: 0,
      items: const [],
      fromCache: true,
      fetchedAt: DateTime.now(),
      hasMore: false,
      page: 1,
    );
  }

  @override
  Future<ExchangeEventsResult> loadMoreEvents(
    Exchange exchange, {
    required List<ExchangeEvent> current,
    required int nextPage,
  }) async {
    return ExchangeEventsResult(
      exchange: exchange,
      total: current.length,
      items: current,
      fromCache: true,
      fetchedAt: DateTime.now(),
      hasMore: false,
      page: nextPage,
    );
  }
}

void main() {
  testWidgets('Exora app builds with section dropdown', (tester) async {
    await tester.pumpWidget(ExoraApp(eventsService: _FakeEventsService()));
    await tester.pump();

    expect(find.text('거래소 이벤트'), findsWidgets);
    expect(find.text('바이비트'), findsOneWidget);
  });
}
