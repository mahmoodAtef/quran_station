// lib/src/modules/audios/presentation/widgets/radio_item.dart
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/audios_bloc.dart';
import '../../data/models/radio/radio.dart';

class RadioItem extends StatelessWidget {
  final RadioModel radio;

  const RadioItem({super.key, required this.radio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        child: InkWell(
          onTap: () {
            final bloc = AudiosBloc.get();
            bloc.currentReciter = "راديو";
            context.push(AudioPlayerScreen(
              audioAddress: radio.url,
              title: radio.name,
              audioType: AudioType.radio,
            ));
          },
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: colorScheme.surface,
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Icon(Icons.radio, color: colorScheme.primary.withOpacity(0.7), size: 6.w),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        radio.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.3.h),
                      Row(
                        children: [
                          Icon(Icons.live_tv, size: 3.2.w, color: colorScheme.primary.withOpacity(0.6)),
                          SizedBox(width: 1.w),
                          Text(
                            'بث مباشر',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Icon(Icons.play_arrow, color: colorScheme.primary.withOpacity(0.7), size: 5.w),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
