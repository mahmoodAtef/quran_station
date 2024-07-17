import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/timer_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/images_manager.dart';
import '../screens/audio_player_screen.dart';

class PlayerWidget extends StatefulWidget {
  final String audioAddress;
  final String title;
  final AudioType audioType;
  final AudioPlayer player;

  const PlayerWidget({
    Key? key,
    required this.audioAddress,
    required this.title,
    required this.audioType,
    required this.player,
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late AudioPlayer _audioPlayer;
  late StreamSubscription<Duration?> _durationSubscription;
  late IconData _stopIcon;
  AudiosBloc bloc = AudiosBloc.get();
  Duration? _position;
  bool _isRepeating = false;
  Timer? _timer;
  int? _timerDuration;
  DateTime? _timerEndTime;

  bool get _isPlaying => _audioPlayer.playing;

  IconData get _playPauseIcon => _isPlaying ? Icons.pause : Icons.play_arrow;

  double get _audioPlayerTimer => bloc.playbackTimerPercentage ?? 0.0;

  Duration? get _duration => _audioPlayer.duration;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.player;
    _stopIcon = Icons.stop;
    _position = Duration.zero;
    _initializeAudio();

    _durationSubscription = _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    if (widget.audioAddress != bloc.currentSurahUrl) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      _audioPlayer.playbackEventStream
          .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
      try {
        await _setAudioSource();
        bloc.currentSurahUrl = widget.audioAddress;
      } catch (e) {
        errorToast(msg: e.toString());
      }
    }
  }

  Future<void> _setAudioSource() async {
    final mediaItem = MediaItem(
      id: widget.audioAddress,
      title: widget.title,
      artist: bloc.currentReciter,
      artUri: Uri.parse(ImagesManager.notificationImage),
      album: bloc.currentMoshaf,
    );

    switch (widget.audioType) {
      case AudioType.url:
        await _audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(widget.audioAddress),
          tag: mediaItem,
        ));
        break;
      case AudioType.file:
        await _audioPlayer.setAudioSource(AudioSource.file(
          widget.audioAddress,
          tag: mediaItem,
        ));
        break;
      case AudioType.radio:
        await _audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(widget.audioAddress),
          tag: mediaItem,
        ));
        break;
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer
          .setLoopMode(_isRepeating ? LoopMode.one : LoopMode.off);
      await _audioPlayer.play();
    }
    setState(() {});
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.seek(Duration.zero);
    setState(() {});
  }

  Future<void> _onCompleted() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    if (_isRepeating) {
      await _audioPlayer.play();
    } else {
      setState(() {
        _position = Duration.zero;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    final twoDigitHours = twoDigits(duration.inHours);

    return duration.inHours == 0
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _timerEndTime != null
        ? _timerEndTime!.difference(DateTime.now())
        : Duration.zero;
    final progress = _timerDuration != null && _timerDuration! > 0
        ? 1 - remainingTime.inSeconds / (_timerDuration! * 60)
        : 0.0;
  
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _position != null && _duration != null
              ? '${_formatDuration(_position!)} / ${_formatDuration(_duration!)}'
              : '',
          style: const TextStyle(fontSize: 16.0),
        ),
        Slider(
          onChanged: (value) {
            final duration = _duration;
            if (duration != null) {
              final position = value * duration.inMilliseconds;
              _audioPlayer.seek(Duration(milliseconds: position.round()));
            }
          },
          value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TimerWidget(),
            if (widget.audioType != AudioType.radio)
              IconButton(
                onPressed: () {
                  setState(() {
                    _isRepeating = !_isRepeating;
                  });
                },
                icon: Icon(_isRepeating ? Icons.repeat_one : Icons.repeat),
              ),
            FloatingActionButton(
              onPressed: _togglePlayback,
              child: Icon(_playPauseIcon),
            ),
            IconButton(
              onPressed: _stopPlayback,
              icon: Icon(_stopIcon),
              color: _isPlaying ? ColorManager.primary : ColorManager.grey2,
            ),
          ],
        ),
        SizedBox(height: 3.h),
      ],
    );
  }
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer audioPlayer;
  final String id;
  final String title;
  final AudiosBloc bloc = AudiosBloc.get();
  static MediaItem? item;

  AudioPlayerHandler(
      {required this.id, required this.audioPlayer, required this.title}) {
    audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(MediaItem(
      id: id,
      title: title,
      artUri: Uri.parse(ImagesManager.notificationImage),
      artist: bloc.currentReciter,
    ));
  }

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> stop() => audioPlayer.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        audioPlayer.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }

  Future<void> updateItem(MediaItem newItem) async {
    item = newItem;
    mediaItem.add(newItem);
  }
}
