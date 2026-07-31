import '../models/user_model.dart';
import '../models/user_password_model.dart';

abstract class LoginDataSource {
  LoginDataSource();

  Future<UserModel> loginWithEmailAndPassword(
    UserPasswordModel userPasswordModel,
  );
}
