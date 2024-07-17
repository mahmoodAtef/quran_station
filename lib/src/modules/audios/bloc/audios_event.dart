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

class GetSurahTafsir extends AudiosEvent {
  final int surahId;

  const GetSurahTafsir(this.surahId);

  @override
  List<Object?> get props => [surahId];
}

class DownLoadSurah extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class DownloadCurrentAudio extends AudiosEvent {
  final String url;

  const DownloadCurrentAudio(this.url);

  @override
  List<Object?> get props => [];
}

class GetDownloadedAudiosEvent extends AudiosEvent {
  @override
  List<Object?> get props => [];
}

class CheckDownloadedEvent extends AudiosEvent {
  final String url;

  const CheckDownloadedEvent(this.url);

  @override
  List<Object?> get props => [];
}

class GetDownloadProgressEvent extends AudiosEvent {
  final String url;

  const GetDownloadProgressEvent(this.url);

  @override
  List<Object?> get props => [];
}

class UpdateProgressEvent extends AudiosEvent {
  final double progress;
  final String url;

  const UpdateProgressEvent(this.progress, this.url);

  @override
  List<Object?> get props => [progress, url];
}

class SetPlaybackTimerEvent extends AudiosEvent {
  final int minutes;

  const SetPlaybackTimerEvent(this.minutes);

  @override
  List<Object> get props => [minutes];
}

class CancelPlaybackTimerEvent extends AudiosEvent {
  @override
  List<Object> get props => [];
}

class UpdatePlaybackTimerEvent extends AudiosEvent {
  final double percentage;

  const UpdatePlaybackTimerEvent(this.percentage);

  @override
  List<Object> get props => [];
}

class DeleteDownloadedItemEvent extends AudiosEvent {
  final String path;
  final bool isAudioFile;

  const DeleteDownloadedItemEvent(this.path, this.isAudioFile);

  @override
  List<Object> get props => [path];
}
