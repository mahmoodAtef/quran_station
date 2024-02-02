import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quran_station/src/core/local/shared_prefrences.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/repositories/audios_repository.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/pages/all_reciters_page.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/pages/favourites_reciters_page.dart';

import '../data/models/reciter_model.dart';

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
  // search for reciter by name
  // search for surah by name
  // play surah
  // play quarn radio
  // download surah
  AudiosRepository repository = AudiosRepository();
  List<Reciter> reciters = [];
  List<Reciter> advancedSearchResult = [];
  List<String> mushafSurahs = [];
  List<Reciter> searchByNameResult = [];
  List<Reciter> favoriteReciters = [];
  AudioPlayer audioPlayer = AudioPlayer();
  String? currentSurahUrl;
  List<String> tabs = const [" كل القراء ", " قرائي المفضلين "];
  List<Widget> audioTabsWidgets = const [
    AllRecitersPage(),
    FavouritesRecitersPage(),
  ];
  int currentTab = 0;

  AudiosBloc() : super(AudiosInitial()) {
    on<AudiosEvent>((event, emit) async {
      if (event is GetAllRecitersEvent) {
        if (reciters.isEmpty) {
          emit(GetAllRecitersLoadingState());
          var response = await repository.getReciterData();
          response.fold((l) {
            emit(GetAllRecitersErrorState(l));
          }, (r) {
            for (var element in r) {
              reciters.add(Reciter(element));
            }
            emit(GetAllRecitersSuccessState());
          });
        } else {
          emit(GetAllRecitersSuccessState());
        }
      } else if (event is GetReciterEvent) {
        emit(GetReciterLoadingState());
        if (_isReciterEmpty(event.reciterId)) {
          var response = await repository.getReciterDetails(reciterId: event.reciterId);
          response.fold((l) {
            emit(GetReciterErrorState(l));
          }, (r) {
            int reciterIndex = searchForReciterById(event.reciterId);
            print("reciter index is $reciterIndex");
            reciters[reciterIndex].moshafs = [];
            for (var element in r) {
              reciters[reciterIndex].moshafs?.add(Moshaf(element));
            }
            emit(GetReciterSuccessState());
          });
        } else {
          emit(GetReciterSuccessState());
        }
      } else if (event is SearchByNameEvent) {
        searchByNameResult.clear();
        searchByNameResult
            .addAll(reciters.where((element) => (element.data.name.contains(event.name))));
        emit(GetSearchByNameResult(searchByNameResult));
      } else if (event is GetMoshafDetailsEvent) {
        emit(GetMoshafDetailsLoadingState());
        var response = await repository.getMoshafDetails(moshafId: event.moshafId);
        response.fold((l) {
          print(l);
          emit(GetMoshafDetailsErrorState(l));
        }, (r) {
          print(r.surahsIds);
          _addMoshafDetails(r, event.moshafId);
          emit(GetMoshafDetailsSuccessState(r));
        });
      } else if (event is GetFavoriteRecitersEvent) {
        if (favoriteReciters.isEmpty) {
          await CacheHelper.getData(key: "favoriteReciters").then((value) {
            if (value != null) {
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
      }
    });
  }
  bool _isReciterEmpty(int id) {
    Reciter reciter = reciters.firstWhere((element) => element.data.id == id);
    return reciter.moshafs == null;
  }

  int searchForReciterById(int id) {
    print(reciters[223].data.name);
    return reciters.indexWhere((element) => element.data.id == id);
  }

  void _addMoshafDetails(MoshafDetails r, int moshafId) {
    int reciterIndex = _searchForReciterByMoshafId(moshafId);
    int moshafIndex = _searchForMoshafById(reciterIndex, moshafId);
    reciters[reciterIndex].moshafs![moshafIndex].moshafDetails = r;
    print(reciters[reciterIndex].moshafs![moshafIndex].moshafDetails);
  }

  int _searchForReciterByMoshafId(int moshafId) {
    print(moshafId);
    int reciterIndex = reciters.indexWhere((element) => (element.moshafs != null &&
        element.moshafs!.indexWhere((element) => element.moshafData.id == moshafId) != -1));
    print("reciter is ${reciters[reciterIndex].data.name}");
    return reciterIndex;
  }

  int _searchForMoshafById(int reciterIndex, int moshafId) {
    return reciters[reciterIndex]
        .moshafs!
        .indexWhere((element) => element.moshafData.id == moshafId);
  }
}
