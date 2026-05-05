import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:bam_wallet/features/login/data/models/user_model.dart';
import 'package:bam_wallet/core/api_consts.dart';

class LoginRemoteDataSource {
  final Dio dioClient;

  LoginRemoteDataSource({required this.dioClient});

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient
          .post(
            ApiConsts.apiUrlLogin,
            options: Options(headers: {'Content-Type': 'application/json'}),
            data: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return UserModel.fromJson(
          jsonDecode(response.data) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 401) {
        throw Exception('401');
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
