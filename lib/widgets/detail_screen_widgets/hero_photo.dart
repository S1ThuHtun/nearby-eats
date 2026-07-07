// 詳細画面の上部に表示するレストランの大きな写真です。
// URL が空、読み込みに失敗、または noimage GIF の場合はグレーのプレースホルダーを表示します。

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HeroPhoto extends StatelessWidget {
  const HeroPhoto({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final isNoImage = url.contains('noimage');
    if (url.isEmpty || isNoImage) {
      return _buildPlaceholder();
    }

    return Image.network(
      url,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : _buildPlaceholder(),
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
