import 'package:quran_station/src/modules/audios/data/models/tafsir/tafsir.dart';

class SurahTafsir {
  final int surahId;
  List<Tafsir>? tafsir = [];
  SurahTafsir(this.surahId, {this.tafsir});

  factory SurahTafsir.fromId(int id) {
    return SurahTafsir(id);
  }
}
