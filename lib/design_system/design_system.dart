import 'package:flutter/material.dart';

// Colors
class AppColors {
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textWhite = Colors.white;
}

// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
}

// Sizes
class AppSizes {
  static const double borderRadius = 8.0;
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusLarge = 12.0;
}

// Typography
class AppTypography {
  static const TextStyle labelLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );
}
