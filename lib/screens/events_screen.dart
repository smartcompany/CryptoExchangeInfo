import 'dart:async';

import 'package:flutter/material.dart';

import '../models/exchange_event.dart';
import '../models/opportunity.dart';
import '../services/exchange_event_fetchers.dart';
import '../services/exchange_events_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_labels.dart';
import '../services/opportunity_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/event_card.dart';
import '../widgets/exchange_banner.dart';
import '../widgets/opportunity_card.dart';
import 'earning_screen.dart';

enum HomeSection { events, contests, earning }

enum OpportunitySort { endingSoon, newest }

extension HomeSectionX on HomeSection {
  String label(AppLocalizations l10n) => switch (this) {
    HomeSection.events => l10n.sectionEvents,
    HomeSection.contests => l10n.typeTradingContest,
    HomeSection.earning => l10n.sectionEarning,
  };

  String shortLabel(AppLocalizations l10n) => switch (this) {
    HomeSection.events => l10n.sectionEvents,
    HomeSection.contests => l10n.typeTradingContest,
    HomeSection.earning => l10n.sectionEarningShort,
  };

  IconData get icon => switch (this) {
    HomeSection.events => Icons.campaign_outlined,
    HomeSection.contests => Icons.emoji_events_outlined,
    HomeSection.earning => Icons.savings_outlined,
  };
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key, this.service, this.opportunityRepository});

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
    Exchange.binance,
    Exchange.okx,
    Exchange.bybit,
    Exchange.gate,
    Exchange.mexc,
    Exchange.bitget,
    Exchange.kucoin,
    Exchange.coinbase,
    Exchange.htx,
    Exchange.upbit,
    Exchange.bithumb,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  AppLocalizations.of(context).menuSelect,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              for (final section in HomeSection.values)
                ListTile(
                  leading: Icon(section.icon, color: AppColors.brand),
                  title: Text(section.label(AppLocalizations.of(context))),
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
    setState(() {
      _section = selected;
      _searchOpen = false;
      _searchController.clear();
      _searchQuery = '';
    });
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
    final l10n = AppLocalizations.of(context);
    final showSearch =
        _section == HomeSection.events || _section == HomeSection.contests;

    return Scaffold(
      backgroundColor: AppColors.page,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleSpacing: 12,
        title: _searchOpen && showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchEventsHint,
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
                      child: Icon(_section.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _section.shortLabel(l10n),
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
          if (showSearch) ...[
            IconButton(
              tooltip: _searchOpen
                  ? l10n.searchCloseTooltip
                  : l10n.searchTooltip,
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
              tooltip: l10n.notificationsTooltip,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsComingSoon)),
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
      body: switch (_section) {
        HomeSection.events => Column(
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
                      active: index == _exchangeIndex,
                    );
                  },
                ),
              ),
            ],
          ),
        HomeSection.contests => _TradingContestsPane(
            opportunities: _opportunities,
            searchQuery: _searchQuery,
            active: true,
          ),
        HomeSection.earning => const EarningScreen(),
      },
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
                label: AppLocalizations.of(context).exchangeName(exchanges[i]),
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

class _TradingContestsPane extends StatefulWidget {
  const _TradingContestsPane({
    required this.opportunities,
    required this.searchQuery,
    required this.active,
  });

  final OpportunityRepository opportunities;
  final String searchQuery;
  final bool active;

  @override
  State<_TradingContestsPane> createState() => _TradingContestsPaneState();
}

class _TradingContestsPaneState extends State<_TradingContestsPane>
    with AutomaticKeepAliveClientMixin {
  List<Opportunity> _items = const [];
  OpportunitySort _sort = OpportunitySort.endingSoon;
  Object? _error;
  bool _loading = false;
  bool _started = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _startLoad();
    }
  }

  @override
  void didUpdateWidget(covariant _TradingContestsPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _startLoad();
    }
  }

  Future<void> _startLoad({bool forceRefresh = false}) async {
    if (_started && !forceRefresh) return;
    _started = true;
    await _load(forceRefresh: forceRefresh);
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _error = null;
      if (_items.isEmpty) _loading = true;
    });

    try {
      final items = await widget.opportunities.forType(
        OpportunityType.tradingContest,
        forceRefresh: forceRefresh,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  List<Opportunity> _filtered(AppLocalizations l10n) {
    final query = widget.searchQuery.trim().toLowerCase();
    var list = _items.where((o) {
      if (query.isEmpty) return true;
      return o.titleKo.toLowerCase().contains(query) ||
          o.rewardLabel.toLowerCase().contains(query) ||
          o.eligibilityKo.toLowerCase().contains(query) ||
          l10n.exchangeNameFor(o.exchange).toLowerCase().contains(query);
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
          final aa =
              a.asOf ?? a.reviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bb =
              b.asOf ?? b.reviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bb.compareTo(aa);
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);

    if (!_started) return const SizedBox.shrink();

    if (_loading && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.brand),
            const SizedBox(height: 16),
            Text(l10n.loadingEvents),
          ],
        ),
      );
    }

    if (_error != null && _items.isEmpty) {
      return _ErrorView(
        message: _error.toString(),
        onRetry: () => _startLoad(forceRefresh: true),
      );
    }

    final items = _filtered(l10n);
    final activeCount = items
        .where(
          (o) =>
              o.status == OpportunityStatus.live ||
              o.status == OpportunityStatus.endingSoon,
        )
        .length;

    return RefreshIndicator(
      color: AppColors.brand,
      onRefresh: () => _startLoad(forceRefresh: true),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const _ContestsHubBanner(),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppColors.contentInset,
                16,
                AppColors.contentInset,
                8,
              ),
              child: Text(
                l10n.noContests,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
            )
          else ...[
            _ListToolbar(
              count: activeCount,
              sort: _sort,
              onSortChanged: (sort) => setState(() => _sort = sort),
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppColors.contentInset,
                  16,
                  AppColors.contentInset,
                  8,
                ),
                child: Text(
                  l10n.noMatchingItems,
                  style: const TextStyle(color: AppColors.muted),
                ),
              )
            else
              for (final item in items)
                OpportunityCard(
                  key: ValueKey(item.id),
                  opportunity: item,
                ),
          ],
        ],
      ),
    );
  }
}

