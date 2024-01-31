import 'package:quran_station/src/modules/audios/data/models/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_details.dart';

class Moshaf {
  final MoshafData moshafData;
  final MoshafDetails? moshafDetails;

  const Moshaf(
    this.moshafData, {
    this.moshafDetails,
  });
  // Map<String, dynamic> toJson() {
  //   return {
  //     'moshaf_data': moshafData.toJson(),
  //     'moshaf_details': moshafDetails.toJson(),
  //   };
  // }

  // factory Moshaf.fromJson(Map<String, dynamic> json) {
  //   return Moshaf(
  //     MoshafData.fromJson(json),
  //   );
  // }
  // static List<int> _getSurahsIndexesFromString(String surahsString) {
  //   List<int> surahs = [];
  //   List<String> surahsStringList = surahsString.split(",");
  //   for (var element in surahsStringList) {
  //     surahs.add(int.parse(element));
  //   }
  //   return surahs;
  // }
}
