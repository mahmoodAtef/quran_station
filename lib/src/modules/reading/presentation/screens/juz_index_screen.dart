import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/core/utils/styles_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:quran_station/src/modules/reading/data/quran_data/juz_data.dart';
import 'package:sizer/sizer.dart';

class JuzIndexScreen extends StatelessWidget {
  const JuzIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, int>> juzIndexes = juzData.entries.toList();
    MoshafCubit cubit = MoshafCubit.get();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "فهرس الأجزاء",
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: ListView.separated(
            itemBuilder: (context, index) => ItemWidget(
                suffix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  child: Text(
                    "صفحة ${juzIndexes[index].value}",
                    style: TextStylesManager.regularWhiteStyle,
                  ),
                ),
                onPressed: () {
                  cubit.controller.jumpToPage(juzIndexes[index].value - 1);
                  context.pop();
                },
                title: "الجزء ${juzIndexes[index].key}"),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 30),
      ),
    );
  }
}
