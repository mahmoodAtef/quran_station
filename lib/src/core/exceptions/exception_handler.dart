import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:quran_station/src/core/exceptions/dio_exception_handler.dart';
import 'package:quran_station/src/core/exceptions/fire_base_exception_handler.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

import 'default_exception_handler.dart';

abstract class ExceptionHandler {
  static void handle(Exception exception) {
    ExceptionHandler handler = ExceptionHandlerFactory.create(exception);
    String message = handler.getErrorMessage(exception);
    errorToast(msg: message);
  }

  String getErrorMessage(Exception exception);
}

abstract class ExceptionHandlerFactory {
  static ExceptionHandler create(Exception exception) {
    switch (exception.runtimeType) {
      case FirebaseException:
        return FirebaseExceptionHandler();
      case DioException:
        return DioExceptionHandler();
      default:
        return DefaultExceptionHandler();
    }
  }
}
