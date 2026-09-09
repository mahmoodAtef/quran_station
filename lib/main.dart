import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_station/generated/l10n.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/core/utils/app_manager.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/main/cubit/main_cubit.dart';
import 'package:quran_station/src/modules/main/presentation/screens/main_screen.dart';
import 'package:quran_station/src/modules/main/presentation/screens/onboarding.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage and core services
  await AppManager.initializeHydratedStorage();
  await AppManager.init();
  
  // Determine initial screen
  bool showOnboarding = await CacheHelper.getData(key: "showSplash") ?? true;
  Widget startWidget = showOnboarding ? const OnBoardingScreen() : const MainScreen();

  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({
    super.key,
    required this.startWidget,
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
          BlocProvider(
            create: (BuildContext context) => MainCubit.get(),
          ),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return BlocBuilder<MainCubit, MainState>(
            buildWhen: (previous, current) => current != previous ,
            builder: (context, state) {
              return MaterialApp(
                theme: lightTheme,
                darkTheme: darkTheme,
                locale: const Locale('ar'),
                themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
                home: startWidget,
              );
            },
          );
        }));
  }
}
