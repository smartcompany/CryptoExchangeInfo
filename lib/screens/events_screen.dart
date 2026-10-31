import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/exchange_event.dart';
import '../models/opportunity.dart';
import '../services/exchange_events_service.dart';
import '../services/opportunity_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/event_card.dart';
import '../widgets/exchange_banner.dart';
import '../widgets/opportunity_card.dart';
import 'earning_screen.dart';

enum HomeSection { events, earning }

enum OpportunitySort { endingSoon, newest }

extension HomeSectionX on HomeSection {
  String get labelKo => switch (this) {
        HomeSection.events => '거래소 이벤트',
        HomeSection.earning => 'Earning (Flexible USDT)',
      };

  String get shortLabelKo => switch (this) {
        HomeSection.events => '거래소 이벤트',
        HomeSection.earning => 'Flexible USDT',
      };

  IconData get icon => switch (this) {
        HomeSection.events => Icons.campaign_outlined,
        HomeSection.earning => Icons.savings_outlined,
      };
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
    this.service,
    this.opportunityRepository,
  });

  final ExchangeEventsService? service;
  final OpportunityRepository? opportunityRepository;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final ExchangeEventsService _service;
  late final bool _ownsService;
  late final OpportunityRepository _opportunities;
  late final PageController _pageController;

  HomeSection _section = HomeSection.events;
  var _exchangeIndex = 0;
  var _searchQuery = '';
  var _searchOpen = false;
  final _searchController = TextEditingController();

  static const _tabs = [
    Exchange.bybit,
    Exchange.binance,
    Exchange.okx,
    Exchange.upbit,
    Exchange.bithumb,
    Exchange.bitget,
  ];

  @override
  void initState() {
    super.initState();
    _ownsService = widget.service == null;
    _service = widget.service ?? ExchangeEventsService();
    _opportunities = widget.opportunityRepository ?? OpportunityRepository();
    _pageController = PageController(initialPage: _exchangeIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    if (_ownsService) {
      _service.close();
    }
    super.dispose();
  }

  Future<void> _pickSection() async {
    final selected = await showModalBottomSheet<HomeSection>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.card,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  '메뉴 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              for (final section in HomeSection.values)
                ListTile(
                  leading: Icon(section.icon, color: AppColors.brand),
                  title: Text(section.labelKo),
                  trailing: section == _section
                      ? const Icon(Icons.check_circle, color: AppColors.brand)
                      : null,
                  selected: section == _section,
                  onTap: () => Navigator.pop(context, section),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected == null || selected == _section) return;
    setState(() => _section = selected);
  }

  void _selectExchange(int index) {
    if (index == _exchangeIndex) return;
    setState(() => _exchangeIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEvents = _section == HomeSection.events;

    return Scaffold(
      backgroundColor: AppColors.page,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleSpacing: 12,
        title: _searchOpen && isEvents
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '이벤트 검색',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : InkWell(
                onTap: _pickSection,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.brand,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _section.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _section.shortLabelKo,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
        actions: [
          if (isEvents) ...[
            IconButton(
              tooltip: _searchOpen ? '검색 닫기' : '검색',
              onPressed: () {
                setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) {
                    _searchController.clear();
                    _searchQuery = '';
                  }
                });
              },
              icon: Icon(
                _searchOpen ? Icons.close : Icons.search,
                color: AppColors.ink,
              ),
            ),
            IconButton(
              tooltip: '알림',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 기능은 곧 제공됩니다.')),
                );
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.ink,
              ),
            ),
          ],
        ],
      ),
      body: isEvents
          ? Column(
              children: [
                _ExchangePillBar(
                  exchanges: _tabs,
                  selectedIndex: _exchangeIndex,
                  onSelected: _selectExchange,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _tabs.length,
                    onPageChanged: (index) {
                      setState(() => _exchangeIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return _ExchangeEventsPane(
                        exchange: _tabs[index],
                        service: _service,
                        opportunities: _opportunities,
                        searchQuery: _searchQuery,
                      );
                    },
                  ),
                ),
              ],
            )
          : const EarningScreen(),
    );
  }
}

