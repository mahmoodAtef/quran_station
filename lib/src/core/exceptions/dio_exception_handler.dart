import 'package:dio/dio.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';

class DioExceptionHandler extends ExceptionHandler {
  @override
  String getErrorMessage(Exception exception) {
    DioException dioException = exception as DioException;
    switch (dioException.response?.statusCode ?? 0) {
      case 100:
        return "استمرار";
      case 101:
        return "تغيير البروتوكولات";
      case 102:
        return "معالجة الطلب (WebDAV)";
      case 103:
        return "معلومات مبكرة";
      case 200:
        return "نجاح";
      case 201:
        return "تم الإنشاء بنجاح";
      case 202:
        return "تم قبول الطلب";
      case 203:
        return "معلومات غير موثوقة";
      case 204:
        return "لا يوجد محتوى";
      case 205:
        return "إعادة تعيين المحتوى";
      case 206:
        return "محتوى جزئي";
      case 207:
        return "عدة حالات (WebDAV)";
      case 208:
        return "تم الإبلاغ بالفعل (WebDAV)";
      case 226:
        return "تم استخدام IM (ترميز Delta HTTP)";
      case 300:
        return "اختيارات متعددة";
      case 301:
        return "تم إعادة توجيه الطلب بشكل دائم";
      case 302:
        return "تم العثور عليه";
      case 303:
        return "انظر لمكان آخر";
      case 304:
        return "لم يتم تعديل الطلب";
      case 305:
        return "استخدم الوكيل (مهجور)";
      case 307:
        return "إعادة توجيه مؤقتة";
      case 308:
        return "إعادة توجيه دائمة";
      case 400:
        return "طلب غير صالح";
      case 401:
        return "غير مصرح به";
      case 402:
        return "الدفع مطلوب (تجريبي)";
      case 403:
        return "الوصول غير مسموح";
      case 404:
        return "الموارد غير موجودة";
      case 405:
        return "الطريقة غير مسموح بها";
      case 406:
        return "المحتوى غير مقبول";
      case 407:
        return "مطلوب مصادقة الوكيل";
      case 408:
        return "انتهت مهلة الطلب";
      case 409:
        return "تعارض في البيانات";
      case 410:
        return "الموارد غير متوفرة";
      case 411:
        return "الطول المطلوب مفقود";
      case 412:
        return "فشلت الشروط الأولية للطلب";
      case 413:
        return "البيانات كبيرة جدًا";
      case 414:
        return "طول الرابط طويل جدًا";
      case 415:
        return "نوع الوسائط غير مدعوم";
      case 416:
        return "النطاق غير مقبول";
      case 417:
        return "فشل في التوقعات";
      case 418:
        return "أنا إبريق";
      case 421:
        return "طلب مخطئ";
      case 422:
        return "المحتوى غير قابل للمعالجة";
      case 423:
        return "المورد مغلق";
      case 424:
        return "فشل الاعتماديات";
      case 425:
        return "الطلب مبكر جدًا";
      case 426:
        return "الترقية مطلوبة";
      case 428:
        return "شرط مسبق مطلوب";
      case 429:
        return "الكثير من الطلبات";
      case 431:
        return "حقول رأس الطلب كبيرة جدًا";
      case 451:
        return "غير متوفر لأسباب قانونية";
      case 500:
        return "خطأ في الخادم الداخلي";
      case 501:
        return "غير متبنى";
      case 502:
        return "خطأ في البوابة";
      case 503:
        return "الخدمة غير متوفرة";
      case 504:
        return "بوابة مهلة زائدة";
      case 505:
        return "إصدار HTTP غير مدعوم";
      case 506:
        return "المتغير يتفاوض أيضًا";
      case 507:
        return "تخزين غير كافي";
      case 508:
        return "الكشف عن حلقة";
      case 510:
        return "لم يتم التمديد";
      case 511:
        return "المصادقة على الشبكة مطلوبة";
      default:
        return "خطأ غير معروف";
    }
  }
}
