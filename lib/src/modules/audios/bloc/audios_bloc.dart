import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter/reciter_model.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/surah_tafsir.dart';
import 'package:quran_station/src/modules/audios/data/repositories/audios_repository.dart';
import 'package:quran_station/src/modules/audios/presentation/pages/offline_reciters.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/audio_player_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_player.dart';

import '../data/data_sources/audios_local_data_source.dart';
import '../data/models/moshaf/moshaf_details.dart';
import '../presentation/pages/all_reciters_page.dart';
import '../presentation/pages/favourites_reciters_page.dart';
import '../presentation/pages/most_popular_reciters_page.dart';
import '../presentation/pages/radios_page.dart';
import '../presentation/pages/tafsir_page.dart';

part 'audios_event.dart';

part 'audios_state.dart';

class AudiosBloc extends Bloc<AudiosEvent, AudiosState> {
  static final AudiosBloc _bloc = AudiosBloc._internal();

  factory AudiosBloc.get() => _bloc;

  final AudiosRepository repository = AudiosRepository();
  List<Reciter> reciters = [];

  List<Reciter> favoriteReciters = [];
  AudioPlayer audioPlayer = AudioPlayer();
  List<String> downloadingAudios = [];
  final List<String> tabs = const [
    "كل القراء",
    "قرائي المفضلين",
    "بلا اتصال",
    "أبرز القراء",
    "الإذاعات",
    "تفسير الطبري"
  ];
  final List<Widget> audioTabsWidgets = const [
    AllRecitersPage(),
    FavouritesRecitersPage(),
    NoInternetAudiosPage(),
    MostPopularRecitersPage(),
    RadiosPage(),
    TafsirPage()
  ];
  final Map<String, double> downloadProgresses = {};

  final List<SurahTafsir> quranTafsir = List<SurahTafsir>.from(
    ConstanceManager.quranSurahsNames.map(
      (e) =>
          SurahTafsir.fromId(ConstanceManager.quranSurahsNames.indexOf(e) + 1),
    ),
  );
  List<RadioModel> radios = [];
  String? currentSurahUrl;
  int currentTab = 0;
  String? currentReciter;
  String currentMoshaf = '';
  List<Reciter> mostPopularReciters = [];
  List<int> mostPopularRecitersIds = [];
  AudioPlayerHandler? handler;
  double? downloadProgress;
  Timer? playbackTimer;
  double? playbackTimerPercentage;

  double get progress => downloadProgress ?? 0.0;

  AudiosBloc._internal() : super(AudiosInitial()) {
    on<AudiosEvent>((event, emit) async {
      if (event is GetAllRecitersEvent) {
        await _handleGetAllRecitersEvent(emit);
        print(state);
      } else if (event is GetReciterEvent) {
        await _handleGetReciterEvent(event, emit);
      } else if (event is SearchByNameEvent) {
        await _handleSearchByNameEvent(event, emit);
      } else if (event is GetMoshafDetailsEvent) {
        await _handleGetMoshafDetailsEvent(event, emit);
      } else if (event is GetFavoriteRecitersEvent) {
        await _handleGetFavoriteRecitersEvent(emit);
      } else if (event is AddReciterToFavoritesEvent) {
        await _handleAddReciterToFavoritesEvent(event, emit);
      } else if (event is RemoveReciterFromFavoritesEvent) {
        await _handleRemoveReciterFromFavoritesEvent(event, emit);
      } else if (event is ChangeTabEvent) {
        _handleChangeTabEvent(event, emit);
      } else if (event is GetMostPopularRecitersEvent) {
        await _handleGetMostPopularRecitersEvent(emit);
      } else if (event is GetAllRadiosEvent) {
        await _handleGetAllRadiosEvent(emit);
      } else if (event is GetSurahTafsir) {
        await _handleGetSurahTafsirEvent(event, emit);
      } else if (event is DownloadCurrentAudio) {
        await _handleDownloadCurrentAudioEvent(event, emit);
      } else if (event is CheckDownloadedEvent) {
        await _handleCheckDownloadedEvent(event, emit);
      } else if (event is UpdateProgressEvent) {
        _handleUpdateProgressEvent(event, emit);
      } else if (event is GetDownloadedAudiosEvent) {
        await _handleGetDownloadedAudiosEvent(emit);
      } else if (event is SetPlaybackTimerEvent) {
        _handleSetPlaybackTimerEvent(event, emit);
      } else if (event is CancelPlaybackTimerEvent) {
        _handleCancelPlaybackTimerEvent(emit);
      } else if (event is UpdatePlaybackTimerEvent) {
        _handleUpdatePlaybackTimerEvent(event, emit);
      } else if (event is DeleteDownloadedItemEvent) {
        AudiosLocalDataSource()
            .deleteDownloadedItem(event.path, event.isAudioFile);
        emit(DeleteDownloadedItemSuccessState(
          event.path,
        ));
      }
    });
  }

