import 'package:bam_wallet/features/login/domain/entities/user.dart';

abstract class LoginRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<bool> isUserLoggedIn();
}
