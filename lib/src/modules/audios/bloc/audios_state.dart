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
  String errorMessage;
  GetMushafSurahsErrorState(this.errorMessage);
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