  Future<void> _handleGetAllRecitersEvent(emit) async {
    if (reciters.isEmpty) {
      emit(GetAllRecitersLoadingState());
      var response = await repository.getRecitersData();
      response.fold(
        (l) => emit(GetAllRecitersErrorState(l)),
        (r) {
          reciters = r.map((e) => Reciter(e)).toList();
          emit(GetAllRecitersSuccessState(reciters));
        },
      );
      return;
    }
  }

  Future<void> _handleGetReciterEvent(
      GetReciterEvent event, Emitter<AudiosState> emit) async {
    if (_isReciterEmpty(event.reciterId)) {
      emit(GetReciterLoadingState());
      var response =
          await repository.getReciterDetails(reciterId: event.reciterId);
      response.fold(
        (l) => emit(GetReciterErrorState(l)),
        (r) {
          int reciterIndex = _getReciterIndex(event.reciterId);
          reciters[reciterIndex].moshafs = r.map((e) => Moshaf(e)).toList();
          emit(GetReciterSuccessState());
        },
      );
    }
  }

  Future<void> _handleSearchByNameEvent(
      SearchByNameEvent event, Emitter<AudiosState> emit) async {
    emit(GetSearchByNameLoadingState());

    List<Reciter> searchByNameResult = reciters
        .where((element) => element.data.name.contains(event.name))
        .toList();
    emit(GetSearchByNameResult(searchByNameResult));
  }

  Future<void> _handleGetMoshafDetailsEvent(
    GetMoshafDetailsEvent event,
    Emitter<AudiosState> emit,
  ) async {
    emit(GetMoshafDetailsLoadingState());
    var response = await repository.getMoshafDetails(moshafId: event.moshafId);
    response.fold(
      (l) => emit(GetMoshafDetailsErrorState(l)),
      (r) {
        _addMoshafDetails(r, event.moshafId);
        emit(GetMoshafDetailsSuccessState(r));
      },
    );
  }

  Future<void> _handleGetFavoriteRecitersEvent(
      Emitter<AudiosState> emit) async {
    if (favoriteReciters.isEmpty && reciters.isNotEmpty) {
      emit(GetFavoriteRecitersLoadingState());
      await CacheHelper.getData(key: "favoriteReciters").then((value) {
        if (value != null && value.isNotEmpty) {
          favoriteReciters.clear();
          for (var e in value) {
            favoriteReciters.add(reciters
                .firstWhere((element) => element.data.id == int.parse(e)));
          }
        }
      });
      emit(GetFavoriteRecitersSuccessState());
    }
  }

  Future<void> _handleAddReciterToFavoritesEvent(
    AddReciterToFavoritesEvent event,
    Emitter<AudiosState> emit,
  ) async {
    favoriteReciters.add(
        reciters.firstWhere((element) => element.data.id == event.reciterId));
    emit(AddReciterToFavoritesSuccessState(event.reciterId));
    await CacheHelper.saveData(
      key: "favoriteReciters",
      value: favoriteReciters.map((e) => e.data.id.toString()).toList(),
    );
  }

