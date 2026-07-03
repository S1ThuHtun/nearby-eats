import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  /// レストランの HotPepper 掲載ページを端末のブラウザで開きます。
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // レストランの画像 (Hero Photo)
            _HeroPhoto(url: restaurant.photo),

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
                    runSpacing: 8,
                    children: [
                      if (restaurant.genre.isNotEmpty)
                        _InfoChip(
                          icon: Icons.restaurant_menu,
                          label: restaurant.genre,
                          color: AppTheme.primary,
                        ),
                      if (restaurant.budget.isNotEmpty)
                        _InfoChip(
                          icon: Icons.payments_outlined,
                          label: restaurant.budget,
                          color: AppTheme.textSecondary,
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const _Divider(),

                  // 住所
                  if (restaurant.address.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.place_outlined,
                      label: '住所',
                      value: restaurant.address,
                    ),
                    const _Divider(),
                  ],

                  // 最寄り駅のアクセス情報
                  if (restaurant.access.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.directions_walk,
                      label: 'アクセス',
                      value: restaurant.access,
                    ),
                    const _Divider(),
                  ],

                  // 営業時間
                  if (restaurant.open.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.access_time,
                      label: '営業時間',
                      value: restaurant.open,
                    ),
                    const _Divider(),
                  ],

                  const SizedBox(height: 24),

                  // HotPepper の店舗ページへ遷移するリンクボタン
                  if (restaurant.urls.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => _openUrl(context),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('HotPepperで詳細を見る'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Private widgets

/// 画面上部にレストランの大きな写真を表示します。
///
/// 写真 URL が空、または読み込みに失敗した場合はグレーのプレースホルダーを表示します。
class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final isNoImage = url.contains('noimage');
    if (url.isEmpty || isNoImage) {
      return Container(
        height: 220,
        color: AppTheme.divider,
        child: const Icon(
          Icons.restaurant,
          size: 64,
          color: AppTheme.textSecondary,
        ),
      );
    }

    return Image.network(
      url,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,

      // 読み込み中はグレーのボックスを表示
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : _buildPlaceholder(),

      // エラー発生時もグレーのボックスを表示
      errorBuilder: (_, _, _) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 220,
      color: AppTheme.divider,
      child: const Icon(
        Icons.restaurant,
        size: 64,
        color: AppTheme.textSecondary,
      ),
    );
  }
}

/// アイコンとラベル（ジャンル、予算など）を表示する小さなカラー付きチップです。
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// アイコン、太字のラベル、値を 1 行でまとめて表示する行コンポーネントです。
///
/// 住所・アクセス・営業時間などの情報表示に使用されます。
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 情報行の間に挿入する細い横仕切り線です。
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppTheme.divider, height: 1);
  }
}
