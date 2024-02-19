// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_station/src/core/remote/dio_helper.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_data.dart';
import 'package:quran_station/src/modules/audios/data/models/moshaf_details.dart';
import 'package:quran_station/src/modules/audios/data/models/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter_data.dart';

abstract class BaseAudiosRemoteDataSource {
  Future<Either<Exception, List<ReciterData>>> getRecitersData();
  Future<Either<Exception, List<MoshafData>>> getReciterDetails({required int reciterId});
  Future<Either<Exception, MoshafDetails>> getMoshafDetails({required int moshafId});
  Future<Either<Exception, List<int>>> getMostPopularReciters();
  Future<Either<Exception, List<RadioModel>>> getRadios();
}

class AudiosRemoteDataSource extends BaseAudiosRemoteDataSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DioHelper dio = DioHelper();
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
    } on FirebaseException catch (e) {
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
    } on FirebaseException catch (e) {
      return Left(e);
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
    } on FirebaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<int>>> getMostPopularReciters() async {
    try {
      var response = await firestore.collection("most_popular").doc("most_popular").get();
      return Right(List<int>.from(response.data()!["id's"]));
    } on FirebaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<RadioModel>>> getRadios() async {
    try {
      List<RadioModel> radios = [];
      await firestore.collection("radios").get().then((value) {
        value.docs.forEach((element) {
          RadioModel radio = RadioModel.fromJson(element.data());
          if (kDebugMode) {
            print(radio);
          }
          radios.add(radio);
        });
      });
      return Right(radios);
    } on FirebaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
