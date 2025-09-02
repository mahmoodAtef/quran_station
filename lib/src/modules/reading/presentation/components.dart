import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AyaTafsir extends StatelessWidget {
  final String ayaText;
  final String tafsirText;
  const AyaTafsir({super.key, required this.ayaText, required this.tafsirText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 90.w,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(7.sp),
          child: Column(
            children: [
              Text(
                ayaText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontFamily: "hafs",
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                _removeAyaNumber(tafsirText),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _removeAyaNumber(String text) {
    return text
        .replaceAll("]", "")
        .replaceAll("[", "")
        .replaceAll("1", "")
        .replaceAll("2", "")
        .replaceAll("3", "")
        .replaceAll("4", "")
        .replaceAll("5", "")
        .replaceAll("6", "")
        .replaceAll("7", "")
        .replaceAll("8", "")
        .replaceAll("9", "")
        .replaceAll("0", "");
  }
}
