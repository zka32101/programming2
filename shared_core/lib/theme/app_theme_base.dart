import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBgLight = Color(0xFFF5F5F5);
const kTextDark = Color(0xFF2C3E50);
const kTextMuted = Color(0xFF7F8C8D);
const kAccentGreen = Color(0xFF27AE60);
const kAccentRed = Color(0xFFE74C3C);
const kAccentBlue = Color(0xFF2980B9);

ThemeData buildAppTheme({
  required Color primaryColor,
  Color? secondaryColor,
  Color bgColor = kBgLight,
}) {
  final secondary = secondaryColor ?? kAccentGreen;

  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondary,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: bgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
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
      headlineLarge: GoogleFonts.notoSansJp(
          fontSize: 28, fontWeight: FontWeight.bold, color: kTextDark),
      headlineMedium: GoogleFonts.notoSansJp(
          fontSize: 22, fontWeight: FontWeight.bold, color: kTextDark),
      headlineSmall: GoogleFonts.notoSansJp(
          fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark),
      bodyLarge: GoogleFonts.notoSansJp(fontSize: 16, color: kTextDark),
      bodyMedium: GoogleFonts.notoSansJp(fontSize: 14, color: kTextDark),
      bodySmall: GoogleFonts.notoSansJp(fontSize: 12, color: kTextMuted),
    ),
  );
}

// 学年グループ（全教科共通）
enum GradeGroup { low, mid, high }

GradeGroup gradeGroupOf(int grade) {
  if (grade <= 2) return GradeGroup.low;
  if (grade <= 4) return GradeGroup.mid;
  return GradeGroup.high;
}

Color gradeColor(GradeGroup g) {
  return switch (g) {
    GradeGroup.low  => const Color(0xFFF39C12),
    GradeGroup.mid  => const Color(0xFF27AE60),
    GradeGroup.high => const Color(0xFF2980B9),
  };
}

String gradeLabel(GradeGroup g) {
  return switch (g) {
    GradeGroup.low  => '低学年',
    GradeGroup.mid  => '中学年',
    GradeGroup.high => '高学年',
  };
}
