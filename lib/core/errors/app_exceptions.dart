sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Impossible de contacter le serveur.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Le serveur a rencontré une erreur.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expirée. Veuillez vous reconnecter.']);
}

class AuthenticationException extends AppException {
  const AuthenticationException([super.message = 'Identifiants incorrects.']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Les données locales sont indisponibles.']);
}