  Future<void> _handleRemoveReciterFromFavoritesEvent(
    RemoveReciterFromFavoritesEvent event,
    Emitter<AudiosState> emit,
  ) async {
    favoriteReciters
        .removeWhere((element) => element.data.id == event.reciterId);
    emit(RemoveReciterFromFavoritesSuccessState(event.reciterId));
    await CacheHelper.saveData(
      key: "favoriteReciters",
      value: favoriteReciters.map((e) => e.data.id.toString()).toList(),
    );
  }

  void _handleChangeTabEvent(ChangeTabEvent event, Emitter<AudiosState> emit) {
    currentTab = event.index;
    emit(ChangeTabState(currentTab));
  }

  Future<void> _handleGetMostPopularRecitersEvent(
      Emitter<AudiosState> emit) async {
    if (mostPopularReciters.isEmpty) {
      emit(GetMostPopularRecitersLoadingState());
      var response = await repository.getMostPopularReciters();
      response.fold(
        (l) => emit(GetMostPopularRecitersErrorState(l)),
        (r) {
          mostPopularRecitersIds.clear();
          mostPopularReciters
              .addAll(reciters.where((element) => r.contains(element.data.id)));
          emit(GetMostPopularRecitersSuccessState());
        },
      );
    }
  }

  Future<void> _handleGetAllRadiosEvent(Emitter<AudiosState> emit) async {
    if (radios.isEmpty) {
      emit(GetAllRadiosLoading());
      var response = await repository.getRadios();
      response.fold(
        (l) => emit(GetRadiosErrorState(l)),
        (r) {
          radios = r;
          emit(GetRadiosSuccessfulState());
        },
      );
    }
  }

  Future<void> _handleGetSurahTafsirEvent(
      GetSurahTafsir event, Emitter<AudiosState> emit) async {
    if (_isSurahTafsirEmpty(event.surahId)) {
      emit(GetSurahTafsirLoading());
      var response = await repository.getSurahTafsir(event.surahId);
      response.fold(
        (l) => emit(GetSurahTafsirErrorState(l)),
        (r) {
          quranTafsir
              .firstWhere((element) => element.surahId == event.surahId)
              .tafsir = r;
          emit(GetSurahTafsirSuccessfulState());
        },
      );
    }
  }

  Future<void> _handleDownloadCurrentAudioEvent(
    DownloadCurrentAudio event,
    Emitter<AudiosState> emit,
  ) async {
    emit(CheckDownloadedAudioSuccessState(
        event.url, DownloadStatus.downloading));
    emit(DownloadAudioLoadingState(
        event.url, downloadProgresses[event.url] ?? 0.03));
    var response = await repository.downloadSurah(
      event.url,
      currentReciter!,
      "${ConstanceManager.quranSurahsNames[int.parse(currentSurahUrl!.split("/").last.replaceAll(".mp3", "")) - 1]} - $currentMoshaf.mp3",
      onProgress: (progress) async {
        add(UpdateProgressEvent(progress, event.url));
      },
    );
    response.fold(
      (l) {
        emit(DownloadAudioErrorState(l));
      },
      (r) async {
        downloadProgresses.remove(event.url);
        add(CheckDownloadedEvent(event.url));
      },
    );
  }

  Future<void> _handleCheckDownloadedEvent(
    CheckDownloadedEvent event,
    Emitter<AudiosState> emit,
  ) async {
    if (downloadProgresses[event.url] != null) {
      debugPrint("progress: ${downloadProgresses[event.url]}");
      emit(CheckDownloadedAudioSuccessState(
          event.url, DownloadStatus.downloading));
    } else {
      bool isDownloaded = await _checkIsAudioFileExist(event.url);
      emit(CheckDownloadedAudioSuccessState(
          event.url,
          isDownloaded
              ? DownloadStatus.downloaded
              : DownloadStatus.notDownloaded));
    }
  }

  void _handleUpdateProgressEvent(
    UpdateProgressEvent event,
    Emitter<AudiosState> emit,
  ) {
    downloadProgresses[event.url] = event.progress;
    emit(DownloadAudioLoadingState(
        event.url, downloadProgresses[event.url]!.toDouble()));
  }

