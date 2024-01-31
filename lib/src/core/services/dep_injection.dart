
import 'package:get_it/get_it.dart';

import '../../modules/audios/data/data_sources/audios_remote_data_source.dart';
import '../../modules/audios/data/repositories/audios_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    /// auth
    BaseAudiosRemoteDataSource baseAudiosRemoteDataSource = AudiosRemoteDataSource();
    sl.registerLazySingleton(() => baseAudiosRemoteDataSource);

    AudiosRepository baseAudiosRepository = AudiosRepository();
    sl.registerLazySingleton(() => baseAudiosRepository);



  }
}
