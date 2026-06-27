import 'package:bam_wallet/features/login/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<void> saveSession(String sessionToken);
  Future<User> signInWithUsernameAndPassword({
    required String username,
    required String password,
  });
  Future<bool> logOut();
  Future<String> getSessionToken();
  Future<bool> isLoggedIn();
  Future<User?> getUserData();
}
