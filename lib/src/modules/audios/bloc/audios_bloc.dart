import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/exceptions/exception_manager.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter/reciter_model.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/surah_tafsir.dart';
import 'package:quran_station/src/modules/audios/data/repositories/audios_repository.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/audio_player.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/pages/radios_page.dart';
import '../data/models/moshaf/moshaf_details.dart';
import '../presentation/widgets/pages/all_reciters_page.dart';
import '../presentation/widgets/pages/favourites_reciters_page.dart';
import '../presentation/widgets/pages/most_popular_reciters_page.dart';
import '../presentation/widgets/pages/tafsir_page.dart';

part 'audios_event.dart';
part 'audios_state.dart';

class AudiosBloc extends Bloc<AudiosEvent, AudiosState> {
  static AudiosBloc bloc = AudiosBloc();
  factory AudiosBloc.get() {
    return bloc;
  }

  /// get all reciters
  /// get reciter moshafs
  /// get reciter moshaf surahs
  /// add reciter to favorite
  /// remove reciter from favorite
  /// most popular reciters
  /// play surah
  /// search for reciter by name
  /// play quarn radio
  /// get surah tafsir
  // download surah and play local audios

  AudiosRepository repository = AudiosRepository();
  List<Reciter> reciters = [];
  List<Reciter> advancedSearchResult = [];
  List<String> mushafSurahs = [];
  List<Reciter> searchByNameResult = [];
  List<Reciter> favoriteReciters = [];
  AudioPlayer audioPlayer = AudioPlayer();
  String? currentSurahUrl;
  List<String> tabs = const [
    " كل القراء ",
    " قرائي المفضلين ",
    "أبرز القراء ",
    " الإذاعات ",
    " تفسير الطبري "
  ];
  List<Widget> audioTabsWidgets = const [
    AllRecitersPage(),
    FavouritesRecitersPage(),
    MostPopularRecitersPage(),
    RadiosPage(),
    TafsirPage()
  ];
  List<SurahTafsir> quranTafsir = List<SurahTafsir>.from(ConstanceManager.quranSurahsNames.map((e) {
    return SurahTafsir.fromId(ConstanceManager.quranSurahsNames.indexOf(e) + 1);
  }));
  int currentTab = 0;
  String? currentReciter;
  late String currentMoshaf;
  List<Reciter> mostPopularReciters = [];
  List<int> mostPopularRecitersIds = [];
  List<RadioModel> radios = [];
  AudioPlayerHandler? handler;
  AudiosBloc() : super(AudiosInitial()) {
    on<AudiosEvent>((event, emit) async {
      if (event is GetAllRecitersEvent) {
        if (reciters.isEmpty) {
          print("))))))))))))))))))))");
          emit(GetAllRecitersLoadingState());
          var response = await repository.getRecitersData();
          response.fold((l) {
            emit(GetAllRecitersErrorState(l));
          }, (r) {
            reciters = r.map((e) => Reciter(e)).toList();
            emit(GetAllRecitersSuccessState());
          });
        }
      } else if (event is GetReciterEvent) {
        if (_isReciterEmpty(event.reciterId)) {
          emit(GetReciterLoadingState());
          var response = await repository.getReciterDetails(reciterId: event.reciterId);
          response.fold((l) {
            emit(GetReciterErrorState(l));
          }, (r) {
            int reciterIndex = _getReciterIndex(event.reciterId);
            reciters[reciterIndex].moshafs = [];
            reciters[reciterIndex].moshafs!.addAll(r.map((e) => Moshaf(e)).toList());
            emit(GetReciterSuccessState());
          });
        } else {
          DoNothingAction();
        }
      } else if (event is SearchByNameEvent) {
        emit(GetSearchByNameLoadingState());
        searchByNameResult.clear();
        searchByNameResult
            .addAll(reciters.where((element) => (element.data.name.contains(event.name))));
        emit(GetSearchByNameResult(searchByNameResult));
      } else if (event is GetMoshafDetailsEvent) {
        emit(GetMoshafDetailsLoadingState());
        var response = await repository.getMoshafDetails(moshafId: event.moshafId);
        response.fold((l) {
          emit(GetMoshafDetailsErrorState(l));
        }, (r) {
          _addMoshafDetails(r, event.moshafId);
          emit(GetMoshafDetailsSuccessState(r));
        });
      } else if (event is GetFavoriteRecitersEvent) {
        if (favoriteReciters.isEmpty && reciters.isNotEmpty) {
          emit(GetFavoriteRecitersLoadingState());
          await CacheHelper.getData(key: "favoriteReciters").then((value) {
            if (value != null && value != []) {
              favoriteReciters.clear();
              for (var e in value) {
                favoriteReciters
                    .add(reciters.firstWhere((element) => element.data.id == int.parse(e)));
              }
            }
          });
          emit(GetFavoriteRecitersSuccessState());
        }
      } else if (event is AddReciterToFavoritesEvent) {
        favoriteReciters.add(reciters.firstWhere((element) => element.data.id == event.reciterId));
        emit(AddReciterToFavoritesSuccessState(event.reciterId));
        await CacheHelper.saveData(
            key: "favoriteReciters",
            value: favoriteReciters.map((e) => e.data.id.toString()).toList());
      } else if (event is RemoveReciterFromFavoritesEvent) {
        favoriteReciters.removeWhere((element) => element.data.id == event.reciterId);
        emit(RemoveReciterFromFavoritesSuccessState(event.reciterId));
        await CacheHelper.saveData(
            key: "favoriteReciters",
            value: favoriteReciters.map((e) => e.data.id.toString()).toList());
      } else if (event is ChangeTabEvent) {
        currentTab = event.index;

        emit(ChangeTabState(currentTab));
      } else if (event is GetMostPopularRecitersEvent) {
        if (mostPopularReciters.isEmpty) {
          emit(GetMostPopularRecitersLoadingState());
          var response = await repository.getMostPopularReciters();
          response.fold((l) {
            emit(GetMostPopularRecitersErrorState(l));
          }, (r) {
            mostPopularReciters.addAll(reciters.where((element) => r.contains(element.data.id)));
            emit(GetMostPopularRecitersSuccessState());
          });
        }
      } else if (event is GetAllRadiosEvent) {
        if (radios.isEmpty) {
          emit(GetAllRadiosLoading());
          var response = await repository.getRadios();
          response.fold((l) {
            emit(GetRadiosErrorState(l));
          }, (r) {
            radios = r;
            emit(GetRadiosSuccessfulState());
          });
        }
      } else if (event is GetSurahTafsir) {
        if (_isSurahTafsirEmpty(event.surahId)) {
          emit(GetSurahTafsirLoading());
          var response = await repository.getSurahTafsir(event.surahId);
          response.fold((l) {
            emit(GetSurahTafsirErrorState(l));
          }, (r) {
            quranTafsir.firstWhere((element) => element.surahId == event.surahId).tafsir = r;
            emit(GetSurahTafsirSuccessfulState());
          });
        }
      }
    });
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
    int reciterIndex = reciters.indexWhere((element) => (element.moshafs != null &&
        element.moshafs!.indexWhere((element) => element.moshafData.id == moshafId) != -1));
    return reciterIndex;
  }

  int _searchForMoshafById(int reciterIndex, int moshafId) {
    return reciters[reciterIndex]
        .moshafs!
        .indexWhere((element) => element.moshafData.id == moshafId);
  }

  bool _isSurahTafsirEmpty(int id) {
    SurahTafsir surahTafsir = quranTafsir.firstWhere((element) => element.surahId == id);
    return surahTafsir.tafsir == null;
  }

  void setHandler({required String title}) {
    handler = AudioPlayerHandler(id: "currentSurahUrl", audioPlayer: audioPlayer, title: title);
  }

  Future updateMediaItem(MediaItem item) async {
    await handler!.updateItem(item);
  }
}
