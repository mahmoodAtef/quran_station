// ignore_for_file: must_be_immutable

part of 'audios_bloc.dart';

abstract class AudiosState extends Equatable {
  const AudiosState();
}

class AudiosInitial extends AudiosState {
  @override
  List<Object> get props => [];
}

/// all audios loading states extend this class
class AudiosLoading extends AudiosState {
  @override
  List<Object?> get props => [];
}

/// all audios Exception states extend this class
class AudiosError extends AudiosState {
  final Exception exception;

  const AudiosError(this.exception);

  @override
  List<Object?> get props => [];
}

class GetAllRecitersLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetAllRecitersSuccessState extends AudiosState {
  final List<Reciter> reciters;

  const GetAllRecitersSuccessState(this.reciters);

  @override
  List<Object?> get props => [reciters];
}

class GetAllRecitersErrorState extends AudiosError {
  const GetAllRecitersErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class AdvancedSearchLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class AdvancedSearchSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class AdvancedSearchErrorState extends AudiosError {
  const AdvancedSearchErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class GetMushafSurahsLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetMushafSurahsSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMushafSurahsErrorState extends AudiosError {
  const GetMushafSurahsErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class GetSearchByNameLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetSearchByNameResult extends AudiosState {
  final List<Reciter> result;

  const GetSearchByNameResult(this.result);

  @override
  List<Object?> get props => [result];
}

class GetReciterLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetReciterSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetReciterErrorState extends AudiosError {
  const GetReciterErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class GetMoshafDetailsLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetMoshafDetailsSuccessState extends AudiosState {
  final MoshafDetails moshafDetails;

  const GetMoshafDetailsSuccessState(this.moshafDetails);

  @override
  List<Object?> get props => [];
}

class GetMoshafDetailsErrorState extends AudiosError {
  const GetMoshafDetailsErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class AddReciterToFavoritesSuccessState extends AudiosState {
  final int reciterId;

  const AddReciterToFavoritesSuccessState(this.reciterId);

  @override
  List<Object?> get props => [
        reciterId,
      ];
}

class RemoveReciterFromFavoritesSuccessState extends AudiosState {
  final int reciterId;

  const RemoveReciterFromFavoritesSuccessState(this.reciterId);

  @override
  List<Object?> get props => [];
}

class GetFavoriteRecitersLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetFavoriteRecitersSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class ChangeTabState extends AudiosState {
  final int index;

  const ChangeTabState(this.index);

  @override
  List<Object?> get props => [index];
}

class GetMostPopularRecitersLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetMostPopularRecitersSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMostPopularRecitersErrorState extends AudiosError {
  const GetMostPopularRecitersErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class GetAllRadiosLoading extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetRadiosSuccessfulState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetRadiosErrorState extends AudiosError {
  const GetRadiosErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class GetSurahTafsirLoading extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetSurahTafsirSuccessfulState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetSurahTafsirErrorState extends AudiosError {
  const GetSurahTafsirErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class DownloadAudioLoadingState extends AudiosLoading {
  final String url;
  final double progress;

  DownloadAudioLoadingState(this.url, this.progress);

  @override
  List<Object?> get props => [url, progress];
}

class DownloadAudioSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class DownloadAudioErrorState extends AudiosError {
  const DownloadAudioErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class GetDownloadedAudiosLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetDownloadedAudiosSuccessState extends AudiosState {
  final List<Directory> localReciters;

  const GetDownloadedAudiosSuccessState(this.localReciters);

  @override
  List<Object?> get props => [];
}

class GetDownloadedAudiosErrorState extends AudiosError {
  const GetDownloadedAudiosErrorState(super.exception);

  @override
  List<Object?> get props => [];
}

class CheckDownloadedAudioSuccessState extends AudiosLoading {
  final String url;
  final DownloadStatus downloadStatus;

  CheckDownloadedAudioSuccessState(this.url, this.downloadStatus);

  @override
  List<Object?> get props => [url, downloadStatus];
}

class GetDownloadProgressState extends AudiosState {
  double progress;

  GetDownloadProgressState(this.progress);

  @override
  List<Object?> get props => [];
}

class TimerSetState extends AudiosState {
  final int minutes;

  const TimerSetState(this.minutes);

  @override
  List<Object> get props => [minutes];
}

class TimerCancelledState extends AudiosState {
  @override
  List<Object> get props => [];
}

class TimerUpdateState extends AudiosState {
  double progress;

  TimerUpdateState(this.progress) {
    print("*************************************************************");
    print(progress);
    print("*************************************************************");
  }

  @override
  List<Object> get props => [progress];
}

class DeleteDownloadedItemSuccessState extends AudiosState {
  final String path;

  const DeleteDownloadedItemSuccessState(this.path);

  @override
  List<Object?> get props => [path];
}
