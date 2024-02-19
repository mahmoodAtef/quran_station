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
  void handle(BuildContext context) {
    ExceptionManager(exception).showMessages();
  }

  @override
  List<Object?> get props => [];
}

class GetAllRecitersLoadingState extends AudiosLoading {
  @override
  List<Object?> get props => [];
}

class GetAllRecitersSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
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