class _ExchangePillBar extends StatelessWidget {
  const _ExchangePillBar({
    required this.exchanges,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<Exchange> exchanges;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        4,
        AppColors.contentInset,
        12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < exchanges.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              _ExchangePill(
                label: exchanges[i].labelKo,
                selected: i == selectedIndex,
                onTap: () => onSelected(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExchangePill extends StatelessWidget {
  const _ExchangePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brand : AppColors.chipIdle,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExchangeEventsPane extends StatefulWidget {
  const _ExchangeEventsPane({
    required this.exchange,
    required this.service,
    required this.opportunities,
    required this.searchQuery,
  });

  final Exchange exchange;
  final ExchangeEventsService service;
  final OpportunityRepository opportunities;
  final String searchQuery;

  @override
  State<_ExchangeEventsPane> createState() => _ExchangeEventsPaneState();
}

class _ExchangeEventsPaneState extends State<_ExchangeEventsPane>
    with AutomaticKeepAliveClientMixin {
  ExchangeEventsResult? _data;
  List<Opportunity> _allForExchange = const [];
  OpportunityType? _typeFilter;
  OpportunitySort _sort = OpportunitySort.endingSoon;
  Object? _error;
  bool _loading = true;
  bool _refreshing = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _error = null;
      if (_data == null && _allForExchange.isEmpty) {
        _loading = true;
      } else {
        _refreshing = true;
      }
    });

    try {
      final opps = await widget.opportunities.forExchange(widget.exchange);
      if (mounted) {
        setState(() {
          _allForExchange = opps;
          _loading = false;
        });
      }
    } catch (_) {}

    try {
      final result = await widget.service.loadEvents(
        widget.exchange,
        limit: 20,
        forceRefresh: forceRefresh,
        onCache: (cached) {
          if (!mounted) return;
          setState(() {
            _data = cached;
            _loading = false;
          });
        },
      );
      if (!mounted) return;
      setState(() {
        _data = result;
        _loading = false;
        _refreshing = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
        _refreshing = false;
      });
    }
  }

  List<Opportunity> get _filtered {
    final query = widget.searchQuery.trim().toLowerCase();
    var list = _allForExchange.where((o) {
      if (_typeFilter != null && o.type != _typeFilter) return false;
      if (query.isEmpty) return true;
      return o.titleKo.toLowerCase().contains(query) ||
          o.rewardLabel.toLowerCase().contains(query) ||
          o.eligibilityKo.toLowerCase().contains(query) ||
          o.type.labelKo.toLowerCase().contains(query);
    }).toList();

    switch (_sort) {
      case OpportunitySort.endingSoon:
        list.sort((a, b) {
          final ae = a.endsAt;
          final be = b.endsAt;
          if (ae == null && be == null) {
            return a.titleKo.compareTo(b.titleKo);
          }
          if (ae == null) return 1;
          if (be == null) return -1;
          return ae.compareTo(be);
        });
      case OpportunitySort.newest:
        list.sort((a, b) {
          final aa = a.asOf ?? a.reviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bb = b.asOf ?? b.reviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bb.compareTo(aa);
        });
    }
    return list;
  }

  Set<OpportunityType> get _availableTypes =>
      _allForExchange.map((o) => o.type).toSet();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.page,
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'refresh_${widget.exchange.name}',
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        tooltip: '새로고침',
        onPressed: _refreshing ? null : () => _load(forceRefresh: true),
        child: _refreshing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.refresh),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading && _data == null && _allForExchange.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.brand),
            SizedBox(height: 16),
            Text('이벤트 불러오는 중…'),
          ],
        ),
      );
    }

    if (_error != null &&
        _allForExchange.isEmpty &&
        (_data == null || _data!.items.isEmpty)) {
      return _ErrorView(
        message: _error.toString(),
        onRetry: () => _load(forceRefresh: true),
      );
    }

    final notices = _data?.items ?? const <ExchangeEvent>[];
    final filtered = _filtered;
    final activeCount = filtered
        .where((o) =>
            o.status == OpportunityStatus.live ||
            o.status == OpportunityStatus.endingSoon)
        .length;

    return RefreshIndicator(
      color: AppColors.brand,
      onRefresh: () => _load(forceRefresh: true),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          ExchangeBanner(exchange: widget.exchange),
          if (_allForExchange.isNotEmpty) ...[
            _TypeChipBar(
              available: _availableTypes,
              selected: _typeFilter,
              onSelected: (type) => setState(() => _typeFilter = type),
            ),
            _ListToolbar(
              count: activeCount,
              sort: _sort,
              onSortChanged: (sort) => setState(() => _sort = sort),
            ),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppColors.contentInset,
                  16,
                  AppColors.contentInset,
                  8,
                ),
                child: Text(
                  '조건에 맞는 이벤트가 없습니다.',
                  style: TextStyle(color: AppColors.muted),
                ),
              )
            else
              for (final item in filtered) OpportunityCard(opportunity: item),
          ] else
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppColors.contentInset,
                8,
                AppColors.contentInset,
                8,
              ),
              child: Text(
                '이 거래소의 큐레이션된 이벤트는 아직 없습니다. 아래 일반 공지를 확인하세요.',
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
            ),
          if (notices.isNotEmpty) ...[
            _NoticesHeader(
              exchange: widget.exchange,
              shown: notices.length,
              total: _data?.total ?? notices.length,
              fromCache: _data?.fromCache ?? false,
              fetchedAt: _data?.fetchedAt,
            ),
            for (final event in notices)
              EventCard(
                event: event,
                service: widget.service,
                exchange: widget.exchange,
              ),
          ],
        ],
      ),
    );
  }
}

