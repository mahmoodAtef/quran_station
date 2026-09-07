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
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
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
          borderRadius: BorderRadius.circular(4.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondaryContainer.withOpacity(0.3),
                  colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 13.w,
                  height: 13.w,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.5.w),
                  ),
                  child: Icon(Icons.radio, color: colorScheme.secondary, size: 6.w),
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
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Icon(Icons.live_tv, size: 3.6.w, color: colorScheme.secondary),
                          SizedBox(width: 1.w),
                          Text(
                            'بث مباشر',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary,
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
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Icon(Icons.play_arrow, color: colorScheme.secondary, size: 5.w),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}