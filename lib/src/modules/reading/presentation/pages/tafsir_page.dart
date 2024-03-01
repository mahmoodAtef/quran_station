import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:quran_station/src/modules/reading/cubit/moshaf_cubit.dart';
import 'package:quran_station/src/modules/reading/presentation/components.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';

class TextTafsirPage extends StatelessWidget {
  final int pageNumber;

  const TextTafsirPage({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    MoshafCubit cubit = MoshafCubit.get()..extractVersesAndTafsir(pageNumber);
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: BlocBuilder<MoshafCubit, MoshafState>(
        builder: (context, state) {
          return state is LoadPageTafsirState
              ? const SizedBox()
              : ListView.separated(
                  itemBuilder: (context, index) => AyaTafsir(
                      ayaText: cubit.currentTafsirPageData[index]["verse"],
                      tafsirText: cubit.currentTafsirPageData[index]["tafsir"]),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: cubit.currentTafsirPageData.length);
        },
      ),
    );
  }
}
