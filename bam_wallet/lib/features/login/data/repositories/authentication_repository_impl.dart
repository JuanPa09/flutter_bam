import 'package:bam_wallet/features/login/data/data_sources/local_authentication_data_source.dart';
import 'package:bam_wallet/features/login/data/data_sources/login_data_source.dart';
import 'package:bam_wallet/features/login/data/models/user_password_model.dart';
import 'package:bam_wallet/features/login/domain/entities/user.dart';
import 'package:bam_wallet/features/login/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final LoginDataSource _loginDataSource;
  final LocalAuthenticationDataSource _localAuthenticationDataSource;

  AuthenticationRepositoryImpl({
    required LoginDataSource loginDataSource,
    required LocalAuthenticationDataSource localAuthenticationDataSource,
  }) : _loginDataSource = loginDataSource,
       _localAuthenticationDataSource = localAuthenticationDataSource;

  @override
  Future<bool> logOut() async {
    await _localAuthenticationDataSource.clearSession();
    return true;
  }

  @override
  Future<void> saveSession(String sessionToken) async {
    await _localAuthenticationDataSource.saveSession(sessionToken);
  }

  @override
  Future<User> signInWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    final userModel = await _loginDataSource.loginWithEmailAndPassword(
      UserPasswordModel(username: username, password: password),
    );
    await saveSession(userModel.accessToken);
    await _localAuthenticationDataSource.saveUserData(userModel);
    return User(
      id: userModel.id,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      accessToken: userModel.accessToken,
      username: userModel.username,
    );
  }

  @override
  Future<String> getSessionToken() async {
    return await _localAuthenticationDataSource.getSession() ?? '';
  }

  @override
  Future<bool> isLoggedIn() async {
    final sessionToken = await _localAuthenticationDataSource.getSession();
    return sessionToken != null && sessionToken.isNotEmpty;
  }

  @override
  Future<User?> getUserData() async {
    final userModel = await _localAuthenticationDataSource.getUserData();
    if (userModel == null) return null;
    return User(
      id: userModel.id,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      accessToken: userModel.accessToken,
      username: userModel.username,
    );
  }
}
