import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/components.dart';

class ExceptionManager {
  Exception exception;

  ExceptionManager(this.exception);

  String get message {
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
    } else if (exception is FirebaseException) {
      return _handleFirebaseException(exception as FirebaseException);
    } else {
      return 'خطأ غير معروف';
    }
  }

  void showMessages() {
    errorToast(msg: message);
  }

  String _handleFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case "network-error":
        return "خطأ في الشبكة";
      case "network-request-failed":
        return "خطأ في الشبكة";
      case "email-already-in-use":
        return "البريد الإلكتروني المدخل مستخدم بالفعل";
      case "invalid-email":
        return "البريد الإلكتروني المدخل غير صالح";
      case "user-not-found":
        return "المستخدم غير موجود";
      case "wrong-password":
        return "كلمة المرور غير صحيحة";
      case "user-disabled":
        return "تم تعطيل الحساب";
      case "user-token-expired":
        return "انتهت صلاحية رمز المصادقة";
      case "permission-denied":
        return "ليس لديك صلاحية الوصول إلى هذه البيانات";
      case "invalid-token":
        return "رمز المصادقة غير صالح";
      case "cancelled":
        return "تم إلغاء العملية";
      case "already-exists":
        return "المستند موجود بالفعل";
      case "data-loss":
        return "حدث فقدان البيانات ";
      case "invalid-argument":
        return "بيانات غير صالحة";
      case "internal":
        return "حدث خطأ داخلي في الخادم";
      case "invalid-registration-token":
        return "رمز التسجيل الخاص بالجهاز غير صالح";
      case "registration-token-not-registered":
        return "لم يتم تسجيل الجهاز لتلقي الإشعارات";
      case "fetch-client-network":
        return "خطأ في الاتصال بالخادم ";
      case "fetch-throttle":
        return "تم إيقاف جلب البيانات لفترة من الوقت بسبب الكثير من الاستعلامات";
      case "quota-exceeded":
        return "تم تجاوز سقف التخزين";
      case "unauthorized":
        return "ليس لديك صلاحية الوصول إلى هذا الملف";
      case "object-not-found":
        return "لم يتم العثور على الملف";
      case "retry-limit-exceeded":
        return "تم تجاوز الحد الأقصى لإعادة المحاولة";
      case "unknown":
        return "حدث خطأ غير معروف";
      default:
        return "  حدث خطأ غير معروف : ${exception.code}";
    }
  }
}
