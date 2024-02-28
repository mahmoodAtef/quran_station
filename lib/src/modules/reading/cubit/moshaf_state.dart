part of 'moshaf_cubit.dart';

@immutable
abstract class MoshafState {}

class MoshafInitial extends MoshafState {}

class GetQuranState extends MoshafState {}

class GetPageDataState extends MoshafState {}
