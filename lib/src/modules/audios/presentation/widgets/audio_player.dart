import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';

import '../screens/audioPlayerScreen.dart';

class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final String audioUrl;
  final AudioType audioType;
  const PlayerWidget({
    required this.player,
    super.key,
    required this.audioUrl,
    required this.audioType,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool _isLoading = false;
  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isCompleted => _playerState == PlayerState.completed;
  bool _willRepeat = false;
  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
            if (_willRepeat && _isCompleted) {
              _repeat();
            }
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.audioType != AudioType.radio
            ? Text(
                _position != null
                    ? '$_positionText / $_durationText'
                    : _duration != null
                        ? _durationText
                        : '',
                style: const TextStyle(fontSize: 16.0),
              )
            : const SizedBox(),
        Slider(
          onChanged: (value) {
            final duration = _duration;
            if (duration == null) {
              return;
            }
            final position = value * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
          value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 1.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.audioType != AudioType.radio)
              ActionButton(
                  onPressed: _changeRepeatState, iconData: Icons.repeat, enabled: _willRepeat),
            FloatingActionButton(
              onPressed: _isPlaying ? _pause : _play,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: ColorManager.white,
                    )
                  : Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            ActionButton(
                onPressed: _isPlaying || _isPaused ? _stop : null,
                iconData: Icons.stop,
                enabled: _isPlaying || _isPaused)
          ],
        ),
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
        if (_willRepeat) {
          _repeat();
        } else {
          _initStreams();
        }
      });
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    _changeLoadingState();
    await _playPlayer();
    setState(() => _playerState = PlayerState.playing);
    _changeLoadingState();
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  Future<void> _repeat() async {
    await player.play(UrlSource(widget.audioUrl));
    player.play(player.source!);
    setState(() => _playerState = PlayerState.playing);
  }

  void _changeRepeatState() {
    setState(() {
      _willRepeat = !_willRepeat;
    });
  }

  void _changeLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future _playPlayer() async {
    if (_isPaused) {
      await player.resume().then((value) {});
    } else {
      await _repeat();
    }
  }
}

class ActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData iconData;
  final bool enabled;
  const ActionButton(
      {super.key, required this.onPressed, required this.iconData, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 48.0,
      icon: Icon(
        iconData,
        color: enabled ? ColorManager.primary : ColorManager.grey2,
      ),
    );
  }
}
