// lib/src/modules/audios/presentation/widgets/surah_tafsir_item.dart
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/surah_tafsir_screen.dart';
import 'package:sizer/sizer.dart';

class SurahTafsirItem extends StatelessWidget {
  final int index;

  const SurahTafsirItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surahName = ConstanceManager.quranSurahsNames[index];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 4,
        shadowColor: colorScheme.shadow.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
        child: InkWell(
          onTap: () => context.push(
            SurahTafsirScreen(surahId: index + 1, surahName: surahName),
          ),
          borderRadius: BorderRadius.circular(4.w),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              gradient: LinearGradient(
                colors: [
                  colorScheme.tertiaryContainer.withOpacity(0.6),
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
                    color: colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Icon(Icons.library_books, color: colorScheme.onSurface, size: 6.w),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تفسير سورة $surahName",
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
                          Icon(Icons.school, size: 3.6.w, color: colorScheme.onSurface),
                          SizedBox(width: 1.w),
                          Text(
                            'تفسير وتأويل',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 4.w, color: colorScheme.onSurface.withOpacity(0.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}