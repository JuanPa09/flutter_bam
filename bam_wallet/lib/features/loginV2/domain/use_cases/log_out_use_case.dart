import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class LogOutUseCase {

  final AuthenticationRepository _authenticationRepository;

  LogOutUseCase(this._authenticationRepository);

  Future<bool> call() async {
    return await _authenticationRepository.logOut();
  }

}