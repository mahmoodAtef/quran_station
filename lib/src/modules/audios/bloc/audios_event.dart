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
