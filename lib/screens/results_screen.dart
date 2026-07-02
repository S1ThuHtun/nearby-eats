import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_eats/models/restaurant.dart';

class ResultsScreen extends StatelessWidget {
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
  final List<Restaurant>
  initialRestaurants; // Search Screenから渡される1ページ目のデータ (20個の店舗)
  final int total; // APIが返す総件数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('検索結果')),
      body: ListView(
        children: [
          Text(position.toString()),
          Text(range.toString()),
          Text(keyword.toString()),
          Text(initialRestaurants.toString()),
          Text(total.toString()),
        ],
      ),
    );
  }
}
