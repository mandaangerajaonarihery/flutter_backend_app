import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveToken(String token) => _storage.write(key: 'access_token', value: token);

  @override
  Future<String?> getToken() => _storage.read(key: 'access_token');

  @override
  Future<void> clearToken() => _storage.delete(key: 'access_token');
}
