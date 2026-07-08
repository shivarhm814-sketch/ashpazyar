import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design-token source. Every screen must read colors, type, spacing
/// and radii from here — no raw hex codes or magic numbers in feature code.
class AppColors {
  AppColors._();

  static const pageBackground = Color(0xFFF0DFD0);
  static const appBackground = Color(0xFFFFF8F2);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFF0DDD1);
  static const borderDashed = Color(0xFFE3CBB5);

  static const ink = Color(0xFF2D2D2D);
  static const inkSoft = Color(0xFF8A8078);
  static const tagline = Color(0xFF6B7280);
  static const captionMuted = Color(0xFFA89686);

  static const chipBackground = Color(0xFFFBEAE0);
  static const chipText = Color(0xFF8C6F5D);

  static const turmeric = Color(0xFFF97316);
  static const turmericLight = Color(0xFFFFA35C);

  static const tomato = Color(0xFFE85D3F);
  static const tomatoSoft = Color(0xFFFDE6DE);
  static const tomatoTextOnSoft = Color(0xFFC1432B);

  static const olive = Color(0xFF4CAF50);
  static const oliveSoft = Color(0xFFDFF5E0);
  static const oliveTextOnSoft = Color(0xFF2E7D32);

  static const disabledBackground = chipBackground;
  static const disabledForeground = Color(0xFFB3A47F);
}

class AppSpacing {
  AppSpacing._();

  static const double screenPadding = 20;
  static const double gapSmall = 8;
  static const double gapMedium = 12;
  static const double gapLarge = 14;
}

class AppRadius {
  AppRadius._();

  static const double card = 16;
  static const double cardLarge = 18;
  static const double sheet = 24;
  static const double pill = 100;
  static const double cta = 16;
  static const double control = 14;
}

class AppText {
  AppText._();

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
  }) {
    return GoogleFonts.vazirmatn(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Reem Kufi — reserved for the logo wordmark and each screen's single main
  /// heading (never card titles or body copy, which stay Vazirmatn).
  static TextStyle _kufi({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return GoogleFonts.reemKufi(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  static TextStyle heroTitle({Color color = AppColors.tomato}) =>
      _kufi(fontSize: 34, fontWeight: FontWeight.w700, color: color);

  static TextStyle screenTitle({Color color = AppColors.ink}) =>
      _kufi(fontSize: 19, fontWeight: FontWeight.w700, color: color);

  static TextStyle screenTitleLarge({Color color = AppColors.ink}) =>
      _kufi(fontSize: 22, fontWeight: FontWeight.w700, color: color);

  static TextStyle cardTitle({Color color = AppColors.ink}) =>
      _base(fontSize: 16.5, fontWeight: FontWeight.w800, color: color);

  static TextStyle body({Color color = AppColors.ink, double height = 1.8}) =>
      _base(fontSize: 15, fontWeight: FontWeight.w400, color: color, height: height);

  static TextStyle bodySoft({Color color = AppColors.inkSoft, double height = 1.8}) =>
      _base(fontSize: 13.5, fontWeight: FontWeight.w400, color: color, height: height);

  static TextStyle label({Color color = AppColors.inkSoft}) =>
      _base(fontSize: 13, fontWeight: FontWeight.w500, color: color);

  static TextStyle caption({Color color = AppColors.captionMuted}) =>
      _base(fontSize: 12, fontWeight: FontWeight.w500, color: color, height: 1.7);

  static TextStyle button({Color color = AppColors.ink}) =>
      _base(fontSize: 16, fontWeight: FontWeight.w700, color: color);

  static TextStyle chip({Color color = AppColors.chipText}) =>
      _base(fontSize: 13, fontWeight: FontWeight.w600, color: color);
}

class AppTheme {
  AppTheme._();

  static ThemeData get themeData {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.appBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.turmeric,
        primary: AppColors.turmeric,
        secondary: AppColors.olive,
        error: AppColors.tomato,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      fontFamily: GoogleFonts.vazirmatn().fontFamily,
    );

    return base.copyWith(
      textTheme: GoogleFonts.vazirmatnTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
