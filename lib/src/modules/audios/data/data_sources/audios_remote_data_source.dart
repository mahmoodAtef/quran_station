// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_data.dart';

abstract class BaseAudiosRemoteDataSource {
  // Future<Either<Exception, List<Reciter>>> getAllReciters();
  // Future<Either<Exception, List<Reciter>>> advancedSearch({int? surahId, int? rewayaId});
  Future<Either<Exception, List<ReciterData>>> getRecitersData();
  Future<Either<Exception, List<MoshafData>>> getReciterDetails({required int reciterId});
  Future<Either<Exception, MoshafDetails>> getMoshafDetails({required int moshafId});
  Future<Either<Exception, List<int>>> getMostPopularReciters();
}

class AudiosRemoteDataSource extends BaseAudiosRemoteDataSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Exception, List<ReciterData>>> getRecitersData() async {
    List<ReciterData> recitersData = [];
    try {
      await firestore.collection("reciters").get().then((value) {
        value.docs.forEach((element) async {
          ReciterData data = ReciterData.fromJson(element.data());
          recitersData.add(data);
        });
      });
      debugPrint(recitersData.length.toString());
      return Right(recitersData);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<MoshafData>>> getReciterDetails({required int reciterId}) async {
    try {
      List<MoshafData> moshafsData = [];
      await firestore
          .collection("moshafs_data")
          .where("reciter_id", isEqualTo: reciterId)
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          MoshafData data = MoshafData.fromJson(element.data());
          moshafsData.add(data);
        });
      });
      return Right(moshafsData);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, MoshafDetails>> getMoshafDetails({required int moshafId}) async {
    try {
      var response = await firestore.collection("moshafs_details").doc("$moshafId").get();
      MoshafDetails moshafDetails = MoshafDetails.fromJson(response.data()!);
      return Right(moshafDetails);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<int>>> getMostPopularReciters() async {
    try {
      var response = await firestore.collection("most_popular").doc("most_popular").get();
      return Right(List<int>.from(response.data()!["id's"]));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

/*

  Future saveRecitersDetails() async {
    DioHelper dioHelper = DioHelper()..init(baseUrl: AudiosApiConsts.baseUrl);
    await dioHelper.getData(url: AudiosApiConsts.getRecitersEndPoints).then((value) async {
      print(value.data["reciters"].length);
      for (var element in value.data["reciters"]) {
        int id = element["id"];
        for (var element in element["moshaf"]) {
          Moshaf moshaf = Moshaf.fromJson(element);
          Moshaf2 moshaf2 = Moshaf2.fromMoshaf(moshaf);
          await firestore
              .collection("moshafs_details")
              .doc("${moshaf2.moshafData.id}")
              .set(moshaf2.moshafDetails.toJson());
        }
      }
    });
  }
  @override
  Future<Either<Exception, List<Reciter>>> getRecitersData() async {
    await firestore.collection("reciters").get().then((value) {
      value.docs.forEach((element) async {
        await firestore.doc(element.id).get().then((value) {
          ReciterData data = ReciterData.fromJson(json, surahsCount, rewayasCount);
        });
      });
    });
  }
 */

//   DioHelper dioHelper = DioHelper()..init(baseUrl: AudiosApiConsts.baseUrl);
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   @override
//   Future<Either<Exception, List<Reciter>>> advancedSearch({int? surahId, int? rewayaId}) async {
//     try {
//       List<Reciter> reciters = [];
//       var response = await dioHelper.getData(url: AudiosApiConsts.getRecitersEndPoints, query: {
//         'surah_id': surahId,
//         'rewaya_id': rewayaId,
//         "language": "ar",
//       });
//       reciters = await parseReciters(response.data);
//       return Right(reciters);
//     } on DioException catch (exception) {
//       return Left(exception.error as Exception);
//     }
//   }
//
//   @override
//   Future<Either<Exception, List<Reciter>>> getAllReciters() async {
//     try {
//       List<Reciter> reciters = [];
//       var response = await dioHelper.getData(url: AudiosApiConsts.getRecitersEndPoints);
//       reciters = await parseReciters(response.data["reciters"]);
//       return Right(reciters);
//     } on DioException catch (exception) {
//       return Left(exception.error as Exception);
//     }
//   }
//
//   Future<List<Reciter>> parseReciters(List<dynamic> data) async {
//     List<Reciter> reciters = [];
//     for (var element in data) {
//       Reciter reciter = Reciter();
//       ReciterData reciterData =
//           ReciterData.fromJson(element, reciter.getSurahsCount(), reciter.moshaf.length);
//       List<Moshaf2> moshafs = List.from(element['moshaf']).map((e) => Moshaf2.fromJson(e)).toList();
//       List<Map<String, dynamic>> reciterDetails = [];
//       for (var element in moshafs) {
//         reciterDetails.add(element.toJson());
//       }
//       await firestore
//           .collection("reciters")
//           .doc(reciter.id.toString())
//           .set({"reciter_data": reciterData.toJson(), "reciter_details": reciterDetails});
//
//       reciters.add(reciter);
//     }
//     return reciters;
//   }
//
//   Future saveReciter(
//     dynamic data,
//   ) async {
//     for (var element in data) {
//       Reciter reciter = Reciter.fromJson(element);
//       ReciterData reciterData =
//           ReciterData.fromJson(element, reciter.getSurahsCount(), reciter.moshaf.length);
//       List<Moshaf2> moshafs = List.from(element['moshaf']).map((e) => Moshaf2.fromJson(e)).toList();
//       List<Map<String, dynamic>> reciterDetails = [];
//       for (var element in moshafs) {
//         reciterDetails.add(element.toJson());
//       }
//       await firestore
//           .collection("reciters")
//           .doc(reciter.id.toString())
//           .set({"reciter_data": reciterData.toJson(), "reciter_details": reciterDetails});
//
//       // reciters.add(reciter);
//     }
// //    await saveReciterData(data);
//   }
