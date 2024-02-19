part of 'audios_bloc.dart';

abstract class AudiosEvent extends Equatable {
  const AudiosEvent();
}

class GetAllRecitersEvent extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class AdvancedSearchEvent extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class SearchByNameEvent extends AudiosEvent {
  final String name;
  const SearchByNameEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class GetReciterEvent extends AudiosEvent {
  final int reciterId;
  const GetReciterEvent(this.reciterId);
  @override
  List<Object?> get props => [reciterId];
}

class GetMoshafDetailsEvent extends AudiosEvent {
  final int moshafId;
  const GetMoshafDetailsEvent(this.moshafId);
  @override
  List<Object?> get props => [moshafId];
}

class AddReciterToFavoritesEvent extends AudiosEvent {
  final int reciterId;
  const AddReciterToFavoritesEvent(this.reciterId);
  @override
  List<Object?> get props => [reciterId];
}

class RemoveReciterFromFavoritesEvent extends AudiosEvent {
  final int reciterId;
  const RemoveReciterFromFavoritesEvent(this.reciterId);
  @override
  List<Object?> get props => [reciterId];
}

class GetFavoriteRecitersEvent extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends AudiosEvent {
  final int index;
  const ChangeTabEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class GetMostPopularRecitersEvent extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class GetAllRadiosEvent extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class DownLoadSurah extends AudiosEvent {
  @override
  List<Object?> get props => [];
}
