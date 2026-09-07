// lib/src/modules/audios/presentation/widgets/tafsir_item.dart
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/audios_bloc.dart';
import '../../data/models/tafsir/tafsir.dart';

class TafsirItem extends StatelessWidget {
  final Tafsir tafsir;

  const TafsirItem({super.key, required this.tafsir});

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
            bloc.currentReciter = "الخلاصة من تفسير الطبري";
            context.push(AudioPlayerScreen(
              audioAddress: tafsir.url,
              title: tafsir.name,
              audioType: AudioType.url,
            ));
          },
          borderRadius: BorderRadius.circular(4.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.2),
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
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.5.w),
                  ),
                  child: Icon(Icons.mic, color: colorScheme.primary, size: 6.w),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tafsir.name,
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
                          Icon(Icons.headphones, size: 3.6.w, color: colorScheme.primary),
                          SizedBox(width: 1.w),
                          Text(
                            'تسجيل صوتي',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
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
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Icon(Icons.play_arrow, color: colorScheme.primary, size: 5.w),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}