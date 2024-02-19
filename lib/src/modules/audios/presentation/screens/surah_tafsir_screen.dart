import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/surah_tafsir.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/color_manager.dart';
import '../../../../core/utils/styles_manager.dart';

class SurahTafsirScreen extends StatelessWidget {
  final int surahId;
  final String surahName;
  const SurahTafsirScreen({super.key, required this.surahId, required this.surahName});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get()..add(GetSurahTafsir(surahId));
    SurahTafsir surahTafsir = bloc.quranTafsir.firstWhere((element) => element.surahId == surahId);
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: appDrawer,
      appBar: CustomAppBar(
        height: 9.h,
        leadingWidth: 10.w,
        leading: IconButton(
            onPressed: () async {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: ColorManager.black,
            )),
        centerTitle: true,
        title: const Text(
          'الصوتيات',
          style: TextStylesManager.appBarTitle,
        ),
      ),
      body: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return state is GetSurahTafsirLoading || surahTafsir.tafsir == null
                ? const LinearProgressIndicator()
                : Padding(
                    padding: EdgeInsets.all(5.w),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return TafsirItem(tafsir: surahTafsir.tafsir![index]);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: surahTafsir.tafsir!.length),
                  );
          }),
    );
  }
}
