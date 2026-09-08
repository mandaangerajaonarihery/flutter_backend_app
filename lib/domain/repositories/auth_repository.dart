import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> register(String email, String password);
  Future<User?> restoreSession();
  Future<User> getCurrentUser();
  Future<void> logout();
  Future<bool> get hasSession;
}
