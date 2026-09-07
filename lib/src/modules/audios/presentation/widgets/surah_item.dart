// lib/src/modules/audios/presentation/widgets/surah_item.dart
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:sizer/sizer.dart';

class SurahItem extends StatelessWidget {
  final int surahId;

  const SurahItem({super.key, required this.surahId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surahIndex = surahId - 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            color: colorScheme.surface,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            leading: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Center(
                child: Text(
                  surahId.toString(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              ConstanceManager.quranSurahsNames[surahIndex],
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(Icons.play_circle_outline, color: colorScheme.primary, size: 6.w),
          ),
        ),
      ),
    );
  }
}