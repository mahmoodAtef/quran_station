import 'package:equatable/equatable.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_data.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_details.dart';

import 'moshaf.dart';

// ignore: must_be_immutable
class Reciter extends Equatable {
  final ReciterData data;
  List<Moshaf>? moshafs;
  Reciter(this.data, {this.moshafs});

  @override
  List<Object?> get props => [
        data.id,
      ];
}
