import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E2640); // اللون الأساسي
  static const Color secondaryColor = Color(0xFF922C40); // اللون الثانوي
  static const Color tertiaryColor = Color(0xFFF3EAC0); // اللون الثالث

  static const Color primaryLight = Color(0xFF2A3555);
  static const Color primaryDark = Color(0xFF141B2E);
  static const Color primaryVariant = Color(0xFF3C4B73);

  static const Color secondaryLight = Color(0xFFA63E56);
  static const Color secondaryDark = Color(0xFF7A1F30);
  static const Color secondaryVariant = Color(0xFFB85570);

  static const Color tertiaryLight = Color(0xFFF7F0D6);
  static const Color tertiaryDark = Color(0xFFD8D6D6);
  static const Color tertiaryVariant = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceDark = Color(0xFF0F1419);
  static const Color background = Color(0xFFFFFBFE);
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFF1E2640);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onBackgroundDark = Color(0xFFE6E1E5);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

class AppTheme {
  static bool isDarkMode = false;
  static ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;
  static setTheme(bool isDarkMode) {
    AppTheme.isDarkMode = isDarkMode;
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.onPrimary,
      secondary: AppColors.secondaryColor,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.onSecondary,
      tertiary: AppColors.tertiaryColor,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryLight,
      onTertiaryContainer: AppColors.onTertiary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceVariant: AppColors.tertiaryVariant,
      onSurfaceVariant: AppColors.onTertiary,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      error: AppColors.error,
      onError: AppColors.onError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.onPrimary,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.onPrimary,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondaryColor,
        side: const BorderSide(color: AppColors.secondaryColor, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 4,
      shadowColor: AppColors.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.tertiaryLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.onTertiary),
      hintStyle: TextStyle(color: AppColors.onTertiary.withOpacity(0.6)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.onSecondary,
      elevation: 6,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: AppColors.tertiaryColor,
      unselectedItemColor: AppColors.onPrimary.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.tertiaryLight,
      selectedColor: AppColors.secondaryColor,
      labelStyle: TextStyle(color: AppColors.onTertiary),
      secondaryLabelStyle: TextStyle(color: AppColors.onSecondary),
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.onPrimary,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.onSecondary,
      tertiary: AppColors.tertiaryDark,
      onTertiary: AppColors.primaryColor,
      tertiaryContainer: AppColors.tertiaryColor.withOpacity(0.2),
      onTertiaryContainer: AppColors.tertiaryColor,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceVariant: AppColors.primaryDark,
      onSurfaceVariant: AppColors.onSurfaceDark,
      background: AppColors.backgroundDark,
      onBackground: AppColors.onBackgroundDark,
      error: AppColors.error,
      onError: AppColors.onError,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.onPrimary,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimary,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 4,
      shadowColor: AppColors.primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primaryDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryLight.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.onSurfaceDark),
      hintStyle: TextStyle(color: AppColors.onSurfaceDark.withOpacity(0.6)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryLight,
      foregroundColor: AppColors.onSecondary,
      elevation: 6,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryDark,
      selectedItemColor: AppColors.tertiaryColor,
      unselectedItemColor: AppColors.onSurfaceDark.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
    ),

    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.primaryDark,
      selectedColor: AppColors.secondaryLight,
      labelStyle: TextStyle(color: AppColors.onSurfaceDark),
      secondaryLabelStyle: TextStyle(color: AppColors.onSecondary),
      brightness: Brightness.dark,
    ),
  );
}
