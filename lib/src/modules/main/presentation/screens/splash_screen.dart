import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/modules/main/presentation/screens/main_screen.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/local/shared_prefrences.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget firstScreen;
  bool loadingFirstScreen = true;
  @override
  void initState() {
    _getScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loadingFirstScreen
        ? AnimatedSplashScreen(
            curve: Curves.bounceOut,
            duration: 2500,
            splashTransition: SplashTransition.fadeTransition,
            splashIconSize: 200,
            splash: CircleAvatar(
              radius: 17.w,
              backgroundImage: const AssetImage(ImagesManager.logo),
            ),
            nextScreen: const MainScreen(),
          )
        : AnimatedSplashScreen(
            curve: Curves.bounceOut,
            duration: 2500,
            splashTransition: SplashTransition.fadeTransition,
            splashIconSize: 200,
            splash: CircleAvatar(
              radius: 17.w,
              backgroundImage: const AssetImage(ImagesManager.logo),
            ),
            nextScreen: firstScreen,
          );
  }

  Future<Widget> _getFirstScreen() async {
    bool showSplash = await CacheHelper.getData(key: "showSplash") ?? true;
    if (showSplash) {
      return const OnBoardingScreen();
    } else {
      return const MainScreen();
    }
  }

  Future _getScreen() async {
    firstScreen = await _getFirstScreen();
    setState(() {
      loadingFirstScreen = false;
    });
  }
}
