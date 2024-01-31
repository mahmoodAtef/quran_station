import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MoshafDetails extends Equatable {
  final String server;
  final List<int> surahsIds;

  const MoshafDetails({
    required this.server,
    required this.surahsIds,
  });

  factory MoshafDetails.fromJson(Map<String, dynamic> json) {
    return MoshafDetails(
      server: json['server'],
      surahsIds: _getSurahsIndexesFromString(json['surah_list']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'server': server,
      'surah_list': surahsIds,
    };
  }

  static List<int> _getSurahsIndexesFromString(String surahsString) {
    List<int> surahs = [];
    List<String> surahsStringList = surahsString.split(",");
    for (var element in surahsStringList) {
      surahs.add(int.parse(element));
    }
    return surahs;
  }

  @override
  List<Object?> get props => [];
}
