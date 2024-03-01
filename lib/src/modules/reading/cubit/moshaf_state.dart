part of 'moshaf_cubit.dart';

@immutable
abstract class MoshafState {}

class MoshafInitial extends MoshafState {}

class GetQuranState extends MoshafState {}

class GetPageDataState extends MoshafState {}

class LoadingTafsirJsonState extends MoshafState {}

class TafsirJsonLoadedState extends MoshafState {}

class LoadPageTafsirState extends MoshafState {}

class GetPageTafsirState extends MoshafState {}
