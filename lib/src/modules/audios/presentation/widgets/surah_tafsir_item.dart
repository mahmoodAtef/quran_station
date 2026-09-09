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
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        child: InkWell(
          onTap: () => context.push(
            SurahTafsirScreen(surahId: index + 1, surahName: surahName),
          ),
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
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(Icons.library_books, color: colorScheme.primary.withOpacity(0.7), size: 6.w),
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
                      SizedBox(height: 0.3.h),
                      Row(
                        children: [
                          Icon(Icons.school, size: 3.2.w, color: colorScheme.primary.withOpacity(0.6)),
                          SizedBox(width: 1.w),
                          Text(
                            'تفسير وتأويل',
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
                Icon(Icons.arrow_forward_ios,
                    size: 3.5.w, color: colorScheme.onSurface.withOpacity(0.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
