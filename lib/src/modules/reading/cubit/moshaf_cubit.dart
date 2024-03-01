import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran/quran.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/modules/reading/data/quran_data/sura_data.dart';

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
  int currentTafsirPage = 1;
  String currentSura = "";
  String currentJuz = "";
  String quranText = "";
  List<String> pageLines = [];
  String tafsirString = "";
  List<Map<String, dynamic>> currentTafsirPageData = [];
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
    suraData.forEach((surah, data) {
      if (data['الصفحة'] <= currentPage) {
        currentSurah = surah;
      }
    });
    return currentSurah;
  }

  void getCurrentPageData() {
    currentJuz = _getCurrentJuz();
    currentSura = _getCurrentSurah();
    emit(GetPageDataState());
  }

  Future<void> loadJsonData() async {
    emit(LoadingTafsirJsonState());
    tafsirString = await rootBundle.loadString('assets/quran_data/tafsir.json');
    emit(TafsirJsonLoadedState());
  }

  void extractVersesAndTafsir(int pageNumber) {
    emit(LoadPageTafsirState());
    List<Map<String, dynamic>> result = [];

    List<dynamic> data = json.decode(tafsirString);
    for (var item in data) {
      if (item['page'] == pageNumber.toString()) {
        result.add({'verse': item['aya_text'], 'tafsir': item['aya_tafseer']});
      }
    }
    currentTafsirPageData = result;
    emit(GetPageTafsirState());
  }
}
