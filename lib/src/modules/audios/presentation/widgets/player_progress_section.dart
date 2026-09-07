// lib/src/modules/audios/presentation/widgets/player_progress_section.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerProgressSection extends StatelessWidget {
  final Duration position;
  final Duration? duration;
  final ValueChanged<double> onSeek;

  const PlayerProgressSection({
    Key? key,
    required this.position,
    required this.duration,
    required this.onSeek,
  }) : super(key: key);

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    final hours = two(d.inHours);
    return d.inHours == 0 ? "$minutes:$seconds" : "$hours:$minutes:$seconds";
  }

  double get _progressValue {
    final total = duration;
    if (total == null || total.inMilliseconds <= 0) return 0.0;
    final value = position.inMilliseconds / total.inMilliseconds;
    return value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                duration != null ? _formatDuration(duration!) : '00:00',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 0.8.h,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 1.6.w,
                elevation: 4,
              ),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 2.6.w),
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.outline.withOpacity(0.2),
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withOpacity(0.1),
            ),
            child: Slider(
              onChanged: onSeek,
              value: _progressValue,
            ),
          ),
        ],
      ),
    );
  }
}