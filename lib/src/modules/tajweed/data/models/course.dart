import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final String playlistUrl;

  const Course({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.playlistUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        playlistUrl: json['playlistUrl'],
      );

  @override
  List<Object?> get props => [id];
}
