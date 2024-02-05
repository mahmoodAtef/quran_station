import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_station/generated/l10n.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/core/services/bloc_observer.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/main/presentation/screens/main_screen.dart';
import 'package:quran_station/src/modules/main/presentation/screens/onboarding.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  Widget firstScreen = await getFirstScreen();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        firstScreen: firstScreen,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
  // runApp(MyApp(
  //   firstScreen: firstScreen,
  // ));
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;
  const MyApp({super.key, required this.firstScreen});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AudiosBloc.get(),
          ),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            showSemanticsDebugger: false,
            title: 'محطة القرآن الكريم',
            theme: lightTheme,
            home: firstScreen,
          );
        }));
  }
}

Future<Widget> getFirstScreen() async {
  bool showSplash = await CacheHelper.getData(key: "showSplash") ?? true;
  if (showSplash) {
    return const OnBoardingScreen();
  } else {
    return const MainScreen();
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("test"),
      ),
    );
  }
}
