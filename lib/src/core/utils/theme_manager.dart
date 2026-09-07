// lib/src/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand colors — unchanged
  static const Color primaryColor = Color(0xFF1E2640);
  static const Color secondaryColor = Color(0xFF922C40);
  static const Color tertiaryColor = Color(0xFFF3EAC0);

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
  static const Color errorLight = Color(0xFFFFDAD6);
  static const Color errorDark = Color(0xFF930009);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFF1E2640);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onBackgroundDark = Color(0xFFE6E1E5);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Material 3 surface container roles — light
  static const Color surfaceContainerLight = Color(0xFFF3EDF7);
  static const Color surfaceContainerHighLight = Color(0xFFECE6F0);
  static const Color surfaceContainerHighestLight = Color(0xFFE6E0E9);
  static const Color surfaceContainerLowLight = Color(0xFFF7F2FA);
  static const Color surfaceDimLight = Color(0xFFDED8E1);
  static const Color surfaceBrightLight = Color(0xFFFFFBFE);

  // Material 3 surface container roles — dark
  static const Color surfaceContainerDark = Color(0xFF211F26);
  static const Color surfaceContainerHighDark = Color(0xFF2B2930);
  static const Color surfaceContainerHighestDark = Color(0xFF36343B);
  static const Color surfaceContainerLowDark = Color(0xFF1D1B20);
  static const Color surfaceDimDark = Color(0xFF141218);
  static const Color surfaceBrightDark = Color(0xFF3B383E);

  // Outline / shadow / scrim / inverse — shared roles
  static const Color outlineLight = Color(0xFF79747E);
  static const Color outlineVariantLight = Color(0xFFCAC4D0);
  static const Color outlineDark = Color(0xFF938F99);
  static const Color outlineVariantDark = Color(0xFF49454F);

  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  static const Color inverseSurfaceLight = Color(0xFF313033);
  static const Color onInverseSurfaceLight = Color(0xFFF4EFF4);
  static const Color inverseSurfaceDark = Color(0xFFE6E1E5);
  static const Color onInverseSurfaceDark = Color(0xFF313033);
}


final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  splashColor: AppColors.primaryColor.withOpacity(0.1),
  highlightColor: AppColors.primaryColor.withOpacity(0.05),
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
    surfaceContainer: AppColors.surfaceContainerLight,
    surfaceContainerHigh: AppColors.surfaceContainerHighLight,
    surfaceContainerHighest: AppColors.surfaceContainerHighestLight,
    surfaceContainerLow: AppColors.surfaceContainerLowLight,
    surfaceDim: AppColors.surfaceDimLight,
    surfaceBright: AppColors.surfaceBrightLight,
    outline: AppColors.outlineLight,
    outlineVariant: AppColors.outlineVariantLight,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.inverseSurfaceLight,
    onInverseSurface: AppColors.onInverseSurfaceLight,
    inversePrimary: AppColors.primaryLight,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.errorDark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.onPrimary,
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  iconTheme: const IconThemeData(color: AppColors.onSurface),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: AppColors.onSurface),
    bodyMedium: TextStyle(color: AppColors.onSurface),
    bodySmall: TextStyle(color: AppColors.onSurface),
    labelLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.onPrimary,
      elevation: 3,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.secondaryColor,
      side: const BorderSide(color: AppColors.secondaryColor, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.primaryColor.withOpacity(0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.tertiaryLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
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
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.inverseSurfaceLight,
    contentTextStyle: const TextStyle(color: AppColors.onInverseSurfaceLight),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.outlineVariantLight,
    thickness: 1,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryColor,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
          ? AppColors.primaryColor
          : AppColors.outlineLight,
    ),
    trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
          ? AppColors.primaryLight
          : AppColors.outlineVariantLight,
    ),
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.inverseSurfaceLight,
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(color: AppColors.onInverseSurfaceLight),
  ),
);



final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  splashColor: AppColors.primaryLight.withOpacity(0.1),
  highlightColor: AppColors.primaryLight.withOpacity(0.05),
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
    surfaceContainer: AppColors.surfaceContainerDark,
    surfaceContainerHigh: AppColors.surfaceContainerHighDark,
    surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
    surfaceContainerLow: AppColors.surfaceContainerLowDark,
    surfaceDim: AppColors.surfaceDimDark,
    surfaceBright: AppColors.surfaceBrightDark,
    outline: AppColors.outlineDark,
    outlineVariant: AppColors.outlineVariantDark,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.inverseSurfaceDark,
    onInverseSurface: AppColors.onInverseSurfaceDark,
    inversePrimary: AppColors.primaryColor,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorDark,
    onErrorContainer: AppColors.errorLight,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: AppColors.onPrimary,
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  iconTheme: const IconThemeData(color: AppColors.onSurfaceDark),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: AppColors.onSurfaceDark, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.onSurfaceDark, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: AppColors.onSurfaceDark, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: AppColors.onSurfaceDark),
    bodyMedium: TextStyle(color: AppColors.onSurfaceDark),
    bodySmall: TextStyle(color: AppColors.onSurfaceDark),
    labelLarge: TextStyle(color: AppColors.onSurfaceDark, fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.onPrimary,
      elevation: 3,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.secondaryLight,
      side: const BorderSide(color: AppColors.secondaryLight, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.primaryColor.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.primaryDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryLight.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
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
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.inverseSurfaceDark,
    contentTextStyle: const TextStyle(color: AppColors.onInverseSurfaceDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.surfaceDark,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.surfaceDark,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.outlineVariantDark,
    thickness: 1,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryLight,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
          ? AppColors.primaryLight
          : AppColors.outlineDark,
    ),
    trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
          ? AppColors.primaryDark
          : AppColors.outlineVariantDark,
    ),
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.inverseSurfaceDark,
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(color: AppColors.onInverseSurfaceDark),
  ),
);




class AppTheme {
  static bool isDarkMode = false;

  static ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  static void setTheme(bool value) {
    isDarkMode = value;
  }
}