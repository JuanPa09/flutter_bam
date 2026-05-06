import 'package:bam_wallet/core/api_consts.dart';
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
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      print('Error in authentication request: $e');
      rethrow;
    }
  }
}
