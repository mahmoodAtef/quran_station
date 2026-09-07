// lib/src/modules/audios/presentation/widgets/player_widget.dart
import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/player_controls_section.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/player_progress_section.dart';
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
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget>
    with TickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  late final StreamSubscription<Duration?> _positionSubscription;
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final AnimationController _playButtonController;
  late final AnimationController _rotationController;

  final AudiosBloc bloc = AudiosBloc.get();
  Duration _position = Duration.zero;
  bool _isRepeating = false;

  bool get _isPlaying => _audioPlayer.playing;
  Duration? get _duration => _audioPlayer.duration;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.player;

    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _initializeAudio();

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      setState(() => _position = position);
    });

    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            _onCompleted();
          }

          if (playerState.playing) {
            _playButtonController.forward();
            _rotationController.repeat();
          } else {
            _playButtonController.reverse();
            _rotationController.stop();
          }
        });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _playerStateSubscription.cancel();
    _playButtonController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    if (widget.audioAddress == bloc.currentSurahUrl) return;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _audioPlayer.playbackEventStream.listen(
          (event) {},
      onError: (Object e, StackTrace stackTrace) {},
    );

    try {
      await _setAudioSource();
      bloc.currentSurahUrl = widget.audioAddress;
    } catch (e) {
      errorToast(msg: e.toString());
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

    final source = widget.audioType == AudioType.file
        ? AudioSource.file(widget.audioAddress, tag: mediaItem)
        : AudioSource.uri(Uri.parse(widget.audioAddress), tag: mediaItem);

    await _audioPlayer.setAudioSource(source);
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
    await _audioPlayer.pause();
    setState(() => _position = Duration.zero);
  }

  Future<void> _onCompleted() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    if (_isRepeating) {
      await _audioPlayer.play();
    } else {
      setState(() => _position = Duration.zero);
    }
  }

  void _onSeek(double value) {
    final duration = _duration;
    if (duration == null) return;
    final position = value * duration.inMilliseconds;
    _audioPlayer.seek(Duration(milliseconds: position.round()));
  }

  void _toggleRepeat() => setState(() => _isRepeating = !_isRepeating);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.w),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 5.w,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayerProgressSection(
            position: _position,
            duration: _duration,
            onSeek: _onSeek,
          ),
          SizedBox(height: 2.h),
          PlayerControlsSection(
            audioType: widget.audioType,
            isPlaying: _isPlaying,
            isRepeating: _isRepeating,
            playButtonController: _playButtonController,
            onTogglePlayback: _togglePlayback,
            onToggleRepeat: _toggleRepeat,
            onStop: _stopPlayback,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}