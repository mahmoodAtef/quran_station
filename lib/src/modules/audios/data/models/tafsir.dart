class Tafsir {
  final int id;
  final int suraId;
  final String url;
  final String name;

  const Tafsir({
    required this.id,
    required this.suraId,
    required this.url,
    required this.name,
  });

  factory Tafsir.fromJson(Map<String, dynamic> json) {
    return Tafsir(
      id: json['id'],
      suraId: json['sura_id'],
      url: json['url'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sura_id'] = suraId;
    data['url'] = url;
    data['name'] = name;
    return data;
  }
}
