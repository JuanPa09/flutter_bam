import 'package:bam_wallet/features/loginV2/data/data_sources/local_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/remote_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_password_model.dart';
import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';
import 'package:bam_wallet/features/loginV2/domain/entities/user.dart';
import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final RemoteAuthenticationDataSource _remoteAuthenticationDataSource;
  final LocalAuthenticationDataSource _localAuthenticationDataSource;

  AuthenticationRepositoryImpl({
    RemoteAuthenticationDataSource? remoteAuthenticationDataSource,
    LocalAuthenticationDataSource? localAuthenticationDataSource,
  }) : _remoteAuthenticationDataSource =
           remoteAuthenticationDataSource ?? RemoteAuthenticationDataSource(),
       _localAuthenticationDataSource =
           localAuthenticationDataSource ?? LocalAuthenticationDataSource();

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
  Future<User> signIUpWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await _remoteAuthenticationDataSource
          .signIUpWithUsernameAndPassword(
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
    } catch (e) {
      print('Error in signIUpWithUsernameAndPassword: $e');
      rethrow;
    }
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
  Future<UserModel?> getUserData() async {
    return await _localAuthenticationDataSource.getUserData();
  }
}
