import 'package:bam_wallet/core/api_consts.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_password_model.dart';
import 'package:dio/dio.dart';

class RemoteAuthenticationDataSource {

  final dio = Dio();

  Future<UserModel> signIUpWithUsernameAndPassword(
    UserPasswordModel userPasswordModel
  ) async {
    final data = userPasswordModel.toJson();
    print("Endpoint: ${ApiConsts.usersEndpoint}");
    print('Sending data to API: $data');
    final response = await dio.post(
      ApiConsts.loginEndpoint,
      data: data,
    );
    print("Response status code: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Response data: ${response.data}');
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to sign up');
    }

  }



}