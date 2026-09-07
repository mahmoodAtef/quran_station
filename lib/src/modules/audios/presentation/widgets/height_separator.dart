// lib/src/modules/audios/presentation/widgets/height_separator.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeightSeparator extends StatelessWidget {
  const HeightSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(child: _buildLine(colorScheme)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: 1.8.w,
            height: 1.8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(0.3),
            ),
          ),
          Expanded(child: _buildLine(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildLine(ColorScheme colorScheme) {
    return Container(
      height: 0.15.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            colorScheme.outline.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}