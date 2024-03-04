import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/tajweed/presentation/screens/tajweed_pdf_screen.dart';
import 'package:sizer/sizer.dart';

class TajweedMainScreen extends StatelessWidget {
  const TajweedMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تجويد القرآن الكريم",
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            ItemWidget(
                icon: Icons.picture_as_pdf,
                subTitle: "إعداد مجمع الملك فهد لطباعة المصحف الشريف",
                onPressed: () {
                  context.push(const TajweedPdfScreen());
                },
                title: "كتاب التجويد الميسر"),
            const Spacer(),
            const Text(
              "انتظروا قريبا دورة التجويد الميسر لفضيلة الشيخ أحمد محيي الدين",
              style: TextStylesManager.regularBoldStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
