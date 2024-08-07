import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_station/src/modules/audios/data/data_sources/audios_base_data_source.dart';
import 'package:quran_station/src/modules/audios/data/data_sources/audios_remote_data_source.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter/reciter_data.dart';
import '../models/tafsir/tafsir.dart';

class AudiosRepository {
  final BaseAudiosRemoteDataSource baseAudiosRemoteDataSource = AudiosRemoteDataSource();
  Future<Either<Exception, List<ReciterData>>> getRecitersData() async {
    return baseAudiosRemoteDataSource.getRecitersData();
  }

  Future<Either<Exception, List<MoshafData>>> getReciterDetails({required int reciterId}) {
    return baseAudiosRemoteDataSource.getReciterDetails(reciterId: reciterId);
  }

  Future<Either<Exception, MoshafDetails>> getMoshafDetails({required int moshafId}) {
    return baseAudiosRemoteDataSource.getMoshafDetails(moshafId: moshafId);
  }

  Future<Either<Exception, List<int>>> getMostPopularReciters() {
    return baseAudiosRemoteDataSource.getMostPopularReciters();
  }

  Future<Either<Exception, List<RadioModel>>> getRadios() async {
    return baseAudiosRemoteDataSource.getRadios();
  }

  Future<Either<Exception, List<Tafsir>>> getSurahTafsir(int surahId) {
    return baseAudiosRemoteDataSource.getSurahTafsir(surahId);
  }
  Future<Either<Exception, Unit>>  downloadSurah(String url, String readerName, String surahName, {required  Function(double) onProgress , Emitter}) async{
    return baseAudiosRemoteDataSource.downloadSurah(url, readerName, surahName  , onProgress: onProgress);
  }
}
