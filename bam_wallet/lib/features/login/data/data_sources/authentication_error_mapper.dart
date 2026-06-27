import 'package:dio/dio.dart';

/// Maps authentication errors to localization keys
class AuthenticationErrorMapper {
  /// Maps a DioException to a localization key that AppLocalizations can use
  static String mapErrorToLocalizationKey(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'error_invalid_credentials_400';
          case 401:
            return 'error_unauthorized_401';
          case 403:
            return 'error_forbidden_403';
          case 404:
            return 'error_user_not_found_404';
          case 500:
            return 'error_server_500';
          default:
            return 'error_server_generic';
        }
      case DioExceptionType.connectionTimeout:
        return 'error_connection_timeout';
      case DioExceptionType.receiveTimeout:
        return 'error_receive_timeout';
      case DioExceptionType.sendTimeout:
        return 'error_send_timeout';
      case DioExceptionType.cancel:
        return 'error_request_cancelled';
      case DioExceptionType.unknown:
        return 'error_network_unknown';
      default:
        return 'error_unexpected';
    }
  }

  /// Gets the status code from a DioException
  static int? getStatusCode(DioException dioError) {
    return dioError.response?.statusCode;
  }
}
