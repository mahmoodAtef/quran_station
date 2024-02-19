import 'package:equatable/equatable.dart';

class RadioModel extends Equatable {
  final String name;
  final String url;
  final int id;
  const RadioModel({required this.name, required this.id, required this.url});

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(name: json["name"], id: json['id'], url: json['url']);
  }
  Map<String, dynamic> toJson() {
    return {"name": name, "id": id, "url": url};
  }

  @override
  List<Object?> get props => [id, url];
}

List<RadioModel> radios = [
  const RadioModel(
      name: "إذاعة القران الكريم من القاهرة",
      id: 1,
      url: "https://stream.radiojar.com/8s5u5tpdtwzuv"),
  const RadioModel(name: "إذاعة الحرم", id: 2, url: "https://stream.radiojar.com/4wqre23fytzuv"),
  const RadioModel(
      name: " إذاعة مختصر التفسير ",
      id: 3,
      url: "https://backup.qurango.net/radio/mukhtasartafsir"),
  const RadioModel(
      name: "إذاعة تفسير الطبري", id: 4, url: "https://backup.qurango.net/radio/tabri"),
  const RadioModel(
      name: " إذاعة عبدالباسط عبدالصمد",
      id: 5,
      url: "https://backup.qurango.net/radio/abdulbasit_abdulsamad"),
  const RadioModel(
      name: " إذاعة محمود خليل الحصري",
      id: 6,
      url: "https://backup.qurango.net/radio/mahmoud_khalil_alhussary"),
  const RadioModel(
      name: " إذاعة محمود علي البنا",
      id: 7,
      url: "https://backup.qurango.net/radio/mahmoud_ali__albanna"),
  const RadioModel(
      name: "إذاعة الشيخ عبد الباسط برواية ورش",
      id: 8,
      url: "https://backup.qurango.net/radio/abdulbasit_abdulsamad_warsh"),
  const RadioModel(
      name: "إذاعة الشيخ محمد أيوب", id: 9, url: "https://backup.qurango.net/radio/mohammed_ayyub"),
  const RadioModel(
      name: "إذاعة الشيخ المنشاوي",
      id: 10,
      url: "https://backup.qurango.net/radio/mohammed_siddiq_alminshawi"),
  const RadioModel(
      name: "إذاعة الشيخ الحصري برواية ورش",
      id: 11,
      url: "https://backup.qurango.net/radio/mahmoud_khalil_alhussary_warsh")
];
