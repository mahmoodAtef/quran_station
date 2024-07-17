import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AudiosLocalDataSource {
  late Directory? appDirectory;

  Future<Either<Exception, List<Directory>>> getLocalReciters() async {
    try {
      appDirectory = (await getExternalStorageDirectory());
      List<Directory> reciters = [];
      final fullPath = Directory('${appDirectory!.path}/القراء/');
      if (await fullPath.exists()) {
        var result = await fullPath.list().toList();
        result = _removeEmpty(result);
        reciters = result.map((e) => e as Directory).toList();
        if (kDebugMode) {
          print(reciters);
        }
        return Right(reciters);
      } else {
        return Right(reciters);
      }
    } on Exception catch (e) {
      return Left(e);
    }
  }

  void deleteDownloadedItem(String path, isFile) {
    if (isFile) {
      File(path).deleteSync();
      return;
    }
    Directory(path).deleteSync(recursive: true);
  }

  List<FileSystemEntity> _removeEmpty(List<FileSystemEntity> list) {
    for (int i = 0; i < list.length; i++) {
      if (Directory(list[i].path).listSync().isEmpty) {
        list[i].deleteSync(recursive: true);
        list.removeAt(i);
      }
    }
    return list;
  }
}
