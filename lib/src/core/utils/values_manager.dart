import 'package:flutter/material.dart';
class MarginManager {
  static const double m8 =  8.0  ;
  static const double m10 = 10.0 ;
  static const double m15 = 15.0 ;
  static const double m20 = 20.0 ;
  static const double m40 = 40.0 ;
  static const double m50 = 50.0 ;

}
class PaddingManager {
  static const double p8 =  8.0  ;
  static const double p10 = 10.0 ;
  static const double p15 = 15.0 ;
  static const double p20 = 20.0 ;
  static const double p40 = 40.0 ;
  static const double p50 = 50.0 ;
}

class SizeManager
{
  static const double s1_5 =  1.5  ;
  static const double s4 =  4.0  ;
  static const double s8 =  8.0  ;
  static const double s10 = 10.0 ;
  static const double s15 = 15.0 ;
  static const double s20 = 20.0 ;
  static const double s40 = 40.0 ;
  static const double s50 = 50.0 ;
  static const double s200 = 200.0 ;
  static const double s400 = 400.0 ;
}
class QueryValues
{
  static double height (context)=> MediaQuery.of(context).size.height ;
  static double width (context)=> MediaQuery.of(context).size.width ;
}