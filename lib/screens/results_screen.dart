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
    required this.initialRestaurants,
    required this.total,
  });

  final Position position;
  final int range;
  final String keyword;
  final List<Restaurant> initialRestaurants; // Search Screenから渡される1ページ目のデータ
  final int total; // APIが返す総件数

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final HotpepperService _service = HotpepperService();
  final ScrollController _scrollController = ScrollController();

  late final List<Restaurant> _restaurants;
  late int _total;
  int _currentStart = 1 + Constants.resultsPerPage; // 2ページ目から始まる
  bool _isLoadingMore = false; // ページネーション中フラグ

  @override
  void initState() {
    super.initState();
    // Search Screenから渡された1ページ目のデータをそのまま使う
    _restaurants = List.of(widget.initialRestaurants);
    _total = widget.total;
    // スクロールイベントを監視して、ページネーションを発火させます。
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// ユーザーがリストの最下部に到達した際に、次の結果ページを読み込みます。
  void _onScroll() {
    final isAtBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    final hasMore = _restaurants.length < _total;

    if (isAtBottom && hasMore && !_isLoadingMore) {
      _fetchMoreRestaurants();
    }
  }

  /// 次のページを取得し、既存のリストに 20 件の結果を追加します。
  Future<void> _fetchMoreRestaurants() async {
    setState(() => _isLoadingMore = true);
    try {
      final result = await _service.searchRestaurants(
        position: widget.position,
        range: widget.range,
        keyword: widget.keyword,
        start: _currentStart,
      );
      setState(() {
        _restaurants.addAll(result['shops'] as List<Restaurant>);
        _currentStart += Constants.resultsPerPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('追加の読み込みに失敗しました。')));
      }
    }
  }

  /// 現在の範囲値に対応する半径ラベル文字列を返します。
  String get _rangeLabel {
    final option = Constants.radiusOptions.firstWhere(
      (o) => o['value'] == widget.range,
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
          preferredSize: const Size.fromHeight(20),
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
    // レストランが見つからなかった場合に、空の状態（empty state）を表示します。
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
      itemCount: _restaurants.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // 追加読み込み中に、リスト末尾へスピナー（読み込み中インジケーター）を表示します。
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
