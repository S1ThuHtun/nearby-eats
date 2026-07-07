import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // サムネイル画像
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: () {
                  // logo_image が HotPepper の「画像なし」GIF の場合は photo にフォールバック
                  final isNoImage = restaurant.logoImage.contains('noimage');
                  final imageUrl =
                      (restaurant.logoImage.isNotEmpty && !isNoImage)
                      ? restaurant.logoImage
                      : restaurant.photo;
                  return imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null ? child : _PlaceholderBox(),
                          errorBuilder: (_, _, _) => _PlaceholderBox(),
                        )
                      : _PlaceholderBox();
                }(),
              ),

              const SizedBox(width: 12),

              // レストラン情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // レストラン名
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // ジャンルと予算を表示する行コンポーネントです。
                    Row(
                      children: [
                        if (restaurant.genre.isNotEmpty) ...[
                          Icon(
                            Icons.restaurant_menu,
                            size: 13,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            restaurant.genre,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                        if (restaurant.genre.isNotEmpty &&
                            restaurant.averageBudget.isNotEmpty)
                          Text(
                            '  ·  ',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        if (restaurant.averageBudget.isNotEmpty)
                          Flexible(
                            child: Text(
                              restaurant.averageBudget,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // 最寄り駅や徒歩時間などのアクセス情報です。
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 13,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            restaurant.access,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// サムネイルの読み込み中、または利用できない場合に表示されるグレーのプレースホルダーです。
class _PlaceholderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: AppTheme.divider,
      child: Icon(Icons.restaurant, color: AppTheme.textSecondary),
    );
  }
}
