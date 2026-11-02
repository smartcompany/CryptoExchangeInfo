import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/exchange_event.dart';

part 'app_database.g.dart';

class CachedEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exchange => text()();
  TextColumn get url => text()();
  TextColumn get title => text()();
  TextColumn get titleKo => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get descriptionKo => text().withDefault(const Constant(''))();
  TextColumn get typeKey => text().withDefault(const Constant(''))();
  TextColumn get typeTitle => text().withDefault(const Constant(''))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get tagsKoJson => text().withDefault(const Constant('[]'))();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get dateTimestamp => integer().nullable()();
  IntColumn get startDateTimestamp => integer().nullable()();
  IntColumn get endDateTimestamp => integer().nullable()();
  IntColumn get publishTime => integer().nullable()();
  IntColumn get sortIndex => integer().withDefault(const Constant(0))();
  IntColumn get fetchedAtMs => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {exchange, url},
      ];
}

class ExchangeCaches extends Table {
  TextColumn get exchange => text()();
  IntColumn get total => integer().withDefault(const Constant(0))();
  IntColumn get fetchedAtMs => integer()();
  /// App language used when titles/descriptions were localized into cache.
  TextColumn get localeCode =>
      text().withDefault(const Constant('ko'))();

  @override
  Set<Column<Object>> get primaryKey => {exchange};
}

@DriftDatabase(tables: [CachedEvents, ExchangeCaches])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(cachedEvents, cachedEvents.imageUrl);
          }
          if (from < 3) {
            await m.addColumn(exchangeCaches, exchangeCaches.localeCode);
          }
        },
      );

  static QueryExecutor _open() {
    return driftDatabase(
      name: 'coininfo',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  Future<ExchangeEventsSnapshot?> readExchangeSnapshot(String exchange) async {
    final meta = await (select(exchangeCaches)
          ..where((t) => t.exchange.equals(exchange)))
        .getSingleOrNull();
    if (meta == null) return null;

    final rows = await (select(cachedEvents)
          ..where((t) => t.exchange.equals(exchange))
          ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
        .get();
    if (rows.isEmpty) return null;

    return ExchangeEventsSnapshot(
      exchange: exchange,
      total: meta.total,
      fetchedAt: DateTime.fromMillisecondsSinceEpoch(meta.fetchedAtMs),
      localeCode: meta.localeCode,
      items: rows.map(_rowToEvent).toList(),
    );
  }

  Future<void> replaceExchangeEvents({
    required String exchange,
    required int total,
    required List<ExchangeEvent> items,
    String localeCode = 'en',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await transaction(() async {
      await (delete(cachedEvents)..where((t) => t.exchange.equals(exchange)))
          .go();
      await into(exchangeCaches).insertOnConflictUpdate(
        ExchangeCachesCompanion.insert(
          exchange: exchange,
          total: Value(total),
          fetchedAtMs: now,
          localeCode: Value(localeCode),
        ),
      );
      for (var i = 0; i < items.length; i++) {
        final event = items[i];
        await into(cachedEvents).insert(
          CachedEventsCompanion.insert(
            exchange: exchange,
            url: event.url,
            title: event.title,
            titleKo: Value(event.titleKo),
            description: Value(event.description),
            descriptionKo: Value(event.descriptionKo),
            typeKey: Value(event.typeKey),
            typeTitle: Value(event.typeTitle),
            tagsJson: Value(jsonEncode(event.tags)),
            tagsKoJson: Value(jsonEncode(event.tagsKo)),
            imageUrl: Value(event.imageUrl),
            dateTimestamp: Value(event.dateTimestamp),
            startDateTimestamp: Value(event.startDateTimestamp),
            endDateTimestamp: Value(event.endDateTimestamp),
            publishTime: Value(event.publishTime),
            sortIndex: Value(i),
            fetchedAtMs: now,
          ),
        );
      }
    });
  }

  Future<void> updateEventImageUrl({
    required String exchange,
    required String url,
    required String? imageUrl,
  }) async {
    await (update(cachedEvents)
          ..where((t) => t.exchange.equals(exchange) & t.url.equals(url)))
        .write(CachedEventsCompanion(imageUrl: Value(imageUrl)));
  }

  ExchangeEvent _rowToEvent(CachedEvent row) {
    return ExchangeEvent(
      exchange: row.exchange,
      title: row.title,
      titleKo: row.titleKo,
      description: row.description,
      descriptionKo: row.descriptionKo,
      typeKey: row.typeKey,
      typeTitle: row.typeTitle,
      tags: _decodeStringList(row.tagsJson),
      tagsKo: _decodeStringList(row.tagsKoJson),
      url: row.url,
      imageUrl: row.imageUrl,
      dateTimestamp: row.dateTimestamp,
      startDateTimestamp: row.startDateTimestamp,
      endDateTimestamp: row.endDateTimestamp,
      publishTime: row.publishTime,
    );
  }

  List<String> _decodeStringList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return const [];
  }
}

class ExchangeEventsSnapshot {
  const ExchangeEventsSnapshot({
    required this.exchange,
    required this.total,
    required this.fetchedAt,
    required this.items,
    this.localeCode = 'en',
  });

  final String exchange;
  final int total;
  final DateTime fetchedAt;
  final List<ExchangeEvent> items;
  final String localeCode;

  bool isFresh(Duration ttl) {
    return DateTime.now().difference(fetchedAt) <= ttl;
  }
}
