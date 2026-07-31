import 'package:bam_wallet/core/api_consts.dart';
import 'package:bam_wallet/features/login/data/exceptions/auth_exceptions.dart';
import 'package:bam_wallet/features/login/data/models/user_model.dart';
import 'package:bam_wallet/features/login/data/models/user_password_model.dart';
import 'package:bam_wallet/features/login/data/data_sources/authentication_error_mapper.dart';
import 'package:bam_wallet/features/login/data/data_sources/login_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RemoteAuthenticationDataSource implements LoginDataSource {
  final Dio dio;

  RemoteAuthenticationDataSource({Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<UserModel> loginWithEmailAndPassword(
    UserPasswordModel userPasswordModel,
  ) async {
    return signInWithUsernameAndPassword(userPasswordModel);
  }

  Future<UserModel> signInWithUsernameAndPassword(
    UserPasswordModel userPasswordModel,
  ) async {
    final data = userPasswordModel.toJson();
    try {
      debugPrint(
        'RemoteAuthenticationDataSource: Attempting login with ${userPasswordModel.username}',
      );
      final response = await dio.post(ApiConsts.loginEndpoint, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('RemoteAuthenticationDataSource: Login successful');
        return UserModel.fromJson(response.data);
      } else {
        throw AuthenticationException(
          'Failed to sign in',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('RemoteAuthenticationDataSource: DioException: ${e.message}');
      final errorKey = AuthenticationErrorMapper.mapErrorToLocalizationKey(e);
      throw AuthenticationException(
        errorKey,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      debugPrint('RemoteAuthenticationDataSource: Unexpected error: $e');
      throw AuthenticationException('error_unexpected');
    }
  }
}
