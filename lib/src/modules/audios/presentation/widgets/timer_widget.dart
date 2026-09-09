import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:sizer/sizer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  AudiosBloc bloc = AudiosBloc.get();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _checkTimerStatus();
  }

  void _checkTimerStatus() {
    if (bloc.playbackTimerPercentage != null &&
        bloc.playbackTimerPercentage! > 0) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showTimerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final isTimerActive = bloc.playbackTimerPercentage != null;

            return Container(
              height: 65.h,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
                    width: 12.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Icon(
                            Icons.timer_rounded,
                            color: colorScheme.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مؤقت إيقاف التشغيل',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isTimerActive)
                              Text(
                                'الوقت المتبقي: ${_formatDuration(bloc.remainingSeconds)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // خيار إيقاف المؤقت
                  if (isTimerActive)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ListTile(
                        onTap: () {
                          bloc.add(CancelPlaybackTimerEvent());
                          Navigator.pop(context);
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.timer_off_rounded,
                              color: Colors.red),
                        ),
                        title: const Text('إيقاف المؤقت الحالي',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.w),
                          side: BorderSide(color: Colors.red.withOpacity(0.2)),
                        ),
                      ),
                    ),

                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(4.w),
                      itemCount: [5, 10, 20, 30, 45, 60, 90].length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        final minutes = [5, 10, 20, 30, 45, 60, 90][index];
                        final isSelected = bloc.selectedTimerMinutes == minutes;

                        return ListTile(
                          onTap: () {
                            bloc.add(SetPlaybackTimerEvent(minutes));
                            Navigator.pop(context);
                          },
                          selected: isSelected,
                          selectedTileColor:
                              colorScheme.primaryContainer.withOpacity(0.3),
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? colorScheme.primary
                                : colorScheme.surfaceVariant,
                            child: Text(
                              '$minutes',
                              style: TextStyle(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          title: Text('$minutes دقيقة',
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: colorScheme.primary)
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.w),
                            side: BorderSide(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline.withOpacity(0.1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudiosBloc, AudiosState>(
      builder: (context, state) {
        _checkTimerStatus();
        final isTimerActive = bloc.playbackTimerPercentage != null;

        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isTimerActive ? _pulseAnimation.value : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isTimerActive)
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: 1 - (bloc.playbackTimerPercentage ?? 0),
                        strokeWidth: 3,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      isTimerActive ? Icons.timer_rounded : Icons.timer_outlined,
                      color: isTimerActive
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onPressed: () => _showTimerBottomSheet(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
