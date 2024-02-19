import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_player.dart';
import 'package:sizer/sizer.dart';

enum AudioType { url, file, radio }

class AudioPlayerScreen extends StatefulWidget {
  final String audioAddress;
  final String title;
  final AudioType audioType;

  const AudioPlayerScreen({
    Key? key,
    required this.audioAddress,
    required this.title,
    required this.audioType,
  }) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudiosBloc bloc = AudiosBloc.get();
  late AudioPlayer _audioPlayer;
  @override
  void initState() {
    super.initState();
    _audioPlayer = bloc.audioPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          PlayerWidget(
            player: _audioPlayer,
            audioAddress: widget.audioAddress,
            title: widget.title,
            audioType: widget.audioType,
          )
        ],
      ),
    );
  }
}

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer audioPlayer;

  AudioPlayerTask({required this.audioPlayer});

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    AudioServiceBackground.setQueue([]);

    AudioServiceBackground.setState(
      controls: [
        audioPlayer.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
      ],
      playing: audioPlayer.playing,
      position: audioPlayer.position,
      systemActions: const [
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      updateTime: DateTime.now(),
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
    );

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer.stop();
      }
      AudioServiceBackground.setState(
        controls: [
          if (playerState.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        playing: playerState.playing ?? false,
        position: audioPlayer.position ?? Duration.zero,
        bufferedPosition: audioPlayer.bufferedPosition ?? Duration.zero,
        speed: audioPlayer.speed ?? 1.0,
        updateTime: DateTime.now(),
      );
    });
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    audioPlayer.play();
  }

  @override
  Future<void> onPlay() async {
    audioPlayer.play();
  }

  @override
  Future<void> onPause() async {
    audioPlayer.pause();
  }

  @override
  Future<void> onStop() async {
    audioPlayer.stop();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    audioPlayer.seek(position);
  }

  @override
  Future<void> onClick(MediaButton? button) async {
    if (button == MediaButton.media) {
      if (audioPlayer.playing) {
        onPause();
      } else {
        onPlay();
      }
    }
  }

  @override
  Future<void> onFastForward() async {
    audioPlayer.seek(audioPlayer.position + const Duration(seconds: 10));
    await super.onFastForward();
  }

  @override
  Future<void> onRewind() async {
    audioPlayer.seek(audioPlayer.position - const Duration(seconds: 10));
    await super.onRewind();
  }
}