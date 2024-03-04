import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_station/generated/l10n.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/main/presentation/screens/splash_screen.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AudiosBloc.get(),
          ),
          BlocProvider(
            create: (BuildContext context) => QuizCubit.get(),
          ),
          BlocProvider(
            create: (BuildContext context) => MoshafCubit.get(),
          ),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
            title: 'كلامُ ربي',
            theme: lightTheme,
            home: const SplashScreen(),
          );
        }));
  }
}
// flutter run --release --cache-sksl --purge-persistent-cache
