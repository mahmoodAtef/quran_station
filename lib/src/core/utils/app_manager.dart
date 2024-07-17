import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran_station/firebase_options.dart';

import '../local/shared_prefrences.dart';

class AppManager {
  static Future init() async {
    await CacheHelper.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.tofy.kalam_rabbi',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
