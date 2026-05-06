import 'package:bam_wallet/core/consts.dart';
import 'package:bam_wallet/core/local_storage.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalAuthenticationDataSource {
  final SharedPreferences _prefs;
  static const String _userDataKey = 'user_data';

  LocalAuthenticationDataSource({SharedPreferences? sharedPreferences})
    : _prefs = sharedPreferences ?? LocalStorage().prefs;

  Future<void> saveSession(String sessionToken) async {
    await _prefs.setString(Consts.sessionTokenKey, sessionToken);
  }

  Future<String?> getSession() async {
    return _prefs.getString(Consts.sessionTokenKey);
  }

  Future<void> clearSession() async {
    await _prefs.remove(Consts.sessionTokenKey);
    await _prefs.remove(_userDataKey);
  }

  Future<void> saveUserData(UserModel userModel) async {
    final userJson = jsonEncode({
      'id': userModel.id,
      'username': userModel.username,
      'email': userModel.email,
      'firstName': userModel.firstName,
      'lastName': userModel.lastName,
      'gender': userModel.gender,
      'image': userModel.image,
      'accessToken': userModel.accessToken,
    });
    await _prefs.setString(_userDataKey, userJson);
  }

  Future<UserModel?> getUserData() async {
    final userJson = _prefs.getString(_userDataKey);
    if (userJson != null) {
      try {
        final jsonData = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(jsonData);
      } catch (e) {
        print('Error deserializing user data: $e');
        return null;
      }
    }
    return null;
  }
}
