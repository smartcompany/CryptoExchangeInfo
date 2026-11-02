// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedEventsTable extends CachedEvents
    with TableInfo<$CachedEventsTable, CachedEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exchangeMeta = const VerificationMeta(
    'exchange',
  );
  @override
  late final GeneratedColumn<String> exchange = GeneratedColumn<String>(
    'exchange',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleKoMeta = const VerificationMeta(
    'titleKo',
  );
  @override
  late final GeneratedColumn<String> titleKo = GeneratedColumn<String>(
    'title_ko',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _descriptionKoMeta = const VerificationMeta(
    'descriptionKo',
  );
  @override
  late final GeneratedColumn<String> descriptionKo = GeneratedColumn<String>(
    'description_ko',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeKeyMeta = const VerificationMeta(
    'typeKey',
  );
  @override
  late final GeneratedColumn<String> typeKey = GeneratedColumn<String>(
    'type_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeTitleMeta = const VerificationMeta(
    'typeTitle',
  );
  @override
  late final GeneratedColumn<String> typeTitle = GeneratedColumn<String>(
    'type_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _tagsKoJsonMeta = const VerificationMeta(
    'tagsKoJson',
  );
  @override
  late final GeneratedColumn<String> tagsKoJson = GeneratedColumn<String>(
    'tags_ko_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateTimestampMeta = const VerificationMeta(
    'dateTimestamp',
  );
  @override
  late final GeneratedColumn<int> dateTimestamp = GeneratedColumn<int>(
    'date_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateTimestampMeta =
      const VerificationMeta('startDateTimestamp');
  @override
  late final GeneratedColumn<int> startDateTimestamp = GeneratedColumn<int>(
    'start_date_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateTimestampMeta = const VerificationMeta(
    'endDateTimestamp',
  );
  @override
  late final GeneratedColumn<int> endDateTimestamp = GeneratedColumn<int>(
    'end_date_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishTimeMeta = const VerificationMeta(
    'publishTime',
  );
  @override
  late final GeneratedColumn<int> publishTime = GeneratedColumn<int>(
    'publish_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fetchedAtMsMeta = const VerificationMeta(
    'fetchedAtMs',
  );
  @override
  late final GeneratedColumn<int> fetchedAtMs = GeneratedColumn<int>(
    'fetched_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exchange,
    url,
    title,
    titleKo,
    description,
    descriptionKo,
    typeKey,
    typeTitle,
    tagsJson,
    tagsKoJson,
    imageUrl,
    dateTimestamp,
    startDateTimestamp,
    endDateTimestamp,
    publishTime,
    sortIndex,
    fetchedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exchange')) {
      context.handle(
        _exchangeMeta,
        exchange.isAcceptableOrUnknown(data['exchange']!, _exchangeMeta),
      );
    } else if (isInserting) {
      context.missing(_exchangeMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_ko')) {
      context.handle(
        _titleKoMeta,
        titleKo.isAcceptableOrUnknown(data['title_ko']!, _titleKoMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('description_ko')) {
      context.handle(
        _descriptionKoMeta,
        descriptionKo.isAcceptableOrUnknown(
          data['description_ko']!,
          _descriptionKoMeta,
        ),
      );
    }
    if (data.containsKey('type_key')) {
      context.handle(
        _typeKeyMeta,
        typeKey.isAcceptableOrUnknown(data['type_key']!, _typeKeyMeta),
      );
    }
    if (data.containsKey('type_title')) {
      context.handle(
        _typeTitleMeta,
        typeTitle.isAcceptableOrUnknown(data['type_title']!, _typeTitleMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('tags_ko_json')) {
      context.handle(
        _tagsKoJsonMeta,
        tagsKoJson.isAcceptableOrUnknown(
          data['tags_ko_json']!,
          _tagsKoJsonMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('date_timestamp')) {
      context.handle(
        _dateTimestampMeta,
        dateTimestamp.isAcceptableOrUnknown(
          data['date_timestamp']!,
          _dateTimestampMeta,
        ),
      );
    }
    if (data.containsKey('start_date_timestamp')) {
      context.handle(
        _startDateTimestampMeta,
        startDateTimestamp.isAcceptableOrUnknown(
          data['start_date_timestamp']!,
          _startDateTimestampMeta,
        ),
      );
    }
    if (data.containsKey('end_date_timestamp')) {
      context.handle(
        _endDateTimestampMeta,
        endDateTimestamp.isAcceptableOrUnknown(
          data['end_date_timestamp']!,
          _endDateTimestampMeta,
        ),
      );
    }
    if (data.containsKey('publish_time')) {
      context.handle(
        _publishTimeMeta,
        publishTime.isAcceptableOrUnknown(
          data['publish_time']!,
          _publishTimeMeta,
        ),
      );
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    }
    if (data.containsKey('fetched_at_ms')) {
      context.handle(
        _fetchedAtMsMeta,
        fetchedAtMs.isAcceptableOrUnknown(
          data['fetched_at_ms']!,
          _fetchedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exchange, url},
  ];
  @override
  CachedEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exchange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ko'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      descriptionKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_ko'],
      )!,
      typeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_key'],
      )!,
      typeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_title'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      tagsKoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_ko_json'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      dateTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_timestamp'],
      ),
      startDateTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date_timestamp'],
      ),
      endDateTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date_timestamp'],
      ),
      publishTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}publish_time'],
      ),
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
      fetchedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at_ms'],
      )!,
    );
  }

  @override
  $CachedEventsTable createAlias(String alias) {
    return $CachedEventsTable(attachedDatabase, alias);
  }
}

