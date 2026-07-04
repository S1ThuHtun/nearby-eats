import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';
import '../widgets/detail_screen_widgets/detail_divider.dart';
import '../widgets/detail_screen_widgets/hero_photo.dart';
import '../widgets/detail_screen_widgets/info_chip.dart';
import '../widgets/detail_screen_widgets/info_row.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  /// デバイスのブラウザで店舗の HotPepper ページを開きます。
  Future<void> _openUrl(BuildContext context) async {
    if (restaurant.urls.isEmpty) return;

    final uri = Uri.parse(restaurant.urls);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ページを開けませんでした。')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name, overflow: TextOverflow.ellipsis),
      ),

      // HotPepper の店舗ページへ遷移するリンクボタン
      bottomNavigationBar: restaurant.urls.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: ElevatedButton.icon(
                  onPressed: () => _openUrl(context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('HotPepperで詳細を見る'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // レストランの画像 (Hero Photo)
            HeroPhoto(url: restaurant.photo),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ジャンルと予算を表示するチップ（Chip）コンポーネント
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      if (restaurant.genre.isNotEmpty)
                        InfoChip(
                          icon: Icons.restaurant_menu,
                          label: restaurant.genre,
                          color: AppTheme.primary,
                        ),

                      // 平均予算
                      if (restaurant.averageBudget.isNotEmpty)
                        InfoChip(
                          icon: Icons.payments_outlined,
                          label: restaurant.averageBudget,
                          color: AppTheme.textSecondary,
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 予算カテゴリ名
                  if (restaurant.budgetName.isNotEmpty) ...[
                    InfoRow(
                      icon: Icons.payments_outlined,
                      label: '平均予算',
                      value: restaurant.budgetName,
                    ),
                    const DetailDivider(),
                  ],

                  // 住所
                  if (restaurant.address.isNotEmpty) ...[
                    InfoRow(
                      icon: Icons.place_outlined,
                      label: '住所',
                      value: restaurant.address,
                    ),
                    const DetailDivider(),
                  ],

                  // 最寄り駅のアクセス情報
                  if (restaurant.access.isNotEmpty) ...[
                    InfoRow(
                      icon: Icons.directions_walk,
                      label: 'アクセス',
                      value: restaurant.access,
                    ),
                    const DetailDivider(),
                  ],

                  // 営業時間
                  if (restaurant.open.isNotEmpty) ...[
                    InfoRow(
                      icon: Icons.access_time,
                      label: '営業時間',
                      value: restaurant.open,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
