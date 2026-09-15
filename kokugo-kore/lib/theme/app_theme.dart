import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0xFFF39C12);
const kPrimaryDark = Color(0xFFD68910);
const kPrimaryDeep = Color(0xFFBA4A00);

// アクセントカラー
const kAccentGreen = Color(0xFF27AE60);
const kAccentRed = Color(0xFFE74C3C);
const kAccentBlue = Color(0xFF2980B9);
const kAccentTeal = Color(0xFF16A085);
const kAccentOrange = Color(0xFFE67E22);
const kAccentPurple = Color(0xFF8E44AD);
const kAccentPink = Color(0xFFE91E8C);
const kAccentDarkRed = Color(0xFFC0392B);

// ニュートラルカラー（Light）
const kBgLight = Color(0xFFF5F5F5);
const kBgLight2 = Color(0xFFFFFFFF);
const kTextDark = Color(0xFF2C3E50);
const kTextMuted = Color(0xFF7F8C8D);

// ニュートラルカラー（Dark）
const kBgDark = Color(0xFF121212);
const kBgDark2 = Color(0xFF1E1E1E);
const kTextLight = Color(0xFFEFEFEF);
const kTextLightMuted = Color(0xFFB0B0B0);

ThemeData buildAppTheme() {
  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      primary: kPrimaryColor,
      secondary: kAccentGreen,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: kBgLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: kTextMuted,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.notoSansJpTextTheme(baseTheme.textTheme).copyWith(
      headlineLarge: GoogleFonts.notoSansJp(fontSize: 28, fontWeight: FontWeight.bold, color: kTextDark),
      headlineMedium: GoogleFonts.notoSansJp(fontSize: 22, fontWeight: FontWeight.bold, color: kTextDark),
      headlineSmall: GoogleFonts.notoSansJp(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark),
      bodyLarge: GoogleFonts.notoSansJp(fontSize: 16, color: kTextDark),
      bodyMedium: GoogleFonts.notoSansJp(fontSize: 14, color: kTextDark),
      bodySmall: GoogleFonts.notoSansJp(fontSize: 12, color: kTextMuted),
    ),
  );
}

ThemeData buildDarkAppTheme() {
  final baseDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      brightness: Brightness.dark,
      primary: kPrimaryColor,
      secondary: kAccentGreen,
      surface: kBgDark2,
    ),
    scaffoldBackgroundColor: kBgDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: kAccentGreen,
      unselectedItemColor: kTextLightMuted,
      backgroundColor: kBgDark2,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: kBgDark2,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  return baseDarkTheme.copyWith(
    textTheme: GoogleFonts.notoSansJpTextTheme(baseDarkTheme.textTheme).copyWith(
      headlineLarge: GoogleFonts.notoSansJp(fontSize: 28, fontWeight: FontWeight.bold, color: kTextLight),
      headlineMedium: GoogleFonts.notoSansJp(fontSize: 22, fontWeight: FontWeight.bold, color: kTextLight),
      headlineSmall: GoogleFonts.notoSansJp(fontSize: 18, fontWeight: FontWeight.bold, color: kTextLight),
      bodyLarge: GoogleFonts.notoSansJp(fontSize: 16, color: kTextLight),
      bodyMedium: GoogleFonts.notoSansJp(fontSize: 14, color: kTextLightMuted),
      bodySmall: GoogleFonts.notoSansJp(fontSize: 12, color: kTextLightMuted),
    ),
  );
}

// 学年グループ
enum GradeGroup { low, mid, high }

GradeGroup gradeGroupOf(int grade) {
  if (grade <= 2) return GradeGroup.low;
  if (grade <= 4) return GradeGroup.mid;
  return GradeGroup.high;
}

Color gradeColor(GradeGroup g) {
  switch (g) {
    case GradeGroup.low: return const Color(0xFFF39C12);
    case GradeGroup.mid: return const Color(0xFF27AE60);
    case GradeGroup.high: return const Color(0xFF2980B9);
  }
}

String gradeLabel(GradeGroup g) {
  switch (g) {
    case GradeGroup.low: return '低学年';
    case GradeGroup.mid: return '中学年';
    case GradeGroup.high: return '高学年';
  }
}
