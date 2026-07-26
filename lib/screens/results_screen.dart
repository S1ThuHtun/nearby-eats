import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/restaurant.dart';
import '../services/hotpepper_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/restaurant_card.dart';
import 'detail_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    super.key,
    required this.position,
    required this.range,
    required this.keyword,
  });

  final Position position;
  final int range;
  final String keyword;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final HotpepperService _service = HotpepperService();
  final ScrollController _scrollController = ScrollController();

  final List<Restaurant> _restaurants = [];
  int _total = 0;
  late int _currentRange;
  int _currentStart = 1 + Constants.resultsPerPage; // 2ページ目から始まる
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentRange = widget.range;
    _scrollController.addListener(_onScroll);
    _fetchInitialRestaurants();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 1ページ目を取得し、0件の場合は範囲拡大ダイアログを表示する
  Future<void> _fetchInitialRestaurants() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _restaurants.clear();
    });

    try {
      final result = await _service.searchRestaurants(
        position: widget.position,
        range: _currentRange,
        keyword: widget.keyword,
        start: 1,
      );

      final shops = result['shops'] as List<Restaurant>;
      final total = result['total'] as int;

      // 0件の場合、次の検索範囲への拡大を提案する
      if (total == 0 && mounted) {
        final currentIndex = Constants.radiusOptions.indexWhere(
          (o) => o['value'] == _currentRange,
        );
        final hasNextRange = currentIndex < Constants.radiusOptions.length - 1;

        if (hasNextRange) {
          final nextOption = Constants.radiusOptions[currentIndex + 1];
          final nextLabel = nextOption['label'] as String;
          final nextRange = nextOption['value'] as int;

          final expand = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actionsOverflowButtonSpacing: 8,
              title: const Text('レストランが見つかりませんでした'),
              content: Text.rich(
                TextSpan(
                  text: '検索範囲を',
                  children: [
                    TextSpan(
                      text: nextLabel,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: 'に広げて再検索しますか？'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'キャンセル',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('広げて再検索'),
                ),
              ],
            ),
          );

          if (expand == true) {
            setState(() => _currentRange = nextRange);
            await _fetchInitialRestaurants();
            return;
          }
        }
      }

      if (mounted) {
        setState(() {
          _restaurants.addAll(shops);
          _total = total;
          _currentStart = 1 + Constants.resultsPerPage;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// ユーザーがリストの末尾までスクロールした際に、次のページの結果を読み込む
  void _onScroll() {
    final isAtBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    final hasMore = _restaurants.length < _total;

    if (isAtBottom && hasMore && !_isLoadingMore) {
      _fetchMoreRestaurants();
    }
  }

  /// 次のページを取得し、既存のリストに結果を追加します
  Future<void> _fetchMoreRestaurants() async {
    setState(() => _isLoadingMore = true);
    try {
      final result = await _service.searchRestaurants(
        position: widget.position,
        range: _currentRange,
        keyword: widget.keyword,
        start: _currentStart,
      );
      setState(() {
        _restaurants.addAll(result['shops'] as List<Restaurant>);
        _currentStart += Constants.resultsPerPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('追加の読み込みに失敗しました。')));
      }
    }
  }

  /// 現在の range 値に対応する半径ラベル文字列を返します
  String get _rangeLabel {
    final option = Constants.radiusOptions.firstWhere(
      (o) => o['value'] == _currentRange,
      orElse: () => {'label': ''},
    );
    return option['label'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索結果'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$_total件 ・ 半径$_rangeLabel',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchInitialRestaurants,
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    if (_restaurants.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant, size: 48, color: AppTheme.textSecondary),
            SizedBox(height: 12),
            Text('該当するレストランが見つかりませんでした。'),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      // ページネーション中に、下部へ表示するローディングインジケーターを追加します
      itemCount: _restaurants.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // 追加読み込み中は、リスト末尾にスピナー（読み込み中インジケーター）を表示します
        if (index == _restaurants.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final restaurant = _restaurants[index];
        return RestaurantCard(
          restaurant: restaurant,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(restaurant: restaurant),
            ),
          ),
        );
      },
    );
  }
}
