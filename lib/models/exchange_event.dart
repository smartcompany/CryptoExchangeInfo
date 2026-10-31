class ExchangeEvent {
  const ExchangeEvent({
    required this.exchange,
    required this.title,
    required this.titleKo,
    required this.description,
    required this.descriptionKo,
    required this.typeKey,
    required this.typeTitle,
    required this.tags,
    required this.tagsKo,
    required this.url,
    this.imageUrl,
    this.dateTimestamp,
    this.startDateTimestamp,
    this.endDateTimestamp,
    this.publishTime,
  });

  final String exchange;
  final String title;
  final String titleKo;
  final String description;
  final String descriptionKo;
  final String typeKey;
  final String typeTitle;
  final List<String> tags;
  final List<String> tagsKo;
  final String url;
  final String? imageUrl;
  final int? dateTimestamp;
  final int? startDateTimestamp;
  final int? endDateTimestamp;
  final int? publishTime;

  String get displayTitle => titleKo.isNotEmpty ? titleKo : title;
  String get displayDescription =>
      descriptionKo.isNotEmpty ? descriptionKo : description;
  List<String> get displayTags => tagsKo.isNotEmpty ? tagsKo : tags;

  DateTime? get startAt => _fromMs(startDateTimestamp);
  DateTime? get endAt => _fromMs(endDateTimestamp);
  DateTime? get publishedAt => _fromMs(publishTime ?? dateTimestamp);

  static DateTime? _fromMs(int? ms) {
    if (ms == null || ms <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
  }

  ExchangeEvent copyWith({
    String? imageUrl,
    bool clearImageUrl = false,
  }) {
    return ExchangeEvent(
      exchange: exchange,
      title: title,
      titleKo: titleKo,
      description: description,
      descriptionKo: descriptionKo,
      typeKey: typeKey,
      typeTitle: typeTitle,
      tags: tags,
      tagsKo: tagsKo,
      url: url,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      dateTimestamp: dateTimestamp,
      startDateTimestamp: startDateTimestamp,
      endDateTimestamp: endDateTimestamp,
      publishTime: publishTime,
    );
  }

  factory ExchangeEvent.fromJson(Map<String, dynamic> json) {
    return ExchangeEvent(
      exchange: (json['exchange'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      titleKo: (json['titleKo'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      descriptionKo: (json['descriptionKo'] as String?) ?? '',
      typeKey: (json['typeKey'] as String?) ?? '',
      typeTitle: (json['typeTitle'] as String?) ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      tagsKo: (json['tagsKo'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      url: (json['url'] as String?) ?? '',
      imageUrl: json['imageUrl']?.toString(),
      dateTimestamp: _asInt(json['dateTimestamp']),
      startDateTimestamp: _asInt(json['startDateTimestamp']),
      endDateTimestamp: _asInt(json['endDateTimestamp']),
      publishTime: _asInt(json['publishTime']),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
