import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
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
  final LocationService _locationService = LocationService();
  final TextEditingController _keywordController = TextEditingController();

  Position? _currentPosition; // 取得した GPS 位置情報を保持
  int _selectedRange = 3; // デフォルトの検索半径 => 1km（HotPepper の range 値 3）
  bool _isLoadingLocation = false;
  String? _locationError;

  /// GPS の利用許可をリクエストし、現在位置を取得
  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      if (!mounted) return;
      setState(() => _currentPosition = position);
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationError = e.toString());
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  /// 検索ボタン押下時: 入力値を Results Screen に渡してナビゲートする。
  void _search() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('先に現在地を取得してください。')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          position: _currentPosition!,
          range: _selectedRange,
          keyword: _keywordController.text.trim(),
        ),
      ),
    );
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

            // 現在地セクション
            SectionLabel(label: '現在地'),
            const SizedBox(height: 8),
            LocationCard(
              position: _currentPosition,
              isLoading: _isLoadingLocation,
              error: _locationError,
              onTap: _getLocation,
            ),

            const SizedBox(height: 24),

            // 検索半径セクション
            SectionLabel(label: '検索範囲'),
            const SizedBox(height: 8),
            RadiusSelector(
              selected: _selectedRange,
              onChanged: (value) => setState(() => _selectedRange = value),
            ),

            const SizedBox(height: 24),

            // キーワード（任意）セクション
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

            // 検索ボタン
            ElevatedButton.icon(
              onPressed: _search,
              icon: const Icon(Icons.restaurant),
              label: const Text(
                'レストランを検索',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
