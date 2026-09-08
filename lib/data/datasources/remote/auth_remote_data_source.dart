import 'package:dio/dio.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _client.dio.post('/auth/login', data: {'username': username, 'password': password, 'expiresInMins': 30});
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) throw const AuthenticationException();
      throw const NetworkException();
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _client.dio.get('/auth/me');
      return UserModel.fromJson(Map<String, dynamic>.from(response.data as Map));
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) throw const UnauthorizedException();
      throw const NetworkException();
    }
  }

  Future<UserModel> register(String email, String password) async {
    try {
      final response = await _client.dio.post('/users/add', data: {'username': email.split('@').first, 'email': email, 'password': password, 'firstName': 'New', 'lastName': 'User'});
      return UserModel.fromJson(Map<String, dynamic>.from(response.data as Map));
    } on DioException catch (_) {
      throw const NetworkException('Inscription impossible.');
    }
  }
}
