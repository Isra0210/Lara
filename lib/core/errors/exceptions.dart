class ServerException implements Exception {
  ServerException(this.message, {this.code});

  final String message;
  final String? code;
}

class CacheException implements Exception {
  CacheException(this.message);
  final String message;
}

class NullUserException implements Exception {
  NullUserException([this.message = 'Usuário nulo retornado pelo provedor.']);
  final String message;
}
