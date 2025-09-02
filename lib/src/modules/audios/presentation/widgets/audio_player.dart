import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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

class _PlayerWidgetState extends State<PlayerWidget>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late StreamSubscription<Duration?> _durationSubscription;
  late AnimationController _playButtonController;
  late AnimationController _rotationController;
  AudiosBloc bloc = AudiosBloc.get();
  Duration? _position;
  bool _isRepeating = false;
  Timer? _timer;
  int? _timerDuration;
  DateTime? _timerEndTime;

  bool get _isPlaying => _audioPlayer.playing;
  Duration? get _duration => _audioPlayer.duration;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.player;
    _position = Duration.zero;

    // Animation controllers
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

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

      // Handle animation based on playing state
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
    _durationSubscription.cancel();
    _timer?.cancel();
    _playButtonController.dispose();
    _rotationController.dispose();
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
        errorToast(
          msg: e.toString(),
        );
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
    setState(() async {
      await _audioPlayer.seek(Duration.zero);
    });
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final remainingTime = _timerEndTime != null
        ? _timerEndTime!.difference(DateTime.now())
        : Duration.zero;
    final progress = _timerDuration != null && _timerDuration! > 0
        ? 1 - remainingTime.inSeconds / (_timerDuration! * 60)
        : 0.0;

    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Audio Progress Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              children: [
                // Time Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position != null ? _formatDuration(_position!) : '00:00',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      _duration != null ? _formatDuration(_duration!) : '00:00',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                // Modern Slider
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                        elevation: 4,
                      ),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 20),
                      activeTrackColor: colorScheme.primary,
                      inactiveTrackColor: colorScheme.outline.withOpacity(0.2),
                      thumbColor: colorScheme.primary,
                      overlayColor: colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Slider(
                      onChanged: (value) {
                        final duration = _duration;
                        if (duration != null) {
                          final position = value * duration.inMilliseconds;
                          _audioPlayer
                              .seek(Duration(milliseconds: position.round()));
                        }
                      },
                      value: (_position != null &&
                              _duration != null &&
                              _position!.inMilliseconds > 0 &&
                              _position!.inMilliseconds <
                                  _duration!.inMilliseconds)
                          ? _position!.inMilliseconds /
                              _duration!.inMilliseconds
                          : 0.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Controls Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Timer Widget
              const TimerWidget(),

              // Repeat Button (for non-radio)
              if (widget.audioType != AudioType.radio)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRepeating
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isRepeating = !_isRepeating;
                      });
                    },
                    icon: Icon(
                      _isRepeating
                          ? Icons.repeat_one_rounded
                          : Icons.repeat_rounded,
                      color: _isRepeating
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

              // Main Play/Pause Button
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(35),
                    onTap: _togglePlayback,
                    child: AnimatedBuilder(
                      animation: _playButtonController,
                      builder: (context, child) {
                        return Icon(
                          _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: colorScheme.onPrimary,
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Stop Button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPlaying
                      ? colorScheme.errorContainer
                      : colorScheme.surfaceVariant.withOpacity(0.5),
                ),
                child: IconButton(
                  onPressed: _stopPlayback,
                  icon: Icon(
                    Icons.stop_rounded,
                    color: _isPlaying
                        ? colorScheme.onError
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
        ],
      ),
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
