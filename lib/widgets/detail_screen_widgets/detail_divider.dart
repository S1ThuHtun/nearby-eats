// 詳細画面(detail_screen.dart)の情報行同士の区切りとして使用する横方向の仕切り線

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DetailDivider extends StatelessWidget {
  const DetailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppTheme.divider, height: 1);
  }
}
