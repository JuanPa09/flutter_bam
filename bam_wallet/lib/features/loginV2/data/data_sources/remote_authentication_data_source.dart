import 'package:bam_wallet/core/api_consts.dart';
import 'package:bam_wallet/features/loginV2/data/exceptions/auth_exceptions.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_password_model.dart';
import 'package:dio/dio.dart';

class RemoteAuthenticationDataSource {
  final Dio dio;

  RemoteAuthenticationDataSource({Dio? dio}) : dio = dio ?? Dio();

  Future<UserModel> signIUpWithUsernameAndPassword(
    UserPasswordModel userPasswordModel,
  ) async {
    final data = userPasswordModel.toJson();
    try {
      final response = await dio.post(ApiConsts.loginEndpoint, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw AuthenticationException(
          'Failed to sign in',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final errorMessage = _getErrorMessage(e);
      throw AuthenticationException(
        errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      print('Error in authentication request: $e');
      throw AuthenticationException('An unexpected error occurred: $e');
    }
  }

  /// Extrae un mensaje de error legible del DioException
  String _getErrorMessage(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'Invalid credentials. Please check your username and password.';
          case 401:
            return 'Unauthorized. The credentials you provided are invalid.';
          case 403:
            return 'Access forbidden. Your account may be suspended.';
          case 404:
            return 'User not found.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Server error (${statusCode ?? 'unknown'}). Please try again later.';
        }
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.receiveTimeout:
        return 'Request timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please check your internet connection.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        return 'Network error: ${dioError.message ?? 'Unknown error'}';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
