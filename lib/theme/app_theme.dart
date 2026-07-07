import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF26215C);
  static const accent = Color(0xFFFF6B35);
  static const background = Color(0xFFF8F7FF);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B6B8A);
  static const divider = Color(0xFFE0DFEE);

  /// MaterialApp が利用している基本テーマ（ThemeData）を返します。
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    // mPlusRounded1cTextTheme フォントをアプリ全体に適用します。
    textTheme: GoogleFonts.mPlusRounded1cTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: surface,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,

    // AppBarの設計テーマ
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      // AppBarのタイトルにKaushan Scriptフォントを適用します。
      titleTextStyle: GoogleFonts.kaushanScript(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // ボタンの色と設計
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    ),

    // レストランの一覧表示のカード設計
    cardTheme: const CardThemeData(
      color: surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    ),

    // 検索エリアの設計
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
