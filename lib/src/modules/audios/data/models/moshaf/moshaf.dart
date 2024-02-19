import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf/moshaf_details.dart';

class Moshaf {
  final MoshafData moshafData;
  MoshafDetails? moshafDetails;

  Moshaf(
    this.moshafData, {
    this.moshafDetails,
  });
}
