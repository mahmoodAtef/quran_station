import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

class MoshafScreen extends StatelessWidget {
  const MoshafScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: appDrawer,
      appBar: AppBar(),
      body: Container(
        child: PageView(
          scrollDirection: Axis.vertical,
          children: [],
        ),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: RadialGradient(colors: [
              ColorManager.secondary.withOpacity(.5),
              ColorManager.secondary.withOpacity(.4),
              ColorManager.secondary.withOpacity(.3),
            ])),
      ),
    );
  }
}
