import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/restaurant.dart';
import '../services/hotpepper_service.dart';
import '../widgets/search_screen_widgets/location_card.dart';
import '../widgets/search_screen_widgets/radius_selector.dart';
import '../widgets/search_screen_widgets/section_label.dart';
import 'results_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HotpepperService _service = HotpepperService();
  final TextEditingController _keywordController = TextEditingController();

  Position? _currentPosition;
  int _selectedRange = 3;
  bool _isLoadingLocation = false;
  String? _locationError;
  bool _isSearching = false;
  String? _searchError;

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final position = await _service.getCurrentLocation();
      setState(() => _currentPosition = position);
    } catch (e) {
      setState(() => _locationError = e.toString());
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  /// 検索ボタン押下時: APIを呼び出し、結果をResults Screenに渡す。
  Future<void> _search() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('先に現在地を取得してください。')));
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      // キーワードを変数に保持して複数箇所で同じ値を使う
      final keyword = _keywordController.text.trim();

      // 検索ボタン押下時に1ページ目を取得する
      final result = await _service.searchRestaurants(
        position: _currentPosition!,
        range: _selectedRange,
        keyword: keyword,
        start: 1,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            position: _currentPosition!,
            range: _selectedRange,
            keyword: keyword,
            initialRestaurants: result['shops'] as List<Restaurant>,
            total: result['total'] as int,
          ),
        ),
      );
    } catch (e) {
      setState(() => _searchError = e.toString());
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NEARBY EATS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),

            // ── 現在地セクション
            SectionLabel(label: '現在地'),
            const SizedBox(height: 8),
            LocationCard(
              position: _currentPosition,
              isLoading: _isLoadingLocation,
              error: _locationError,
              onTap: _getLocation,
            ),

            const SizedBox(height: 24),

            // ── 検索半径セクション
            SectionLabel(label: '検索範囲'),
            const SizedBox(height: 8),
            RadiusSelector(
              selected: _selectedRange,
              onChanged: (value) => setState(() => _selectedRange = value),
            ),

            const SizedBox(height: 24),

            // ── キーワード（任意）セクション
            SectionLabel(label: 'キーワード（任意）'),
            const SizedBox(height: 8),
            TextField(
              controller: _keywordController,
              decoration: const InputDecoration(
                hintText: '例：焼肉、寿司、個室',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 36),

            // ── 検索ボタン
            ElevatedButton.icon(
              onPressed: _isSearching ? null : _search,
              icon: _isSearching
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.restaurant),
              label: Text(
                _isSearching ? '検索中...' : 'レストランを検索',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            // 検索エラーが発生した場合に表示する
            if (_searchError != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _searchError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
