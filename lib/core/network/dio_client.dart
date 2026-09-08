import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient(TokenStorage tokenStorage)
      : dio = Dio(BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(AuthInterceptor(tokenStorage));
  }

  final Dio dio;
}
