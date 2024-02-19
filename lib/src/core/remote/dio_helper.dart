import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  DioHelper();
  init({required String baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          "Accept-Language": "ar",
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // to get data from url
  Future<Response> getData({required String url, Map<String, dynamic>? query}) async {
    return await dio.request(url,
        queryParameters: query ??
            {
              "language": "ar",
            });
  }

  Future<Response> postData(
      {required String url,
      required Map<String, dynamic>? data,
      Map<String, dynamic>? query}) async {
    return await dio.post(url, data: data, queryParameters: query);
  }
}
