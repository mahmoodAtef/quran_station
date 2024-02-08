import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:simple_audio/simple_audio.dart';
import 'package:sizer/sizer.dart';
import '../widgets/audio_player.dart';
import '../widgets/components.dart';

enum AudioType { url, file, radio }

class AudioPlayerScreen extends StatefulWidget {
  final String audioAddress;
  final String title;
  final AudioType audioType;
  const AudioPlayerScreen(
      {super.key, required this.audioAddress, required this.title, required this.audioType});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  void initState() {
    AudiosBloc bloc = AudiosBloc.get();
    if (bloc.currentSurahUrl != widget.audioAddress) {
      bloc.currentSurahUrl = widget.audioAddress;
      playAudio(bloc);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initial playback. Preloaded playback information
    AudiosBloc bloc = AudiosBloc.get();
    debugPrint("Audio Url: ${widget.audioAddress}");
    print(widget.audioAddress);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
                  child: SizedBox(
            height: 40.h,
            width: 90.w,
            child: Image.asset(widget.audioType == AudioType.radio
                ? "assets/images/radio.jpg"
                : "assets/images/audio.jpeg"),
          ))),
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 5.h),
            child: PlayerWidget(
              audioType: widget.audioType,
              player: bloc.audioPlayer,
              audioUrl: widget.audioAddress,
            ),
          ),
        ],
      ),
    );
  }

  Future playAudio(AudiosBloc bloc) async {
    await bloc.audioPlayer.stop();
    if (bloc.audioPlayer.state != PlayerState.playing) {
      await bloc.audioPlayer.play(
        UrlSource(
          widget.audioAddress,
        ),
        mode: PlayerMode.mediaPlayer,
        ctx: const AudioContext(
            android: AudioContextAndroid(
              usageType: AndroidUsageType.media,
              audioMode: AndroidAudioMode.normal,
              stayAwake: true,
              contentType: AndroidContentType.music,
            ),
            iOS: AudioContextIOS(
              options: [
                AVAudioSessionOptions.allowBluetooth,
                AVAudioSessionOptions.allowAirPlay,
                AVAudioSessionOptions.allowBluetoothA2DP,
                AVAudioSessionOptions.defaultToSpeaker,
                AVAudioSessionOptions.overrideMutedMicrophoneInterruption
              ],
            )),
      );
    } else {
      await bloc.audioPlayer.stop();
      await bloc.audioPlayer.play(UrlSource(widget.audioAddress));
    }
  }
}
