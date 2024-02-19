import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:sizer/sizer.dart';

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
  bool get _isPlaying => _audioPlayer.playing;
  IconData get _playPauseIcon => _audioPlayer.playing ? Icons.pause : Icons.play_arrow;
  late IconData _stopIcon;
  Duration? get _duration => _audioPlayer.duration;
  Duration? _position;
  late StreamSubscription<Duration?> _durationSubscription;
  AudiosBloc bloc = AudiosBloc.get();
  bool _isRepeating = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.player;
    _stopIcon = Icons.stop;
    _position = Duration.zero;

    _initAudio();

    _durationSubscription = _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    // Subscribe to audio player completion event
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    super.dispose();
  }

  Future<void> _initAudio() async {
    if (widget.audioAddress != bloc.currentSurahUrl) {
      try {
        switch (widget.audioType) {
          case AudioType.url:
            await _audioPlayer.setUrl(widget.audioAddress);
            bloc.currentSurahUrl = widget.audioAddress;
            break;
          case AudioType.file:
            await _audioPlayer.setFilePath(widget.audioAddress);
            bloc.currentSurahUrl = widget.audioAddress;
            break;
          case AudioType.radio:
            await _audioPlayer.setUrl(widget.audioAddress);
            bloc.currentSurahUrl = widget.audioAddress;
            break;
        }
        AudioService.start(backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint);
      } catch (e) {
        print("Error initializing audio: $e");
      }
    }
  }

  void _audioPlayerTaskEntrypoint() {
    AudioServiceBackground.run(() => AudioPlayerTask(audioPlayer: _audioPlayer));
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {});
    } else {
      if (_isRepeating) {
        await _audioPlayer.setLoopMode(LoopMode.one);
      } else {
        await _audioPlayer.setLoopMode(LoopMode.off);
      }
      await _audioPlayer.play();
      setState(() {});
    }
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.seek(Duration.zero);
    setState(() {});
  }

  Future<void> _onCompleted() async {
    await _audioPlayer.stop();
    if (_isRepeating) {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } else {
      await _audioPlayer.seek(Duration.zero);
      setState(() {
        _position = Duration.zero;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);

    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (duration == null) {
              return;
            }
            final position = value * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
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
        SizedBox(
          height: 3.h,
        )
      ],
    );
  }
}
