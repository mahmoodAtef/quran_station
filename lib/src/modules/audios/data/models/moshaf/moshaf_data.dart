import 'package:equatable/equatable.dart';

class MoshafData extends Equatable {
  final int id;
  final String name;
  final int surahTotal;

  const MoshafData({
    required this.id,
    required this.name,
    required this.surahTotal,
  });

  factory MoshafData.fromJson(Map<String, dynamic> json) {
    return MoshafData(
      id: json['id'],
      name: json['name'],
      surahTotal: json['surah_total'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surah_total': surahTotal,
    };
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