class _TypeChipBar extends StatelessWidget {
  const _TypeChipBar({
    required this.available,
    required this.selected,
    required this.onSelected,
  });

  final Set<OpportunityType> available;
  final OpportunityType? selected;
  final ValueChanged<OpportunityType?> onSelected;

  @override
  Widget build(BuildContext context) {
    final types = OpportunityType.values
        .where((t) => available.contains(t))
        .toList(growable: false);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        14,
        AppColors.contentInset,
        4,
      ),
      child: Row(
        children: [
          _GuideChip(
            label: '전체',
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final type in types) ...[
            const SizedBox(width: 8),
            _GuideChip(
              label: type.labelKo,
              selected: selected == type,
              onTap: () => onSelected(selected == type ? null : type),
            ),
          ],
        ],
      ),
    );
  }
}

class _GuideChip extends StatelessWidget {
  const _GuideChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brand : AppColors.card,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.brand : AppColors.line,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListToolbar extends StatelessWidget {
  const _ListToolbar({
    required this.count,
    required this.sort,
    required this.onSortChanged,
  });

  final int count;
  final OpportunitySort sort;
  final ValueChanged<OpportunitySort> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        14,
        AppColors.contentInset,
        4,
      ),
      child: Row(
        children: [
          Text(
            '$count개 진행 중',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const Spacer(),
          PopupMenuButton<OpportunitySort>(
            initialValue: sort,
            onSelected: onSortChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: OpportunitySort.newest,
                child: Text('최신순'),
              ),
              PopupMenuItem(
                value: OpportunitySort.endingSoon,
                child: Text('마감 임박순'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Text(
                    sort == OpportunitySort.newest ? '최신순' : '마감 임박순',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticesHeader extends StatelessWidget {
  const _NoticesHeader({
    required this.exchange,
    required this.shown,
    required this.total,
    required this.fromCache,
    this.fetchedAt,
  });

  final Exchange exchange;
  final int shown;
  final int total;
  final bool fromCache;
  final DateTime? fetchedAt;

  static final _timeFormat = DateFormat('MM.dd HH:mm');

  @override
  Widget build(BuildContext context) {
    final source = fromCache ? '로컬 SQL 캐시' : '최신 조회';
    final fetchedLabel = fetchedAt == null
        ? ''
        : ' · 저장 ${_timeFormat.format(fetchedAt!.toLocal())}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        22,
        AppColors.contentInset,
        6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일반 공지',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${exchange.labelKo} · $source ($shown / 전체 $total)$fetchedLabel',
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.muted),
            const SizedBox(height: 12),
            const Text(
              '이벤트를 불러오지 못했습니다.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '프록시 서버가 실행 중인지 확인하세요.\n'
              'cd server && dart run bin/server.dart',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFB42318), fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: AppColors.brand),
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
