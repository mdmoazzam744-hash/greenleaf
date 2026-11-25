import 'package:material_ui/material_ui.dart';

class GreenleafColors {
  static const Color primaryGreen = Color(0xFF2D6A4F);
  static const Color leafGreen = Color(0xFF40916C);
  static const Color freshGreen = Color(0xFF52B788);
  static const Color mintWash = Color(0xFFEAF5EE);
  static const Color mintBorder = Color(0xFFD5E8DC);

  static const Color softYellow = Color(0xFFFEF3C7);
  static const Color butterYellow = Color(0xFFFDE68A);
  static const Color warmGoldText = Color(0xFF854D0E);

  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF7FAF7);
  static const Color textPrimary = Color(0xFF1B3A2A);
  static const Color textSecondary = Color(0xFF5C7566);

  static const Color desktopBackdrop = Color(0xFFE5E7EB);
  static const Color phoneBezel = Color(0xFF18181B);
}

class GreenleafTheme {
  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GreenleafColors.primaryGreen,
      primary: GreenleafColors.primaryGreen,
      onPrimary: GreenleafColors.pureWhite,
      secondary: GreenleafColors.butterYellow,
      onSecondary: GreenleafColors.warmGoldText,
      surface: GreenleafColors.pureWhite,
      onSurface: GreenleafColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: GreenleafColors.scaffoldBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: GreenleafColors.scaffoldBg,
        foregroundColor: GreenleafColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: GreenleafColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: GreenleafColors.pureWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: GreenleafColors.mintBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GreenleafColors.primaryGreen,
          foregroundColor: GreenleafColors.pureWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GreenleafColors.pureWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: GreenleafColors.mintBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: GreenleafColors.mintBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: GreenleafColors.primaryGreen,
            width: 1.8,
          ),
        ),
        labelStyle: const TextStyle(color: GreenleafColors.textSecondary),
        hintStyle: const TextStyle(color: GreenleafColors.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: GreenleafColors.primaryGreen,
        contentTextStyle: const TextStyle(
          color: GreenleafColors.pureWhite,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