class CachedEvent extends DataClass implements Insertable<CachedEvent> {
  final int id;
  final String exchange;
  final String url;
  final String title;
  final String titleKo;
  final String description;
  final String descriptionKo;
  final String typeKey;
  final String typeTitle;
  final String tagsJson;
  final String tagsKoJson;
  final String? imageUrl;
  final int? dateTimestamp;
  final int? startDateTimestamp;
  final int? endDateTimestamp;
  final int? publishTime;
  final int sortIndex;
  final int fetchedAtMs;
  const CachedEvent({
    required this.id,
    required this.exchange,
    required this.url,
    required this.title,
    required this.titleKo,
    required this.description,
    required this.descriptionKo,
    required this.typeKey,
    required this.typeTitle,
    required this.tagsJson,
    required this.tagsKoJson,
    this.imageUrl,
    this.dateTimestamp,
    this.startDateTimestamp,
    this.endDateTimestamp,
    this.publishTime,
    required this.sortIndex,
    required this.fetchedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exchange'] = Variable<String>(exchange);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    map['title_ko'] = Variable<String>(titleKo);
    map['description'] = Variable<String>(description);
    map['description_ko'] = Variable<String>(descriptionKo);
    map['type_key'] = Variable<String>(typeKey);
    map['type_title'] = Variable<String>(typeTitle);
    map['tags_json'] = Variable<String>(tagsJson);
    map['tags_ko_json'] = Variable<String>(tagsKoJson);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || dateTimestamp != null) {
      map['date_timestamp'] = Variable<int>(dateTimestamp);
    }
    if (!nullToAbsent || startDateTimestamp != null) {
      map['start_date_timestamp'] = Variable<int>(startDateTimestamp);
    }
    if (!nullToAbsent || endDateTimestamp != null) {
      map['end_date_timestamp'] = Variable<int>(endDateTimestamp);
    }
    if (!nullToAbsent || publishTime != null) {
      map['publish_time'] = Variable<int>(publishTime);
    }
    map['sort_index'] = Variable<int>(sortIndex);
    map['fetched_at_ms'] = Variable<int>(fetchedAtMs);
    return map;
  }

  CachedEventsCompanion toCompanion(bool nullToAbsent) {
    return CachedEventsCompanion(
      id: Value(id),
      exchange: Value(exchange),
      url: Value(url),
      title: Value(title),
      titleKo: Value(titleKo),
      description: Value(description),
      descriptionKo: Value(descriptionKo),
      typeKey: Value(typeKey),
      typeTitle: Value(typeTitle),
      tagsJson: Value(tagsJson),
      tagsKoJson: Value(tagsKoJson),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      dateTimestamp: dateTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(dateTimestamp),
      startDateTimestamp: startDateTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(startDateTimestamp),
      endDateTimestamp: endDateTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(endDateTimestamp),
      publishTime: publishTime == null && nullToAbsent
          ? const Value.absent()
          : Value(publishTime),
      sortIndex: Value(sortIndex),
      fetchedAtMs: Value(fetchedAtMs),
    );
  }

