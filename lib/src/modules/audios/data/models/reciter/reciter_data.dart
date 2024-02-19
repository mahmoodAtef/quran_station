import 'dart:core';

import 'package:equatable/equatable.dart';

class ReciterData extends Equatable {
  final int id;
  final String name;
  final String letter;
  final int surahsCount;
  final int rewayasCount;
  const ReciterData({
    required this.id,
    required this.name,
    required this.letter,
    required this.surahsCount,
    required this.rewayasCount,
  });

  factory ReciterData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReciterData(
      id: json['id'],
      name: json['name'],
      letter: json['letter'],
      surahsCount: json['surahs_count'],
      rewayasCount: json['rewayas_count'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'letter': letter,
      'surahs_count': surahsCount,
      'rewayas_count': rewayasCount,
    };
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
