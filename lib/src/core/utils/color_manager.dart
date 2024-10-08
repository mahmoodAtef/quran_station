import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';

class ColorManager {
  static const Color primary = Color(0xff922C40);
  static const Color secondary = Color(0xffDC9750);
  static const Color card = Color(0xffF3EAC0);
  static const Color darkBlue = Color(0xff1E2640);
  static Color grey1 = Colors.grey[200]!;
  static const Color trueAnswer = Colors.green;
  static const Color grey2 = Colors.grey;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static Color error = Colors.red.shade800;
  static const Color transparent = Colors.transparent;
  static const Color quranPage = Color(0xfff6efce);

  static Color getLightColor() {
    return ThemeManager.isDarkMode ? black : white;
  }

  static Color getDarkColor() {
    return ThemeManager.isDarkMode ? white : black;
  }
}