  factory CachedEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedEvent(
      id: serializer.fromJson<int>(json['id']),
      exchange: serializer.fromJson<String>(json['exchange']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      titleKo: serializer.fromJson<String>(json['titleKo']),
      description: serializer.fromJson<String>(json['description']),
      descriptionKo: serializer.fromJson<String>(json['descriptionKo']),
      typeKey: serializer.fromJson<String>(json['typeKey']),
      typeTitle: serializer.fromJson<String>(json['typeTitle']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      tagsKoJson: serializer.fromJson<String>(json['tagsKoJson']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      dateTimestamp: serializer.fromJson<int?>(json['dateTimestamp']),
      startDateTimestamp: serializer.fromJson<int?>(json['startDateTimestamp']),
      endDateTimestamp: serializer.fromJson<int?>(json['endDateTimestamp']),
      publishTime: serializer.fromJson<int?>(json['publishTime']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      fetchedAtMs: serializer.fromJson<int>(json['fetchedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exchange': serializer.toJson<String>(exchange),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'titleKo': serializer.toJson<String>(titleKo),
      'description': serializer.toJson<String>(description),
      'descriptionKo': serializer.toJson<String>(descriptionKo),
      'typeKey': serializer.toJson<String>(typeKey),
      'typeTitle': serializer.toJson<String>(typeTitle),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'tagsKoJson': serializer.toJson<String>(tagsKoJson),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'dateTimestamp': serializer.toJson<int?>(dateTimestamp),
      'startDateTimestamp': serializer.toJson<int?>(startDateTimestamp),
      'endDateTimestamp': serializer.toJson<int?>(endDateTimestamp),
      'publishTime': serializer.toJson<int?>(publishTime),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'fetchedAtMs': serializer.toJson<int>(fetchedAtMs),
    };
  }

  CachedEvent copyWith({
    int? id,
    String? exchange,
    String? url,
    String? title,
    String? titleKo,
    String? description,
    String? descriptionKo,
    String? typeKey,
    String? typeTitle,
    String? tagsJson,
    String? tagsKoJson,
    Value<String?> imageUrl = const Value.absent(),
    Value<int?> dateTimestamp = const Value.absent(),
    Value<int?> startDateTimestamp = const Value.absent(),
    Value<int?> endDateTimestamp = const Value.absent(),
    Value<int?> publishTime = const Value.absent(),
    int? sortIndex,
    int? fetchedAtMs,
  }) => CachedEvent(
    id: id ?? this.id,
    exchange: exchange ?? this.exchange,
    url: url ?? this.url,
    title: title ?? this.title,
    titleKo: titleKo ?? this.titleKo,
    description: description ?? this.description,
    descriptionKo: descriptionKo ?? this.descriptionKo,
    typeKey: typeKey ?? this.typeKey,
    typeTitle: typeTitle ?? this.typeTitle,
    tagsJson: tagsJson ?? this.tagsJson,
    tagsKoJson: tagsKoJson ?? this.tagsKoJson,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    dateTimestamp: dateTimestamp.present
        ? dateTimestamp.value
        : this.dateTimestamp,
    startDateTimestamp: startDateTimestamp.present
        ? startDateTimestamp.value
        : this.startDateTimestamp,
    endDateTimestamp: endDateTimestamp.present
        ? endDateTimestamp.value
        : this.endDateTimestamp,
    publishTime: publishTime.present ? publishTime.value : this.publishTime,
    sortIndex: sortIndex ?? this.sortIndex,
    fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
  );
  CachedEvent copyWithCompanion(CachedEventsCompanion data) {
    return CachedEvent(
      id: data.id.present ? data.id.value : this.id,
      exchange: data.exchange.present ? data.exchange.value : this.exchange,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      titleKo: data.titleKo.present ? data.titleKo.value : this.titleKo,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionKo: data.descriptionKo.present
          ? data.descriptionKo.value
          : this.descriptionKo,
      typeKey: data.typeKey.present ? data.typeKey.value : this.typeKey,
      typeTitle: data.typeTitle.present ? data.typeTitle.value : this.typeTitle,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      tagsKoJson: data.tagsKoJson.present
          ? data.tagsKoJson.value
          : this.tagsKoJson,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      dateTimestamp: data.dateTimestamp.present
          ? data.dateTimestamp.value
          : this.dateTimestamp,
      startDateTimestamp: data.startDateTimestamp.present
          ? data.startDateTimestamp.value
          : this.startDateTimestamp,
      endDateTimestamp: data.endDateTimestamp.present
          ? data.endDateTimestamp.value
          : this.endDateTimestamp,
      publishTime: data.publishTime.present
          ? data.publishTime.value
          : this.publishTime,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      fetchedAtMs: data.fetchedAtMs.present
          ? data.fetchedAtMs.value
          : this.fetchedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedEvent(')
          ..write('id: $id, ')
          ..write('exchange: $exchange, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('titleKo: $titleKo, ')
          ..write('description: $description, ')
          ..write('descriptionKo: $descriptionKo, ')
          ..write('typeKey: $typeKey, ')
          ..write('typeTitle: $typeTitle, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('tagsKoJson: $tagsKoJson, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('dateTimestamp: $dateTimestamp, ')
          ..write('startDateTimestamp: $startDateTimestamp, ')
          ..write('endDateTimestamp: $endDateTimestamp, ')
          ..write('publishTime: $publishTime, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('fetchedAtMs: $fetchedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exchange,
    url,
    title,
    titleKo,
    description,
    descriptionKo,
    typeKey,
    typeTitle,
    tagsJson,
    tagsKoJson,
    imageUrl,
    dateTimestamp,
    startDateTimestamp,
    endDateTimestamp,
    publishTime,
    sortIndex,
    fetchedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedEvent &&
          other.id == this.id &&
          other.exchange == this.exchange &&
          other.url == this.url &&
          other.title == this.title &&
          other.titleKo == this.titleKo &&
          other.description == this.description &&
          other.descriptionKo == this.descriptionKo &&
          other.typeKey == this.typeKey &&
          other.typeTitle == this.typeTitle &&
          other.tagsJson == this.tagsJson &&
          other.tagsKoJson == this.tagsKoJson &&
          other.imageUrl == this.imageUrl &&
          other.dateTimestamp == this.dateTimestamp &&
          other.startDateTimestamp == this.startDateTimestamp &&
          other.endDateTimestamp == this.endDateTimestamp &&
          other.publishTime == this.publishTime &&
          other.sortIndex == this.sortIndex &&
          other.fetchedAtMs == this.fetchedAtMs);
}

class CachedEventsCompanion extends UpdateCompanion<CachedEvent> {
  final Value<int> id;
  final Value<String> exchange;
  final Value<String> url;
  final Value<String> title;
  final Value<String> titleKo;
  final Value<String> description;
  final Value<String> descriptionKo;
  final Value<String> typeKey;
  final Value<String> typeTitle;
  final Value<String> tagsJson;
  final Value<String> tagsKoJson;
  final Value<String?> imageUrl;
  final Value<int?> dateTimestamp;
  final Value<int?> startDateTimestamp;
  final Value<int?> endDateTimestamp;
  final Value<int?> publishTime;
  final Value<int> sortIndex;
  final Value<int> fetchedAtMs;
  const CachedEventsCompanion({
    this.id = const Value.absent(),
    this.exchange = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.titleKo = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionKo = const Value.absent(),
    this.typeKey = const Value.absent(),
    this.typeTitle = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.tagsKoJson = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.dateTimestamp = const Value.absent(),
    this.startDateTimestamp = const Value.absent(),
    this.endDateTimestamp = const Value.absent(),
    this.publishTime = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.fetchedAtMs = const Value.absent(),
  });
  CachedEventsCompanion.insert({
    this.id = const Value.absent(),
    required String exchange,
    required String url,
    required String title,
    this.titleKo = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionKo = const Value.absent(),
    this.typeKey = const Value.absent(),
    this.typeTitle = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.tagsKoJson = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.dateTimestamp = const Value.absent(),
    this.startDateTimestamp = const Value.absent(),
    this.endDateTimestamp = const Value.absent(),
    this.publishTime = const Value.absent(),
    this.sortIndex = const Value.absent(),
    required int fetchedAtMs,
  }) : exchange = Value(exchange),
       url = Value(url),
       title = Value(title),
       fetchedAtMs = Value(fetchedAtMs);
  static Insertable<CachedEvent> custom({
    Expression<int>? id,
    Expression<String>? exchange,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? titleKo,
    Expression<String>? description,
    Expression<String>? descriptionKo,
    Expression<String>? typeKey,
    Expression<String>? typeTitle,
    Expression<String>? tagsJson,
    Expression<String>? tagsKoJson,
    Expression<String>? imageUrl,
    Expression<int>? dateTimestamp,
    Expression<int>? startDateTimestamp,
    Expression<int>? endDateTimestamp,
    Expression<int>? publishTime,
    Expression<int>? sortIndex,
    Expression<int>? fetchedAtMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exchange != null) 'exchange': exchange,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (titleKo != null) 'title_ko': titleKo,
      if (description != null) 'description': description,
      if (descriptionKo != null) 'description_ko': descriptionKo,
      if (typeKey != null) 'type_key': typeKey,
      if (typeTitle != null) 'type_title': typeTitle,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (tagsKoJson != null) 'tags_ko_json': tagsKoJson,
      if (imageUrl != null) 'image_url': imageUrl,
      if (dateTimestamp != null) 'date_timestamp': dateTimestamp,
      if (startDateTimestamp != null)
        'start_date_timestamp': startDateTimestamp,
      if (endDateTimestamp != null) 'end_date_timestamp': endDateTimestamp,
      if (publishTime != null) 'publish_time': publishTime,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (fetchedAtMs != null) 'fetched_at_ms': fetchedAtMs,
    });
  }

  CachedEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? exchange,
    Value<String>? url,
    Value<String>? title,
    Value<String>? titleKo,
    Value<String>? description,
    Value<String>? descriptionKo,
    Value<String>? typeKey,
    Value<String>? typeTitle,
    Value<String>? tagsJson,
    Value<String>? tagsKoJson,
    Value<String?>? imageUrl,
    Value<int?>? dateTimestamp,
    Value<int?>? startDateTimestamp,
    Value<int?>? endDateTimestamp,
    Value<int?>? publishTime,
    Value<int>? sortIndex,
    Value<int>? fetchedAtMs,
  }) {
    return CachedEventsCompanion(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      url: url ?? this.url,
      title: title ?? this.title,
      titleKo: titleKo ?? this.titleKo,
      description: description ?? this.description,
      descriptionKo: descriptionKo ?? this.descriptionKo,
      typeKey: typeKey ?? this.typeKey,
      typeTitle: typeTitle ?? this.typeTitle,
      tagsJson: tagsJson ?? this.tagsJson,
      tagsKoJson: tagsKoJson ?? this.tagsKoJson,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTimestamp: dateTimestamp ?? this.dateTimestamp,
      startDateTimestamp: startDateTimestamp ?? this.startDateTimestamp,
      endDateTimestamp: endDateTimestamp ?? this.endDateTimestamp,
      publishTime: publishTime ?? this.publishTime,
      sortIndex: sortIndex ?? this.sortIndex,
      fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exchange.present) {
      map['exchange'] = Variable<String>(exchange.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleKo.present) {
      map['title_ko'] = Variable<String>(titleKo.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionKo.present) {
      map['description_ko'] = Variable<String>(descriptionKo.value);
    }
    if (typeKey.present) {
      map['type_key'] = Variable<String>(typeKey.value);
    }
    if (typeTitle.present) {
      map['type_title'] = Variable<String>(typeTitle.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (tagsKoJson.present) {
      map['tags_ko_json'] = Variable<String>(tagsKoJson.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (dateTimestamp.present) {
      map['date_timestamp'] = Variable<int>(dateTimestamp.value);
    }
    if (startDateTimestamp.present) {
      map['start_date_timestamp'] = Variable<int>(startDateTimestamp.value);
    }
    if (endDateTimestamp.present) {
      map['end_date_timestamp'] = Variable<int>(endDateTimestamp.value);
    }
    if (publishTime.present) {
      map['publish_time'] = Variable<int>(publishTime.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (fetchedAtMs.present) {
      map['fetched_at_ms'] = Variable<int>(fetchedAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedEventsCompanion(')
          ..write('id: $id, ')
          ..write('exchange: $exchange, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('titleKo: $titleKo, ')
          ..write('description: $description, ')
          ..write('descriptionKo: $descriptionKo, ')
          ..write('typeKey: $typeKey, ')
          ..write('typeTitle: $typeTitle, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('tagsKoJson: $tagsKoJson, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('dateTimestamp: $dateTimestamp, ')
          ..write('startDateTimestamp: $startDateTimestamp, ')
          ..write('endDateTimestamp: $endDateTimestamp, ')
          ..write('publishTime: $publishTime, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('fetchedAtMs: $fetchedAtMs')
          ..write(')'))
        .toString();
  }
}

class $ExchangeCachesTable extends ExchangeCaches
    with TableInfo<$ExchangeCachesTable, ExchangeCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeCachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exchangeMeta = const VerificationMeta(
    'exchange',
  );
  @override
  late final GeneratedColumn<String> exchange = GeneratedColumn<String>(
    'exchange',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fetchedAtMsMeta = const VerificationMeta(
    'fetchedAtMs',
  );
  @override
  late final GeneratedColumn<int> fetchedAtMs = GeneratedColumn<int>(
    'fetched_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeCodeMeta = const VerificationMeta(
    'localeCode',
  );
  @override
  late final GeneratedColumn<String> localeCode = GeneratedColumn<String>(
    'locale_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ko'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    exchange,
    total,
    fetchedAtMs,
    localeCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_caches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeCache> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exchange')) {
      context.handle(
        _exchangeMeta,
        exchange.isAcceptableOrUnknown(data['exchange']!, _exchangeMeta),
      );
    } else if (isInserting) {
      context.missing(_exchangeMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('fetched_at_ms')) {
      context.handle(
        _fetchedAtMsMeta,
        fetchedAtMs.isAcceptableOrUnknown(
          data['fetched_at_ms']!,
          _fetchedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMsMeta);
    }
    if (data.containsKey('locale_code')) {
      context.handle(
        _localeCodeMeta,
        localeCode.isAcceptableOrUnknown(data['locale_code']!, _localeCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exchange};
  @override
  ExchangeCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeCache(
      exchange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      fetchedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at_ms'],
      )!,
      localeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_code'],
      )!,
    );
  }

  @override
  $ExchangeCachesTable createAlias(String alias) {
    return $ExchangeCachesTable(attachedDatabase, alias);
  }
}

class ExchangeCache extends DataClass implements Insertable<ExchangeCache> {
  final String exchange;
  final int total;
  final int fetchedAtMs;

  /// App language used when titles/descriptions were localized into cache.
  final String localeCode;
  const ExchangeCache({
    required this.exchange,
    required this.total,
    required this.fetchedAtMs,
    required this.localeCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exchange'] = Variable<String>(exchange);
    map['total'] = Variable<int>(total);
    map['fetched_at_ms'] = Variable<int>(fetchedAtMs);
    map['locale_code'] = Variable<String>(localeCode);
    return map;
  }

  ExchangeCachesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeCachesCompanion(
      exchange: Value(exchange),
      total: Value(total),
      fetchedAtMs: Value(fetchedAtMs),
      localeCode: Value(localeCode),
    );
  }

  factory ExchangeCache.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeCache(
      exchange: serializer.fromJson<String>(json['exchange']),
      total: serializer.fromJson<int>(json['total']),
      fetchedAtMs: serializer.fromJson<int>(json['fetchedAtMs']),
      localeCode: serializer.fromJson<String>(json['localeCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exchange': serializer.toJson<String>(exchange),
      'total': serializer.toJson<int>(total),
      'fetchedAtMs': serializer.toJson<int>(fetchedAtMs),
      'localeCode': serializer.toJson<String>(localeCode),
    };
  }

  ExchangeCache copyWith({
    String? exchange,
    int? total,
    int? fetchedAtMs,
    String? localeCode,
  }) => ExchangeCache(
    exchange: exchange ?? this.exchange,
    total: total ?? this.total,
    fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
    localeCode: localeCode ?? this.localeCode,
  );
  ExchangeCache copyWithCompanion(ExchangeCachesCompanion data) {
    return ExchangeCache(
      exchange: data.exchange.present ? data.exchange.value : this.exchange,
      total: data.total.present ? data.total.value : this.total,
      fetchedAtMs: data.fetchedAtMs.present
          ? data.fetchedAtMs.value
          : this.fetchedAtMs,
      localeCode: data.localeCode.present
          ? data.localeCode.value
          : this.localeCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeCache(')
          ..write('exchange: $exchange, ')
          ..write('total: $total, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('localeCode: $localeCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(exchange, total, fetchedAtMs, localeCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeCache &&
          other.exchange == this.exchange &&
          other.total == this.total &&
          other.fetchedAtMs == this.fetchedAtMs &&
          other.localeCode == this.localeCode);
}

class ExchangeCachesCompanion extends UpdateCompanion<ExchangeCache> {
  final Value<String> exchange;
  final Value<int> total;
  final Value<int> fetchedAtMs;
  final Value<String> localeCode;
  final Value<int> rowid;
  const ExchangeCachesCompanion({
    this.exchange = const Value.absent(),
    this.total = const Value.absent(),
    this.fetchedAtMs = const Value.absent(),
    this.localeCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeCachesCompanion.insert({
    required String exchange,
    this.total = const Value.absent(),
    required int fetchedAtMs,
    this.localeCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exchange = Value(exchange),
       fetchedAtMs = Value(fetchedAtMs);
  static Insertable<ExchangeCache> custom({
    Expression<String>? exchange,
    Expression<int>? total,
    Expression<int>? fetchedAtMs,
    Expression<String>? localeCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exchange != null) 'exchange': exchange,
      if (total != null) 'total': total,
      if (fetchedAtMs != null) 'fetched_at_ms': fetchedAtMs,
      if (localeCode != null) 'locale_code': localeCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeCachesCompanion copyWith({
    Value<String>? exchange,
    Value<int>? total,
    Value<int>? fetchedAtMs,
    Value<String>? localeCode,
    Value<int>? rowid,
  }) {
    return ExchangeCachesCompanion(
      exchange: exchange ?? this.exchange,
      total: total ?? this.total,
      fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
      localeCode: localeCode ?? this.localeCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exchange.present) {
      map['exchange'] = Variable<String>(exchange.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (fetchedAtMs.present) {
      map['fetched_at_ms'] = Variable<int>(fetchedAtMs.value);
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(localeCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeCachesCompanion(')
          ..write('exchange: $exchange, ')
          ..write('total: $total, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('localeCode: $localeCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedEventsTable cachedEvents = $CachedEventsTable(this);
  late final $ExchangeCachesTable exchangeCaches = $ExchangeCachesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedEvents,
    exchangeCaches,
  ];
}

typedef $$CachedEventsTableCreateCompanionBuilder =
    CachedEventsCompanion Function({
      Value<int> id,
      required String exchange,
      required String url,
      required String title,
      Value<String> titleKo,
      Value<String> description,
      Value<String> descriptionKo,
      Value<String> typeKey,
      Value<String> typeTitle,
      Value<String> tagsJson,
      Value<String> tagsKoJson,
      Value<String?> imageUrl,
      Value<int?> dateTimestamp,
      Value<int?> startDateTimestamp,
      Value<int?> endDateTimestamp,
      Value<int?> publishTime,
      Value<int> sortIndex,
      required int fetchedAtMs,
    });
typedef $$CachedEventsTableUpdateCompanionBuilder =
    CachedEventsCompanion Function({
      Value<int> id,
      Value<String> exchange,
      Value<String> url,
      Value<String> title,
      Value<String> titleKo,
      Value<String> description,
      Value<String> descriptionKo,
      Value<String> typeKey,
      Value<String> typeTitle,
      Value<String> tagsJson,
      Value<String> tagsKoJson,
      Value<String?> imageUrl,
      Value<int?> dateTimestamp,
      Value<int?> startDateTimestamp,
      Value<int?> endDateTimestamp,
      Value<int?> publishTime,
      Value<int> sortIndex,
      Value<int> fetchedAtMs,
    });

class $$CachedEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedEventsTable> {
  $$CachedEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleKo => $composableBuilder(
    column: $table.titleKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionKo => $composableBuilder(
    column: $table.descriptionKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeKey => $composableBuilder(
    column: $table.typeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeTitle => $composableBuilder(
    column: $table.typeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsKoJson => $composableBuilder(
    column: $table.tagsKoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateTimestamp => $composableBuilder(
    column: $table.dateTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDateTimestamp => $composableBuilder(
    column: $table.startDateTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDateTimestamp => $composableBuilder(
    column: $table.endDateTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publishTime => $composableBuilder(
    column: $table.publishTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedEventsTable> {
  $$CachedEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleKo => $composableBuilder(
    column: $table.titleKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionKo => $composableBuilder(
    column: $table.descriptionKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeKey => $composableBuilder(
    column: $table.typeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeTitle => $composableBuilder(
    column: $table.typeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsKoJson => $composableBuilder(
    column: $table.tagsKoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateTimestamp => $composableBuilder(
    column: $table.dateTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDateTimestamp => $composableBuilder(
    column: $table.startDateTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDateTimestamp => $composableBuilder(
    column: $table.endDateTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publishTime => $composableBuilder(
    column: $table.publishTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedEventsTable> {
  $$CachedEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exchange =>
      $composableBuilder(column: $table.exchange, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleKo =>
      $composableBuilder(column: $table.titleKo, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionKo => $composableBuilder(
    column: $table.descriptionKo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get typeKey =>
      $composableBuilder(column: $table.typeKey, builder: (column) => column);

  GeneratedColumn<String> get typeTitle =>
      $composableBuilder(column: $table.typeTitle, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get tagsKoJson => $composableBuilder(
    column: $table.tagsKoJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get dateTimestamp => $composableBuilder(
    column: $table.dateTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDateTimestamp => $composableBuilder(
    column: $table.startDateTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endDateTimestamp => $composableBuilder(
    column: $table.endDateTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get publishTime => $composableBuilder(
    column: $table.publishTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => column,
  );
}

class $$CachedEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedEventsTable,
          CachedEvent,
          $$CachedEventsTableFilterComposer,
          $$CachedEventsTableOrderingComposer,
          $$CachedEventsTableAnnotationComposer,
          $$CachedEventsTableCreateCompanionBuilder,
          $$CachedEventsTableUpdateCompanionBuilder,
          (
            CachedEvent,
            BaseReferences<_$AppDatabase, $CachedEventsTable, CachedEvent>,
          ),
          CachedEvent,
          PrefetchHooks Function()
        > {
  $$CachedEventsTableTableManager(_$AppDatabase db, $CachedEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> exchange = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleKo = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> descriptionKo = const Value.absent(),
                Value<String> typeKey = const Value.absent(),
                Value<String> typeTitle = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> tagsKoJson = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> dateTimestamp = const Value.absent(),
                Value<int?> startDateTimestamp = const Value.absent(),
                Value<int?> endDateTimestamp = const Value.absent(),
                Value<int?> publishTime = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> fetchedAtMs = const Value.absent(),
              }) => CachedEventsCompanion(
                id: id,
                exchange: exchange,
                url: url,
                title: title,
                titleKo: titleKo,
                description: description,
                descriptionKo: descriptionKo,
                typeKey: typeKey,
                typeTitle: typeTitle,
                tagsJson: tagsJson,
                tagsKoJson: tagsKoJson,
                imageUrl: imageUrl,
                dateTimestamp: dateTimestamp,
                startDateTimestamp: startDateTimestamp,
                endDateTimestamp: endDateTimestamp,
                publishTime: publishTime,
                sortIndex: sortIndex,
                fetchedAtMs: fetchedAtMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String exchange,
                required String url,
                required String title,
                Value<String> titleKo = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> descriptionKo = const Value.absent(),
                Value<String> typeKey = const Value.absent(),
                Value<String> typeTitle = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> tagsKoJson = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> dateTimestamp = const Value.absent(),
                Value<int?> startDateTimestamp = const Value.absent(),
                Value<int?> endDateTimestamp = const Value.absent(),
                Value<int?> publishTime = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                required int fetchedAtMs,
              }) => CachedEventsCompanion.insert(
                id: id,
                exchange: exchange,
                url: url,
                title: title,
                titleKo: titleKo,
                description: description,
                descriptionKo: descriptionKo,
                typeKey: typeKey,
                typeTitle: typeTitle,
                tagsJson: tagsJson,
                tagsKoJson: tagsKoJson,
                imageUrl: imageUrl,
                dateTimestamp: dateTimestamp,
                startDateTimestamp: startDateTimestamp,
                endDateTimestamp: endDateTimestamp,
                publishTime: publishTime,
                sortIndex: sortIndex,
                fetchedAtMs: fetchedAtMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedEventsTable, CachedEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedEventsTable,
                    CachedEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedEventsTable,
      CachedEvent,
      $$CachedEventsTableFilterComposer,
      $$CachedEventsTableOrderingComposer,
      $$CachedEventsTableAnnotationComposer,
      $$CachedEventsTableCreateCompanionBuilder,
      $$CachedEventsTableUpdateCompanionBuilder,
      (
        CachedEvent,
        BaseReferences<_$AppDatabase, $CachedEventsTable, CachedEvent>,
      ),
      CachedEvent,
      PrefetchHooks Function()
    >;
typedef $$ExchangeCachesTableCreateCompanionBuilder =
    ExchangeCachesCompanion Function({
      required String exchange,
      Value<int> total,
      required int fetchedAtMs,
      Value<String> localeCode,
      Value<int> rowid,
    });
typedef $$ExchangeCachesTableUpdateCompanionBuilder =
    ExchangeCachesCompanion Function({
      Value<String> exchange,
      Value<int> total,
      Value<int> fetchedAtMs,
      Value<String> localeCode,
      Value<int> rowid,
    });

class $$ExchangeCachesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeCachesTable> {
  $$ExchangeCachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeCachesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeCachesTable> {
  $$ExchangeCachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exchange => $composableBuilder(
    column: $table.exchange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeCachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeCachesTable> {
  $$ExchangeCachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exchange =>
      $composableBuilder(column: $table.exchange, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => column,
  );
}

class $$ExchangeCachesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeCachesTable,
          ExchangeCache,
          $$ExchangeCachesTableFilterComposer,
          $$ExchangeCachesTableOrderingComposer,
          $$ExchangeCachesTableAnnotationComposer,
          $$ExchangeCachesTableCreateCompanionBuilder,
          $$ExchangeCachesTableUpdateCompanionBuilder,
          (
            ExchangeCache,
            BaseReferences<_$AppDatabase, $ExchangeCachesTable, ExchangeCache>,
          ),
          ExchangeCache,
          PrefetchHooks Function()
        > {
  $$ExchangeCachesTableTableManager(
    _$AppDatabase db,
    $ExchangeCachesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeCachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeCachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeCachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> exchange = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> fetchedAtMs = const Value.absent(),
                Value<String> localeCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeCachesCompanion(
                exchange: exchange,
                total: total,
                fetchedAtMs: fetchedAtMs,
                localeCode: localeCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exchange,
                Value<int> total = const Value.absent(),
                required int fetchedAtMs,
                Value<String> localeCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeCachesCompanion.insert(
                exchange: exchange,
                total: total,
                fetchedAtMs: fetchedAtMs,
                localeCode: localeCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExchangeCachesTable, ExchangeCache>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExchangeCachesTable,
                    ExchangeCache
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeCachesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeCachesTable,
      ExchangeCache,
      $$ExchangeCachesTableFilterComposer,
      $$ExchangeCachesTableOrderingComposer,
      $$ExchangeCachesTableAnnotationComposer,
      $$ExchangeCachesTableCreateCompanionBuilder,
      $$ExchangeCachesTableUpdateCompanionBuilder,
      (
        ExchangeCache,
        BaseReferences<_$AppDatabase, $ExchangeCachesTable, ExchangeCache>,
      ),
      ExchangeCache,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedEventsTableTableManager get cachedEvents =>
      $$CachedEventsTableTableManager(_db, _db.cachedEvents);
  $$ExchangeCachesTableTableManager get exchangeCaches =>
      $$ExchangeCachesTableTableManager(_db, _db.exchangeCaches);
}
