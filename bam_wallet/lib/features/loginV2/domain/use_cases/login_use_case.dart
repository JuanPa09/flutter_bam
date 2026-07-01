import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/domain/entities/user.dart';
import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class LoginUseCase {

  final AuthenticationRepository _authenticationRepository;

  LoginUseCase({AuthenticationRepository? authenticationRepository})
      : _authenticationRepository = authenticationRepository ?? AuthenticationRepositoryImpl();

  Future<User> call(String username, String password) async {
    return await _authenticationRepository.signIUpWithUsernameAndPassword(
      username: username,
      password: password,
    );
  }

}