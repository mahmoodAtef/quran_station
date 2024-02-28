import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';

class QuranPage extends StatelessWidget {
  final int pageNumber;

  const QuranPage({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
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
                  fit: BoxFit.fill, image: AssetImage("assets/quran_data/quran_images/empty.png"))
              : const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/quran_data/quran_images/empty_2.png")),
          color: ColorManager.card,
          borderRadius: BorderRadius.only(
            bottomLeft: pageNumber.isOdd ? Radius.circular(10.sp) : Radius.zero,
            topLeft: pageNumber.isOdd ? Radius.circular(10.sp) : Radius.zero,
            bottomRight: pageNumber.isEven ? Radius.circular(10.sp) : Radius.zero,
            topRight: pageNumber.isEven ? Radius.circular(10.sp) : Radius.zero,
          ),
          border: Border(
              left: pageNumber.isEven
                  ? const BorderSide(
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: ColorManager.black,
                      width: 2,
                    )
                  : const BorderSide(
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: ColorManager.black,
                      width: .5,
                    ),
              right: pageNumber.isOdd
                  ? const BorderSide(
                      strokeAlign: BorderSide.strokeAlignInside,
                      color: ColorManager.black,
                      width: 2,
                    )
                  : BorderSide.none,
              bottom: const BorderSide(
                strokeAlign: BorderSide.strokeAlignInside,
                color: ColorManager.black,
                width: 2,
              ),
              top: const BorderSide(
                strokeAlign: BorderSide.strokeAlignInside,
                color: ColorManager.black,
                width: 2,
              ))),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Expanded(
              child: ColorFiltered(
                colorFilter: const ColorFilter.srgbToLinearGamma(),
                child: Image.asset(
                  "assets/quran_data/quran_images/$pageNumber.webp",
                  fit: pageNumber == 1 || pageNumber == 2 ? BoxFit.cover : BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