  Future<void> _handleGetDownloadedAudiosEvent(
      Emitter<AudiosState> emit) async {
    emit(GetDownloadedAudiosLoadingState());
    var response = await AudiosLocalDataSource().getLocalReciters();
    response.fold(
      (l) => emit(GetDownloadedAudiosErrorState(l)),
      (r) {
        emit(GetDownloadedAudiosSuccessState(r));
      },
    );
  }

  bool _isReciterEmpty(int id) {
    Reciter reciter = reciters.firstWhere((element) => element.data.id == id);
    return reciter.moshafs == null;
  }

  int _getReciterIndex(int id) {
    return reciters.indexWhere((element) => element.data.id == id);
  }

  void _addMoshafDetails(MoshafDetails r, int moshafId) {
    int reciterIndex = _searchForReciterByMoshafId(moshafId);
    int moshafIndex = _searchForMoshafById(reciterIndex, moshafId);
    reciters[reciterIndex].moshafs![moshafIndex].moshafDetails = r;
  }

  int _searchForReciterByMoshafId(int moshafId) {
    return reciters.indexWhere(
      (element) =>
          element.moshafs != null &&
          element.moshafs!
                  .indexWhere((element) => element.moshafData.id == moshafId) !=
              -1,
    );
  }

  int _searchForMoshafById(int reciterIndex, int moshafId) {
    return reciters[reciterIndex]
        .moshafs!
        .indexWhere((element) => element.moshafData.id == moshafId);
  }

  bool _isSurahTafsirEmpty(int id) {
    SurahTafsir surahTafsir =
        quranTafsir.firstWhere((element) => element.surahId == id);
    return surahTafsir.tafsir == null;
  }

  void setHandler({required String title}) {
    handler = AudioPlayerHandler(
      id: "currentSurahUrl",
      audioPlayer: audioPlayer,
      title: title,
    );
  }

  Future<void> updateMediaItem(MediaItem item) async {
    await handler!.updateItem(item);
  }

  Future<bool> _checkIsAudioFileExist(String url) async {
    currentSurahUrl = url;
    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    return File(
          "${externalStorageDirectory!.path}/القراء/$currentReciter/${ConstanceManager.quranSurahsNames[int.parse(currentSurahUrl!.split("/").last.replaceAll(".mp3", "")) - 1]} - $currentMoshaf.mp3",
        ).existsSync() &&
        downloadProgresses[url] == null;
  }

  void _handleSetPlaybackTimerEvent(
      SetPlaybackTimerEvent event, Emitter<AudiosState> emit) async {
    playbackTimer?.cancel();
    final totalDuration = Duration(minutes: event.minutes);
    const interval = Duration(seconds: 1); // تحديث النسبة المؤوية كل ثانية
    final startTime = DateTime.now();

    playbackTimer = Timer.periodic(interval, (timer) async {
      final elapsedTime = DateTime.now().difference(startTime).inSeconds;
      final totalMilliseconds = totalDuration.inSeconds;
      add(UpdatePlaybackTimerEvent(elapsedTime / totalMilliseconds));
      // التحقق إذا انتهى الوقت
      if (elapsedTime >= totalMilliseconds) {
        await audioPlayer.stop();
        playbackTimer?.cancel();
        playbackTimer = null;
        playbackTimerPercentage = 1.0; // 100%
      }
    });
  }

  void _handleUpdatePlaybackTimerEvent(
      UpdatePlaybackTimerEvent event, Emitter<AudiosState> emit) async {
    playbackTimerPercentage = event.percentage;
    print(playbackTimerPercentage.toString() + "% \n\n");
    emit(TimerUpdateState(event.percentage));
  }

  void _handleCancelPlaybackTimerEvent(Emitter<AudiosState> emit) {
    playbackTimer?.cancel();
    playbackTimer = null;
    emit(TimerCancelledState());
  }
}
