import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran_station/generated/l10n.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/main/presentation/screens/splash_screen.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';
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
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.tofy.kalam_rabbi',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
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
List<Question> questions = [
  Question(
    id: 53,
    questionText:
        "على لسان من حكى القرآن الكريم في الآية الآتية 'إِنْ تُعَذِّبْهُمْ فَإِنَّهُمْ عِبَادُكَ وَإِنْ تَغْفِرْ لَهُمْ فَإِنَّكَ أَنْتَ الْعَزِيزُ الْحَكِيمُ'؟",
    answers: [
      "موسى عليه السلام",
      "عيسى عليه السلام",
      "ابراهيم عليه السلام",
    ],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 54,
    questionText:
        "على لسان من حكى القرآن الكريم في الآية الآتية 'لَا تَثْرِيبَ عَلَيْكُمُ الْيَوْمَ ۖ يَغْفِرُ اللَّهُ لَكُمُْ'؟",
    answers: ["موسى عليه السلام", "يوسف عليه السلام", "ابراهيم عليه السلام", "عيسى عليه السلام"],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 55,
    questionText:
        "على لسان من حكى القرآن الكريم في الآية الآتية 'إِنَّمَا أَشْكُو بَثِّي وَحُزْنِي إِلَى اللَّهِ'؟",
    answers: ["يعقوب عليه السلام", "موسى عليه السلام", "يونس عليه السلام", "يوسف عليه السلام"],
    trueAnswerIndex: 0,
  ),
  Question(
    id: 56,
    questionText:
        "على لسان من حكى القرآن الكريم في الآية الآتية 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَْ'؟",
    answers: [
      "يونس عليه السلام",
      "يوسف عليه السلام",
      "موسى عليه السلام",
    ],
    trueAnswerIndex: 0,
  ),
  Question(
    id: 57,
    questionText: "سورة من القرآن يطلق عليها اسم الحائلة، ما هي؟ ولماذا سميت بالحائلة؟",
    answers: [
      "سورة الفاتحة، لأنها فتحة القرآن",
      "سورة الحجرات، لأنها حجرات النبي",
      "سورة النساء، لأنها تناولت قضايا النساء",
      "سورة الكهف، لأنها تحول بين صاحبها والنار"
    ],
    trueAnswerIndex: 3,
  ),
  Question(
    id: 58,
    questionText: "ماهي السورة التي تعرف باسم السبع المثاني؟",
    answers: ["الفاتحة", "النساء", "الناس", "الفلق"],
    trueAnswerIndex: 0,
  ),
  Question(
    id: 59,
    questionText: "ماهي السورة التي تعرف باسم الفاضحة؟",
    answers: ["البقرة", "الحجر", "المنافقون", "التوبة"],
    trueAnswerIndex: 3,
  ),
  Question(
    id: 60,
    questionText: "ماهي السورة التي تعرف باسم الدهر؟",
    answers: ["العصر", "النساء", "البقرة", "الإنسان"],
    trueAnswerIndex: 3,
  ),
  Question(
    id: 61,
    questionText:
        "من الآيات التي يكثر استخدامها قوله تعالى 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ' في أي سور القرآن وردت هذه الآية؟",
    answers: ["البقرة", "الأنبياء", "الحج", "المؤمنون"],
    trueAnswerIndex: 0,
  ),
  Question(
    id: 62,
    questionText:
        "من الآيات التي يكثر استخدامها قوله تعالى 'لَا يَسْخَرْ قَوْمٌ مِّن قَوْمٍ' في أي سور القرآن وردت هذه الآية؟",
    answers: ["البقرة", "الحجرات", "الحج", "المؤمنون"],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 63,
    questionText:
        "من الآيات التي يكثر استخدامها قوله تعالى 'لِلَّهِ الْأَمْرُ مِن قَبْلُ وَمِن بَعْدُ' في أي سور القرآن وردت هذه الآية؟",
    answers: ["النحل", "الأنبياء", "أ و ب معا", "لقمان"],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 64,
    questionText:
        "من الآيات التي يكثر استخدامها قوله تعالى ' إِنَّكَ لَا تَهْدِي مَنْ أَحْبَبْتَ وَلَكِنَّ اللَّهَ يَهْدِي مَنْ يَشَاءُ' في أي سور القرآن وردت هذه الآية؟",
    answers: ["لقمان", "القصص", "البقرة", "المائدة"],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 65,
    questionText: "أين وردت آية الملاعنة؟",
    answers: [
      "سورة الكهف",
      "سورة الرعد",
      "سورة النور",
    ],
    trueAnswerIndex: 2,
  ),
  Question(
    id: 66,
    questionText: "أين وردت آية الدين؟",
    answers: [
      "سورة الكهف",
      "سورة البقرة",
      "سورة النور",
    ],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 67,
    questionText: "أين وردت قصة طالوت وجالوت؟",
    answers: [
      "سورة الكهف",
      "سورة البقرة",
      "سورة النور",
    ],
    trueAnswerIndex: 1,
  ),
  Question(
    id: 68,
    questionText: "أين وردت قصة أصحاب البقرة؟",
    answers: [
      "سورة الكهف",
      "سورة الرعد",
      "سورة النور",
    ],
    trueAnswerIndex: 2,
  ),
  Question(
    id: 69,
    questionText: "أين وردت قصة أصحاب البقرة؟",
    answers: [
      "سورة الكهف",
      "سورة الرعد",
      "سورة النور",
    ],
    trueAnswerIndex: 2,
  ),
  Question(
    id: 70,
    questionText: "أين وردت قصة أصحاب البقرة؟",
    answers: [
      "سورة الكهف",
      "سورة الرعد",
      "سورة النور",
    ],
    trueAnswerIndex: 2,
  ),
];

Future addQuestions() async {
  var fireStore = FirebaseFirestore.instance;
  // ignore: avoid_function_literals_in_foreach_calls
  questions.forEach((element) async {
    await fireStore.collection("quran_questions").doc(element.id.toString()).set(element.toJson());
  });
}
