import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bam_wallet/features/login/data/models/user_model.dart';

class LoginRemoteDataSource {
  final http.Client httpClient;

  LoginRemoteDataSource({required this.httpClient});

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('https://api.example.com/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return UserModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
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
