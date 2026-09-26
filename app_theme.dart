import 'package:flutter/material.dart';

/// Central color palette for the app.
///
/// Only three brand colors are used, as requested:
/// - [blush] is the page / header background.
/// - [rose] is the resting tint for icons and tags.
/// - [mauve] is the selected / accent tone.
/// Everything else is a near-black neutral or a neutral gray, so the
/// three brand colors read as deliberate accents rather than decoration.
class AppColors {
  AppColors._();

  static const Color blush = Color(0xFFFFF5F5);
  static const Color rose = Color(0xFFF7D6D0);
  static const Color mauve = Color(0xFFE2B4BD);

  // Neutrals derived to sit comfortably against the three brand colors.
  static const Color ink = Color(0xFF2B2320);
  static const Color inkSoft = Color(0xFF5C534E);
  static const Color textSecondary = Color(0xFF7A6F6A);
  static const Color textMuted = Color(0xFFA08880);
  static const Color hint = Color(0xFF8A6E68);

  static const Color cardBorder = Color(0xFFEBDAD8);
  static const Color cardBorderSelected = Color(0xFFD8A9AF);
  static const Color cardSelectedBg = Color(0xFFFDF7F6);
  static const Color divider = Color(0xFFEDE0DE);
  static const Color tagBg = Color(0xFFF3ECEA);

  static const Color iconOnRose = Color(0xFF7C4A45);
  static const Color iconOnMauve = Color(0xFF5C2B39);
  static const Color badgeOnMauveBg = Color(0xFFF0DADD);
  static const Color badgeOnMauveText = Color(0xFF7C4A45);

  // Severity colors for the dashboard (kept semantic, outside the 3-color
  // brand palette, since severity needs to be unambiguous).
  static const Color high = Color(0xFFE24B4A);
  static const Color medium = Color(0xFFEF9F27);
  static const Color low = Color(0xFF378ADD);
  static const Color critical = Color(0xFFA32D2D);
}

class AppRadius {
  AppRadius._();
  static const double card = 14;
  static const double sheet = 26;
  static const double button = 12;
  static const double chip = 999;
  static const double iconTile = 11;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.blush,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mauve,
        brightness: Brightness.light,
        primary: AppColors.ink,
        secondary: AppColors.mauve,
        surface: AppColors.blush,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.rose,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.ink,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.blush,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
