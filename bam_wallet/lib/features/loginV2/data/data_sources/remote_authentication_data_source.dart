import 'package:bam_wallet/core/api_consts.dart';
import 'package:bam_wallet/features/loginV2/data/exceptions/auth_exceptions.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_password_model.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/authentication_error_mapper.dart';
import 'package:dio/dio.dart';

class RemoteAuthenticationDataSource {
  final Dio dio;

  RemoteAuthenticationDataSource({Dio? dio}) : dio = dio ?? Dio();

  Future<UserModel> signInWithUsernameAndPassword(
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
      final errorKey = AuthenticationErrorMapper.mapErrorToLocalizationKey(e);
      throw AuthenticationException(
        errorKey,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      print('Error in authentication request: $e');
      throw AuthenticationException('error_unexpected');
    }
  }
}