class _ContestsHubBanner extends StatelessWidget {
  const _ContestsHubBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.contentInset,
        12,
        AppColors.contentInset,
        4,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bannerStart,
              AppColors.bannerMid,
              AppColors.bannerEnd,
            ],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contestsHubTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.contestsHubBody,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
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
    required this.active,
  });

  final Exchange exchange;
  final ExchangeEventsService service;
  final OpportunityRepository opportunities;
  final String searchQuery;
  final bool active;

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
  bool _loading = false;
  bool _loadingMore = false;
  bool _started = false;
  late final ScrollController _scrollController;
  /// Footer-only updates (avoid rebuilding every card while loading more).
  late final ValueNotifier<bool> _footerLoadingMore;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _footerLoadingMore = ValueNotifier(false);
    _scrollController = ScrollController()..addListener(_onScroll);
    if (widget.active) {
      _startLoad();
    }
  }

  @override
  void didUpdateWidget(covariant _ExchangeEventsPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _startLoad();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _footerLoadingMore.dispose();
    super.dispose();
  }

  void _setFooterLoadingMore(bool value) {
    _loadingMore = value;
    if (_footerLoadingMore.value != value) {
      _footerLoadingMore.value = value;
    }
  }

  Future<void> _startLoad({bool forceRefresh = false}) async {
    if (_started && !forceRefresh) return;
    _started = true;
    await _load(forceRefresh: forceRefresh);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_loading || _loadingMore) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    // Short lists (maxScrollExtent ~= 0) would otherwise always trip load-more
    // and loop forever when an API repeats the same page (Bitget).
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels < position.maxScrollExtent - 480) return;
    _loadMore();
  }

  /// Applying list updates mid-fling makes iOS bounce/jump the viewport upward.
  Future<void> _waitForScrollIdle() async {
    if (!_scrollController.hasClients) return;
    final scrolling = _scrollController.position.isScrollingNotifier;
    if (!scrolling.value) return;

    final done = Completer<void>();
    void listener() {
      if (!scrolling.value && !done.isCompleted) {
        done.complete();
      }
    }

    scrolling.addListener(listener);
    try {
      await Future.any([
        done.future,
        Future<void>.delayed(const Duration(milliseconds: 900)),
      ]);
    } finally {
      scrolling.removeListener(listener);
    }
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _error = null;
      if (_data == null && _allForExchange.isEmpty) {
        _loading = true;
      }
    });

    final oppsFuture = widget.opportunities.forExchange(widget.exchange).then((
      opps,
    ) {
      if (!mounted) return;
      setState(() {
        _allForExchange = opps;
        if (_data != null) _loading = false;
      });
    }).catchError((_) {});

    try {
      final result = await widget.service.loadEvents(
        widget.exchange,
        limit: ExchangeEventFetchers.defaultPageSize,
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
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }

    await oppsFuture;
    if (mounted && _loading) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    final current = _data;
    if (current == null ||
        _loading ||
        _loadingMore ||
        !current.hasMore ||
        current.items.length >= ExchangeEventFetchers.maxItems) {
      return;
    }

    _setFooterLoadingMore(true);
    try {
      final result = await widget.service.loadMoreEvents(
        widget.exchange,
        current: current.items,
        nextPage: current.page + 1,
      );
      if (!mounted) return;
      await _waitForScrollIdle();
      if (!mounted) return;
      final keepPixels = _scrollController.hasClients
          ? _scrollController.position.pixels
          : null;
      setState(() {
        _data = result;
      });
      _setFooterLoadingMore(false);
      if (keepPixels != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_scrollController.hasClients) return;
          final max = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(keepPixels.clamp(0.0, max));
        });
      }
    } catch (_) {
      if (!mounted) return;
      _setFooterLoadingMore(false);
    }
  }

  List<ExchangeEvent> get _notices {
    final items = _data?.items ?? const <ExchangeEvent>[];
    final query = widget.searchQuery.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items
        .where(
          (e) =>
              e.displayTitle.toLowerCase().contains(query) ||
              e.displayDescription.toLowerCase().contains(query) ||
              e.displayTags.any((t) => t.toLowerCase().contains(query)),
        )
        .toList();
  }

  List<Opportunity> _filteredOpportunities(AppLocalizations l10n) {
    if (_typeFilter == OpportunityType.event) return const [];
    final query = widget.searchQuery.trim().toLowerCase();
    var list = _allForExchange.where((o) {
      if (_typeFilter != null && o.type != _typeFilter) return false;
      if (query.isEmpty) return true;
      return o.titleKo.toLowerCase().contains(query) ||
          o.rewardLabel.toLowerCase().contains(query) ||
          o.eligibilityKo.toLowerCase().contains(query) ||
          l10n.opportunityTypeLabel(o.type).toLowerCase().contains(query);
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
          final aa =
              a.asOf ?? a.reviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bb =
              b.asOf ?? b.reviewedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bb.compareTo(aa);
        });
    }
    return list;
  }

  bool get _showNotices {
    if (_typeFilter == null) return true;
    return _typeFilter == OpportunityType.event;
  }

  Set<OpportunityType> get _availableTypes {
    final types = _allForExchange.map((o) => o.type).toSet();
    if ((_data?.items.isNotEmpty ?? false)) {
      types.add(OpportunityType.event);
    }
    return types;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.page,
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (!_started) {
      return const SizedBox.shrink();
    }

    if (_loading && _data == null && _allForExchange.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.brand),
            const SizedBox(height: 16),
            Text(l10n.loadingEvents),
          ],
        ),
      );
    }

    if (_error != null &&
        _allForExchange.isEmpty &&
        (_data == null || _data!.items.isEmpty)) {
      return _ErrorView(
        message: _error.toString(),
        onRetry: () => _startLoad(forceRefresh: true),
      );
    }

    final notices = _showNotices ? _notices : const <ExchangeEvent>[];
    final opportunities = _filteredOpportunities(l10n);
    final hasFeed =
        _allForExchange.isNotEmpty || (_data?.items.isNotEmpty ?? false);
    final activeCount = _typeFilter == OpportunityType.event
        ? notices.length
        : opportunities
                  .where(
                    (o) =>
                        o.status == OpportunityStatus.live ||
                        o.status == OpportunityStatus.endingSoon,
                  )
                  .length +
              (_typeFilter == null ? notices.length : 0);

    return RefreshIndicator(
      color: AppColors.brand,
      onRefresh: () => _startLoad(forceRefresh: true),
      child: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          children: [
          ExchangeBanner(exchange: widget.exchange),
          if (hasFeed) ...[
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
            if (opportunities.isEmpty && notices.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppColors.contentInset,
                  16,
                  AppColors.contentInset,
                  8,
                ),
                child: Text(
                  l10n.noMatchingItems,
                  style: const TextStyle(color: AppColors.muted),
                ),
              )
            else ...[
              for (final item in opportunities)
                OpportunityCard(
                  key: ValueKey(item.id),
                  opportunity: item,
                ),
              for (final event in notices)
                EventCard(
                  key: ValueKey(event.url),
                  event: event,
                  service: widget.service,
                  exchange: widget.exchange,
                ),
              // Fixed-height sentinel so load-more spinner/text doesn't
              // change scroll extent mid-fling (iOS jump-back).
              if ((_data?.hasMore ?? false) || _loadingMore)
                ValueListenableBuilder<bool>(
                  valueListenable: _footerLoadingMore,
                  builder: (context, loadingMore, _) {
                    return SizedBox(
                      height: 72,
                      child: Center(
                        child: loadingMore
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.brand,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    );
                  },
                ),
            ],
          ] else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppColors.contentInset,
                8,
                AppColors.contentInset,
                8,
              ),
              child: Text(
                l10n.noEvents,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
            ),
        ],
        ),
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
    final l10n = AppLocalizations.of(context);
    // Keep Event immediately after All, then remaining types.
    final types = <OpportunityType>[
      if (available.contains(OpportunityType.event)) OpportunityType.event,
      ...OpportunityType.values.where(
        (t) => t != OpportunityType.event && available.contains(t),
      ),
    ];

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
            label: l10n.filterAll,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final type in types) ...[
            const SizedBox(width: 8),
            _GuideChip(
              label: l10n.opportunityTypeLabel(type),
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
    final l10n = AppLocalizations.of(context);
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
            l10n.activeCount(count),
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
            itemBuilder: (context) => [
              PopupMenuItem(
                value: OpportunitySort.newest,
                child: Text(l10n.sortNewest),
              ),
              PopupMenuItem(
                value: OpportunitySort.endingSoon,
                child: Text(l10n.sortEndingSoon),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Text(
                    sort == OpportunitySort.newest
                        ? l10n.sortNewest
                        : l10n.sortEndingSoon,
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(
              l10n.eventsLoadFailed,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.networkRetryHint,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
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
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
