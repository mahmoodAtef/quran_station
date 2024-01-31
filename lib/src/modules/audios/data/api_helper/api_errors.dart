class ApiErrorManager {
  static String getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 200:
        return 'تم الحصول على البيانات بنجاح.';
      case 201:
        return 'تم إنشاء المورد بنجاح.';
      case 204:
        return 'لا توجد بيانات للعرض.';
      case 400:
        return 'الطلب غير صالح.';
      case 401:
        return 'لا يوجد صلاحية للوصول إلى الموارد المطلوبة.';
      case 403:
        return 'الوصول إلى الموارد المطلوبة ممنوع.';
      case 404:
        return 'الموارد المطلوبة غير موجودة.';
      case 409:
        return 'تعارض في البيانات، الرجاء التأكد من البيانات المدخلة.';
      case 500:
        return 'حدث خطأ داخلي في الخادم.';
      case 502:
        return 'لا يمكن الوصول إلى الخادم.';
      case 504:
        return 'انتهت مهلة الطلب، الرجاء المحاولة مرة أخرى.';
      case null:
        return 'حدث خطأ غير معروف.';
      default:
        return 'حدث خطأ غير معروف.';
    }
  }
}
