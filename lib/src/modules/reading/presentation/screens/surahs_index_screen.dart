import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:quran_station/src/modules/reading/data/quran_data/sura_data.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/styles_manager.dart';
import '../../../audios/presentation/widgets/components.dart';

class SurahsIndexScreen extends StatelessWidget {
  const SurahsIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, dynamic>> surahs = suraData.entries.toList();

    MoshafCubit cubit = MoshafCubit.get();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "فهرس السور",
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: ListView.separated(
            itemBuilder: (context, index) => ItemWidget(
                subTitle:
                    "${surahs[index].value["type"]}/ عدد آياتها : ${surahs[index].value["verses_count"]}",
                suffix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  child: Text(
                    "صفحة ${surahs[index].value["page_number"]}",
                    style: TextStylesManager.regularWhiteStyle,
                  ),
                ),
                onPressed: () {
                  cubit.controller.jumpToPage(surahs[index].value["page_number"] - 1);
                  context.pop();
                },
                title: "سورة ${surahs[index].key}"),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: surahs.length),
      ),
    );
  }
}
