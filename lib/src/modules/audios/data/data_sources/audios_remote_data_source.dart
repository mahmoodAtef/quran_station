import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_station/src/modules/audios/data/data_sources/audios_base_data_source.dart';
import 'package:quran_station/src/modules/audios/data/models/radio/radio.dart';
import 'package:quran_station/src/modules/audios/data/models/reciter/reciter_data.dart';
import 'package:quran_station/src/modules/audios/data/models/tafsir/tafsir.dart';

import '../models/moshaf/moshaf_data.dart';
import '../models/moshaf/moshaf_details.dart';

class AudiosRemoteDataSource extends BaseAudiosRemoteDataSource {
  static double downloadProgress = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Exception, List<ReciterData>>> getRecitersData() async {
    try {
      List<ReciterData> recitersData = [];
      await _firestore.collection("reciters").get().then((value) {
        value.docs.forEach((element) async {
          ReciterData data = ReciterData.fromJson(element.data());
          recitersData.add(data);
        });
      });
      return Right(recitersData);
    } on FirebaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<MoshafData>>> getReciterDetails(
      {required int reciterId}) async {
    try {
      List<MoshafData> moshafsData = [];
      await _firestore
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
  Future<Either<Exception, MoshafDetails>> getMoshafDetails(
      {required int moshafId}) async {
    try {
      var response =
          await _firestore.collection("moshafs_details").doc("$moshafId").get();
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
      var response =
          await _firestore.collection("most_popular").doc("most_popular").get();
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
      await _firestore.collection("radios").get().then((value) {
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

  @override
  Future<Either<Exception, List<Tafsir>>> getSurahTafsir(int surahId) async {
    try {
      List<Tafsir> tafsir = [];
      await _firestore
          .collection("tafsir")
          .where("sura_id", isEqualTo: surahId)
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          tafsir.add(Tafsir.fromJson(doc.data()));
        });
      });
      return Right(tafsir);
    } on FirebaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> downloadSurah(
      String url, String readerName, String surahName,
      {required Function(double) onProgress}) async {
    try {
      await _requestPermission();
      String downloadsPath = await _getDownloadsPath(readerName);
      String filePath = "$downloadsPath/$surahName";
      Dio dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            onProgress((received / total));
          }
        },
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  Future _requestPermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print("Permission not granted");
      return Left(Exception("Permission not granted"));
    }
  }

  Future<String> _getDownloadsPath(String readerName) async {
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    String downloadsPath = "${downloadsDirectory!.path}/القراء/$readerName";

    Directory readerDirectory = Directory(downloadsPath);
    if (!readerDirectory.existsSync()) {
      readerDirectory.createSync(recursive: true);
    }
    return downloadsPath;
  }
}
