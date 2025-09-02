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
  int? selectedMinutes;
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

    // Start pulse animation when timer is active
    _checkTimerStatus();
  }

  void _checkTimerStatus() {
    if (bloc.playbackTimerPercentage != null &&
        bloc.playbackTimerPercentage! > 0) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showTimerBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                          'حدد مدة المؤقت',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'سيتوقف التشغيل تلقائياً بعد انتهاء الوقت',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Progress Indicator
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'التقدم الحالي',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${((bloc.playbackTimerPercentage ?? 0.0) * 100).toInt()}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    BlocBuilder<AudiosBloc, AudiosState>(
                      builder: (context, state) {
                        return Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: colorScheme.outline.withOpacity(0.2),
                          ),
                          child: LinearProgressIndicator(
                            value: bloc.playbackTimerPercentage ?? 0.0,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                            minHeight: 8,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Timer Options
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: [5, 10, 20, 30, 45, 60, 90].length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final minutes = [5, 10, 20, 30, 45, 60, 90][index];
                    final isSelected = selectedMinutes == minutes;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withOpacity(0.8),
                                ],
                              )
                            : null,
                        color: isSelected ? null : colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: colorScheme.shadow.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4.w),
                          onTap: () {
                            setState(() {
                              selectedMinutes = minutes;
                            });
                            Navigator.pop(context);
                            bloc.add(SetPlaybackTimerEvent(minutes));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? colorScheme.onPrimary.withOpacity(0.2)
                                        : colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$minutes',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: isSelected
                                            ? colorScheme.onPrimary
                                            : colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$minutes دقيقة',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: isSelected
                                              ? colorScheme.onPrimary
                                              : colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'سيتوقف التشغيل بعد $minutes دقيقة',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: isSelected
                                              ? colorScheme.onPrimary
                                                  .withOpacity(0.8)
                                              : colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: colorScheme.onPrimary,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<AudiosBloc, AudiosState>(
      builder: (context, state) {
        _checkTimerStatus(); // Update animation based on timer status

        final isTimerActive = bloc.playbackTimerPercentage != null &&
            bloc.playbackTimerPercentage! > 0;

        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isTimerActive ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isTimerActive
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.tertiary,
                            colorScheme.tertiary.withOpacity(0.8),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.surfaceVariant,
                            colorScheme.surface,
                          ],
                        ),
                  boxShadow: isTimerActive
                      ? [
                          BoxShadow(
                            color: colorScheme.tertiary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Stack(
                  children: [
                    // Background Progress Circle
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: bloc.playbackTimerPercentage ?? 0.0,
                        strokeWidth: 3,
                        backgroundColor: isTimerActive
                            ? colorScheme.onTertiary.withOpacity(0.3)
                            : colorScheme.outline.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isTimerActive
                              ? colorScheme.onTertiary
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                    // Timer Icon Button
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => _showTimerBottomSheet(context),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Icon(
                              isTimerActive
                                  ? Icons.timer_rounded
                                  : Icons.timer_outlined,
                              color: isTimerActive
                                  ? colorScheme.onTertiary
                                  : colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
