import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:sizer/sizer.dart';
import 'font_manager.dart';

class TextStylesManager {
  static const TextStyle reqularStyle = TextStyle();
  static const TextStyle regularBoldStyle = TextStyle(
    fontWeight: FontWeightManager.bold,
    color: ColorManager.darkBlue,
  );
  static const TextStyle regularBoldWhiteStyle = TextStyle(
    fontWeight: FontWeightManager.bold,
    color: ColorManager.white,
  );
  static const TextStyle regularWhiteStyle = TextStyle(
    color: ColorManager.white,
  );
  static const TextStyle regularBoldStyle2 = TextStyle();
  static const TextStyle titleStyle = TextStyle();
  static final TextStyle titleBoldStyle =
      TextStyle(fontWeight: FontWeightManager.bold, color: ColorManager.primary, fontSize: 20.sp);
  static const TextStyle appBarTitle = TextStyle(
    color: ColorManager.black,
    fontWeight: FontWeightManager.bold,
  );
  static const TextStyle selectedTabStyle = TextStyle(
    color: ColorManager.white,
    fontWeight: FontWeightManager.bold,
  );
  static const TextStyle unSelectedTabStyle = TextStyle(
    color: ColorManager.black,
    fontWeight: FontWeightManager.bold,
  );
}
