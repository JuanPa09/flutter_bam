/// Exception personalizada para errores de autenticación
class AuthenticationException implements Exception {
  final String message;
  final int? statusCode;

  AuthenticationException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Exception personalizada para errores de red
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}
