import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/main/presentation/screens/main_screen.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/local/shared_prefrences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Text(
                "كَلَامُ رَبِّي",
                style: TextStylesManager.titleBoldStyle,
              ),
              // SizedBox(height: .1.h),
              const Text(
                "تجربة قرآنية متكاملة",
                style: TextStylesManager.regularBoldStyle,
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 60.h,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 57.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.sp)),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/onBoarding.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: DefaultButton(
                          onPressed: () async {
                            CacheHelper.saveData(key: "showSplash", value: false);
                            context.pushAndRemove(const MainScreen());
                          },
                          title: "ابدأ الاستخدام"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
