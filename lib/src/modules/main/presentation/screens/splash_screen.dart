import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/app_manager.dart';
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
  bool initCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      curve: Curves.bounceOut,
      duration: 2500,
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 200,
      splash: CircleAvatar(
        radius: 17.w,
        backgroundImage: const AssetImage(ImagesManager.logo),
      ),
      nextScreen: loadingFirstScreen ? const MainScreen() : firstScreen,
    );
  }

  Future<void> _initializeApp() async {
    Timer(const Duration(seconds: 2), () async {
      await _attemptInit();
      if (!initCompleted) {
        // إعادة المحاولة مرة أخرى إذا لم تكتمل عملية الـ init
        await _attemptInit();
      }
      await _getScreen();
      setState(() {
        loadingFirstScreen = false;
      });
    });
  }

  Future<void> _attemptInit() async {
    try {
      await AppManager.init();
      initCompleted = true;
    } catch (e) {
      // التعامل مع الخطأ هنا
      print('Failed to initialize: $e');
      initCompleted = false;
    }
  }

  Future<Widget> _getFirstScreen() async {
    bool showSplash = await CacheHelper.getData(key: "showSplash") ?? true;
    if (showSplash) {
      return const OnBoardingScreen();
    } else {
      return const MainScreen();
    }
  }

  Future<void> _getScreen() async {
    firstScreen = await _getFirstScreen();
  }
}
