// ignore_for_file: must_be_immutable

part of 'audios_bloc.dart';

abstract class AudiosState extends Equatable {
  const AudiosState();
}

class AudiosInitial extends AudiosState {
  @override
  List<Object> get props => [];
}

class GetAllRecitersLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetAllRecitersSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetAllRecitersErrorState extends AudiosState {
  Exception exception;
  GetAllRecitersErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class AdvancedSearchLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class AdvancedSearchSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class AdvancedSearchErrorState extends AudiosState {
  final Exception exception;
  const AdvancedSearchErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class GetMushafSurahsLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMushafSurahsSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMushafSurahsErrorState extends AudiosState {
  Exception exception;
  GetMushafSurahsErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class GetSearchByNameLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetSearchByNameResult extends AudiosState {
  final List<Reciter> result;
  const GetSearchByNameResult(this.result);
  @override
  List<Object?> get props => [result];
}

class GetReciterLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetReciterSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetReciterErrorState extends AudiosState {
  final Exception exception;
  const GetReciterErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class GetMoshafDetailsLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMoshafDetailsSuccessState extends AudiosState {
  final MoshafDetails moshafDetails;
  const GetMoshafDetailsSuccessState(this.moshafDetails);
  @override
  List<Object?> get props => [];
}

class GetMoshafDetailsErrorState extends AudiosState {
  final Exception exception;
  const GetMoshafDetailsErrorState(this.exception);
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

class GetFavoriteRecitersLoadingState extends AudiosState {
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

class GetMostPopularRecitersLoadingState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMostPopularRecitersSuccessState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetMostPopularRecitersErrorState extends AudiosState {
  final Exception exception;
  const GetMostPopularRecitersErrorState(this.exception);
  @override
  List<Object?> get props => [];
}

class GetAllRadiosLoading extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetRadiosSuccessfulState extends AudiosState {
  @override
  List<Object?> get props => [];
}

class GetRadiosErrorState extends AudiosState {
  final Exception exception;
  const GetRadiosErrorState(this.exception);
  @override
  List<Object?> get props => [];
}
