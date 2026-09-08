import '../../core/errors/app_exceptions.dart';
import '../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  User? _currentUser;

  @override
  @override
  Future<bool> get hasSession async => await _tokenStorage.getToken() != null;

  @override
  Future<User> login(String username, String password) async {
    final response = await _remote.login(username, password);
    final token = response['accessToken'] ?? response['token'];
    if (token is! String || token.isEmpty) throw const AuthenticationException('Le serveur n’a pas fourni de token.');
    await _tokenStorage.saveToken(token);
    final user = await _remote.getCurrentUser();
    _currentUser = user;
    return user;
  }

  @override
  Future<User> register(String email, String password) async {
    final user = await _remote.register(email, password);
    return user;
  }

  @override
  Future<User?> restoreSession() async {
    final token = await _tokenStorage.getToken();
    if (token == null) return null;
    try {
      _currentUser = await _remote.getCurrentUser();
      return _currentUser;
    } on AppException {
      await logout();
      return null;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    _currentUser ??= await _remote.getCurrentUser();
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await _tokenStorage.clearToken();
  }
}
