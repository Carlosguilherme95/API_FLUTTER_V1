import 'package:dio/dio.dart';

abstract final class DioClient {
  static Dio? _instance;

  static Dio get instance {
    return _instance ??= _build();
  }

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.exemplo.com',
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000,
        headers: <String, dynamic>{
          Headers.acceptHeader: 'application/json',
          Headers.contentTypeHeader: 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ),
    );

    return dio;
  }

  static void injectForTest(Dio dio) {
    _instance = dio;
  }

  static void resetForTest() {
    _instance = null;
  }
}
