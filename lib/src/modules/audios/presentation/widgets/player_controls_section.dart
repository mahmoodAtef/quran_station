// lib/src/modules/audios/presentation/widgets/player_controls_section.dart
import 'package:flutter/material.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/timer_widget.dart';
import 'package:sizer/sizer.dart';

import '../screens/audio_player_screen.dart';

class PlayerControlsSection extends StatelessWidget {
  final AudioType audioType;
  final bool isPlaying;
  final bool isRepeating;
  final AnimationController playButtonController;
  final VoidCallback onTogglePlayback;
  final VoidCallback onToggleRepeat;
  final VoidCallback onStop;

  const PlayerControlsSection({
    Key? key,
    required this.audioType,
    required this.isPlaying,
    required this.isRepeating,
    required this.playButtonController,
    required this.onTogglePlayback,
    required this.onToggleRepeat,
    required this.onStop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const TimerWidget(),
        if (audioType != AudioType.radio) _buildRepeatButton(colorScheme),
        _buildPlayButton(colorScheme),
        _buildStopButton(colorScheme),
         SizedBox(width: 3.w),
      ],
    );
  }

  Widget _buildRepeatButton(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isRepeating
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      child: IconButton(
        onPressed: onToggleRepeat,
        icon: Icon(
          isRepeating ? Icons.repeat_one_rounded : Icons.repeat_rounded,
          color: isRepeating ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildPlayButton(ColorScheme colorScheme) {
    return Container(
      width: 18.w,
      height: 18.w,
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
            blurRadius: 4.w,
            offset: Offset(0, 1.5.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9.w),
          onTap: onTogglePlayback,
          child: AnimatedBuilder(
            animation: playButtonController,
            builder: (context, child) {
              return Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: colorScheme.onPrimary,
                size: 8.w,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStopButton(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlaying
            ? colorScheme.error
            : colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      child: IconButton(
        onPressed: onStop,
        icon: Icon(
          Icons.stop_rounded,
          color: isPlaying ? colorScheme.onError : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}