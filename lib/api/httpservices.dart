import 'package:commute_nepal/utils/url.dart';
import 'package:dio/dio.dart';

class HttpServices {
  static final HttpServices _instance = HttpServices.internal();
  factory HttpServices() => _instance;
  HttpServices.internal();
  Dio? _dio;
  Dio getDioInstance() {
    if (_dio == null) {
      return Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
      ));
    } else {
      return _dio!;
    }
  }
}
