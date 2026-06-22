import 'package:bam_wallet/features/loginV2/domain/entities/user.dart';
import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  Future<User> call(String username, String password) async {
    return await _authenticationRepository.signInWithUsernameAndPassword(
      username: username,
      password: password,
    );
  }
}