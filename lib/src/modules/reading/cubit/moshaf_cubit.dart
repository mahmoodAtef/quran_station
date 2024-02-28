import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran/quran.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';

import '../data/quran_data/juz_data.dart';
import '../data/quran_data/sura_index.dart';

part 'moshaf_state.dart';

class MoshafCubit extends Cubit<MoshafState> {
  static MoshafCubit? cubit;
  static MoshafCubit get() {
    cubit == null ? cubit = MoshafCubit() : DoNothingAction();
    return cubit!;
  }

  int currentPage = 1;
  String currentSura = "";
  String currentJuz = "";
  String quranText = "";
  List<String> pageLines = [];
  MoshafCubit() : super(MoshafInitial());
  Future saveCurrentPage() async {
    await CacheHelper.saveData(key: "defaultBookMark", value: currentPage);
  }

  Future getInitialPage() async {
    currentPage = await CacheHelper.getData(
          key: "defaultBookMark",
        ) ??
        1;
    print(currentPage);
  }

  String _getCurrentJuz() {
    String juzName = '';

    juzData.forEach((juz, page) {
      if (currentPage >= page) {
        juzName = juz;
      }
    });

    return juzName.isNotEmpty ? juzName : '';
  }

  String _getCurrentSurah() {
    String currentSurah = "";
    surahIndex.forEach((surah, page) {
      if (page <= currentPage) {
        currentSurah = surah;
      }
    });
    return currentSurah;
  }

  void getCurrentPageData() {
    quranText = getVersesTextByPage(
      currentPage,
      surahSeperator: SurahSeperator.surahNameArabic,
      verseEndSymbol: true,
    ).join('\n');
    currentJuz = _getCurrentJuz();
    currentSura = _getCurrentSurah();
    emit(GetPageDataState());
  }
}
