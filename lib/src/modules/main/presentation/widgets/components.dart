import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/main/presentation/ui_entities/main_screen_item.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

Drawer appDrawer = Drawer(
  child: Column(
    children: [
      Container(
        height: 25.h,
        width: double.infinity,
        color: ColorManager.primary,
      ),
      const HeightSeparator(),
      ListTile(
        leading: const Icon(
          Icons.workspace_premium,
          color: ColorManager.primary,
        ),
        title: const Text("الاشتراك"),
        onTap: () {},
      ),
    ],
  ),
);

class HeightSeparator extends StatelessWidget {
  const HeightSeparator({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 2.h);
  }
}

class DefaultButton extends StatelessWidget {
  final void Function() onPressed;
  final double? height;
  final double? width;
  final String title;
  final Color? color;
  const DefaultButton(
      {super.key,
      required this.onPressed,
      this.height,
      this.width,
      required this.title,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 7.h,
      width: width ?? 50.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.sp)),
        color: color ?? ColorManager.primary,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(title, style: TextStylesManager.regularBoldWhiteStyle),
      ),
    );
  }
}

class MainScreenItemWidget extends StatelessWidget {
  final MainScreenItem item;
  const MainScreenItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(item.screen);
      },
      child: Container(
        height: item.height?.h ?? 15.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.darkBlue.withOpacity(.8),
              ColorManager.darkBlue.withOpacity(.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
          color: ColorManager.primary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.icon,
            const HeightSeparator(),
            Text(
              item.title,
              style: TextStylesManager.regularBoldWhiteStyle,
            )
          ],
        ),
      ),
    );
  }
}
