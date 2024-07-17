import 'dart:async';
import 'dart:io';

import 'package:quran_station/src/core/exceptions/exception_handler.dart';

class DefaultExceptionHandler extends ExceptionHandler {
  @override
  String getErrorMessage(Exception exception) {
    if (exception is FormatException) {
      return 'تنسيق غير صالح';
    } else if (exception is TimeoutException) {
      return 'تجاوز الوقت المسموح للطلب';
    } else if (exception is SocketException) {
      return 'لا يوجد اتصال بالإنترنت';
    } else if (exception is HttpException) {
      return 'خطأ في اتصال بالخادم';
    } else if (exception is HandshakeException) {
      return 'خطأ في اتصال بالخادم';
    } else if (exception is FormatException) {
      return 'تنسيق غير صالح';
    } else if (exception is CertificateException) {
      return "خطأ في الشهادة";
    } else if (exception is FileSystemException) {
      return "خطأ في نظام الملفات";
    } else if (exception is IOException) {
      return "خطأ في الإدخال/الإخراج";
    } else if (exception is PathAccessException) {
      return "خطأ في الوصول إلى المسار";
    } else if (exception is PathNotFoundException) {
      return "مسار غير موجود";
    } else if (exception is ProcessException) {
      return "خطأ في العملية";
    } else if (exception is SignalException) {
      return "خطأ في الإشارة";
    } else if (exception is TlsException) {
      return "خطأ في الشهادة TLS";
    } else {
      return 'خطأ غير معروف';
    }
  }
}
