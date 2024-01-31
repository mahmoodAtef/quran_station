import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_station/src/core/remote/dio_helper.dart';
import 'package:quran_station/src/modules/audios/data/api_helper/api_constance.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_data.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_details.dart';

abstract class BaseAudiosRemoteDataSource {
  // Future<Either<Exception, List<Reciter>>> getAllReciters();
  // Future<Either<Exception, List<Reciter>>> advancedSearch({int? surahId, int? rewayaId});
  Future<Either<Exception, List<ReciterData>>> getRecitersData();
  Future<Either<Exception, List<MoshafData>>> getReciterDetails({required int reciterId});
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
          if (kDebugMode) {
            print(data.name);
          }
          recitersData.add(data);
        });
      });
      debugPrint(recitersData.length.toString());
      return Right(recitersData);
    } on DioError catch (e) {
      return Left(e);
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
    } on DioError catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  String getReciterid(String docId) {
    String reciterRemoved = docId.replaceAll("reciter_", "");
    String moshafRemoved = reciterRemoved.split("-")[0];
    return moshafRemoved;
  }

  Future editMoshafs() async {
    await firestore.collection("moshafs_data").get().then((value) {
      value.docs.forEach((element) async {
        String reciterId = getReciterid(element.id);
        await firestore
            .collection("moshafs_data")
            .doc(element.id)
            .update({"reciter_id": int.parse(reciterId)});
      });
    });
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
