import 'package:dartz/dartz.dart';
import 'package:quran_station/src/modules/audios/data/data_sources/audios_remote_data_source.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/models/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_data.dart';

import '../models/moshaf_data.dart';

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
}
