import 'package:firebase_core/firebase_core.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';

class FirebaseExceptionHandler extends ExceptionHandler {
  @override
  String getErrorMessage(Exception exception) {
    FirebaseException firebaseException = exception as FirebaseException;
    switch (firebaseException.code) {
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
        return "  حدث خطأ غير معروف : ${firebaseException.code}";
    }
  }
}
