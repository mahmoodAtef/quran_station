// surah_tafsir_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/surah_tafsir.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/tafsir_item.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/app_bar.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/main/presentation/widgets/connectivity.dart';
import 'package:sizer/sizer.dart';

class SurahTafsirScreen extends StatelessWidget {
  final int surahId;
  final String surahName;

  const SurahTafsirScreen(
      {super.key, required this.surahId, required this.surahName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AudiosBloc bloc = AudiosBloc.get()..add(GetSurahTafsir(surahId));
    SurahTafsir surahTafsir =
        bloc.quranTafsir.firstWhere((element) => element.surahId == surahId);
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: appDrawer(context),
      appBar: CustomAppBar(
        height: 9.h,
        leadingWidth: 10.w,
        leading: IconButton(
          onPressed: () async {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color,
          ),
        ),
        centerTitle: true,
        title: Text(
          'الصوتيات',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return state is GetSurahTafsirLoading || surahTafsir.tafsir == null
              ? LinearProgressIndicator(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                )
              : ConnectionWidget(
                  onRetry: () {
                    bloc.add(GetSurahTafsir(surahId));
                  },
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    padding: EdgeInsets.all(5.w),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return TafsirItem(tafsir: surahTafsir.tafsir![index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: theme.dividerColor,
                          thickness: theme.dividerTheme.thickness,
                        );
                      },
                      itemCount: surahTafsir.tafsir!.length,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
