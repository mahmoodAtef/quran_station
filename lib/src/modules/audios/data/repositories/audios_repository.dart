import 'package:dartz/dartz.dart';
import 'package:quran_station/src/modules/audios/data/data_sources/audios_remote_data_source.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_data.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_model.dart';

import '../models/moshaf.dart';
import '../models/moshaf_data.dart';

class AudiosRepository {
  final BaseAudiosRemoteDataSource baseAudiosRemoteDataSource = AudiosRemoteDataSource();
  Future<Either<Exception, List<ReciterData>>> getReciterData() async {
    return baseAudiosRemoteDataSource.getRecitersData();
  }

  Future<Either<Exception, List<MoshafData>>> getReciterDetails({required int reciterId}) {
    return baseAudiosRemoteDataSource.getReciterDetails(reciterId: reciterId);
  }

  Future<Either<Exception, MoshafDetails>> getMoshafDetails({required int moshafId}) {
    return baseAudiosRemoteDataSource.getMoshafDetails(moshafId: moshafId);
  }
}
