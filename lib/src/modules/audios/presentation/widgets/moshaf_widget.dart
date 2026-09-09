// lib/src/modules/audios/presentation/widgets/moshaf_widget.dart
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/mushaf_screen.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/moshaf/moshaf.dart';

class MoshafWidget extends StatelessWidget {
  final Moshaf moshaf;

  const MoshafWidget({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        child: InkWell(
          onTap: () => context.push(MoshafScreen(moshaf: moshaf)),
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
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
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(Icons.menu_book, color: colorScheme.primary, size: 6.w),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moshaf.moshafData.name,
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
                          Icon(Icons.audiotrack, size: 3.6.w, color: colorScheme.primary),
                          SizedBox(width: 1.w),
                          Text(
                            '${moshaf.moshafData.surahTotal} تسجيل',
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
