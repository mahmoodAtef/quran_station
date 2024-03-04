import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/reading/data/quran_data/quran_virtue.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/font_manager.dart';

class ReadingQuranVirtueScreen extends StatelessWidget {
  const ReadingQuranVirtueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "فضل قراءة القرآن",
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "قد حثّ الله سبحانه وتعالى عباده المؤمنين على قراءة القرآن الكريم و تدبره و تعلمه و استماعه وذلك لما له من فضل عظيم وثواب كريم\nومن الآيات التي ذكرت فضل القرآن الكريم قولة تعالى :",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorManager.black,
                  fontWeight: FontWeightManager.semiBold,
                ),
              ),
              const HeightSeparator(),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: quranVirtueQuran
                    .map((e) => SizedBox(
                          width: 90.w,
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(7.sp),
                              child: Column(
                                children: [
                                  Text(
                                    e.key,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "hafs",
                                      color: ColorManager.primary,
                                      fontWeight: FontWeightManager.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    e.value,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: ColorManager.black,
                                      fontWeight: FontWeightManager.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const HeightSeparator(),
              Text(
                "وأيضا لرسول الله صلى ﷺ الكثير من الأحاديث الصحيحة لبيان فضل أن يكون للمؤمن شأن مع القرآن الكريم لما فيه من ثواب عظيم\n ومنها قوله ﷺ",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorManager.black,
                  fontWeight: FontWeightManager.semiBold,
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: quranVirtueAhadeeth
                    .map((e) => SizedBox(
                          width: 90.w,
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(7.sp),
                              child: Column(
                                children: [
                                  Text(
                                    e.key,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ColorManager.primary,
                                      fontWeight: FontWeightManager.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    e.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: ColorManager.black,
                                      fontWeight: FontWeightManager.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
