import 'package:flutter/cupertino.dart';

class MainScreenItem {
  final String title;
  final Widget icon;
  final Widget screen;
  final Color? color;
  final double? height;

  const MainScreenItem({
    this.color,
    this.height,
    required this.title,
    required this.icon,
    required this.screen,
  });
}
