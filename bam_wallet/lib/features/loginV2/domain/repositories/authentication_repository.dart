import 'package:bam_wallet/features/loginV2/domain/entities/user.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';

abstract class AuthenticationRepository {
  Future<void> saveSession(String sessionToken);
  Future<User> signIUpWithUsernameAndPassword({
    required String username,
    required String password,
  });
  Future<bool> logOut();
  Future<String> getSessionToken();
  Future<bool> isLoggedIn();
  Future<UserModel?> getUserData();
}
