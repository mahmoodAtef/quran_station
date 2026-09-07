import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: AppColors.error,
    textColor: AppColors.onError,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: AppColors.primaryColor,
    textColor: AppColors.onPrimary,
    toastLength: Toast.LENGTH_SHORT,
  );
}