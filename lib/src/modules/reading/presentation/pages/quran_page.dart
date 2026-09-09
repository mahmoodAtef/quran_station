import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuranPage extends StatelessWidget {
  final int pageNumber;

  const QuranPage({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSpecialPage = pageNumber == 1 || pageNumber == 2;

    return Container(
      margin: EdgeInsets.only(
        right: pageNumber.isOdd ? 1.sp : 0,
        top: 5.sp,
        bottom: 5.sp,
        left: pageNumber.isEven ? 1.sp : 0,
      ),
      decoration: BoxDecoration(
          image: pageNumber.isOdd
              ? const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/quran_data/quran_images/empty.png"))
              : const DecorationImage(
                  fit: BoxFit.fill,
                  image:
                      AssetImage("assets/quran_data/quran_images/empty_2.png")),
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            bottomLeft: pageNumber.isOdd ? Radius.circular(10.sp) : Radius.zero,
            topLeft: pageNumber.isOdd ? Radius.circular(10.sp) : Radius.zero,
            bottomRight:
                pageNumber.isEven ? Radius.circular(10.sp) : Radius.zero,
            topRight: pageNumber.isEven ? Radius.circular(10.sp) : Radius.zero,
          ),
          border: Border(
              left: pageNumber.isEven
                  ? BorderSide(
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: theme.colorScheme.outline,
                      width: 2,
                    )
                  : BorderSide(
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: theme.colorScheme.outline,
                      width: .5,
                    ),
              right: pageNumber.isOdd
                  ? BorderSide(
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: theme.colorScheme.outline,
                      width: 2,
                    )
                  : BorderSide.none,
              bottom: BorderSide(
                strokeAlign: BorderSide.strokeAlignInside,
                color: theme.colorScheme.outline,
                width: 2,
              ),
              top: BorderSide(
                strokeAlign: BorderSide.strokeAlignInside,
                color: theme.colorScheme.outline,
                width: 2,
              ))),
      child: Padding(
        padding: isSpecialPage 
            ? EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h) 
            : EdgeInsets.all(4.w),
        child: ColorFiltered(
          colorFilter: const ColorFilter.srgbToLinearGamma(),
          child: Image.asset(
            "assets/quran_data/quran_images/$pageNumber.webp",
            fit: isSpecialPage ? BoxFit.contain : BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
