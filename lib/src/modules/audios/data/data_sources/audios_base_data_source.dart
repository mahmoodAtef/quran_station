import 'package:dartz/dartz.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter/reciter_data.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/tafsir.dart';

abstract class BaseAudiosRemoteDataSource {
  Future<Either<Exception, List<ReciterData>>> getRecitersData();

  Future<Either<Exception, List<MoshafData>>> getReciterDetails(
      {required int reciterId});

  Future<Either<Exception, MoshafDetails>> getMoshafDetails(
      {required int moshafId});

  Future<Either<Exception, List<int>>> getMostPopularReciters();

  Future<Either<Exception, List<RadioModel>>> getRadios();

  Future<Either<Exception, List<Tafsir>>> getSurahTafsir(int surahId);

  Future<Either<Exception, Unit>> downloadSurah(
      String url, String readerName, String surahName,
      {required Function(double) onProgress});
}
