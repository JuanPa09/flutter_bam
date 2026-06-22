import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class IsLoggedUseCase {
  final AuthenticationRepository _authenticationRepository;

  IsLoggedUseCase({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  Future<bool> call() async {
    return _authenticationRepository.isLoggedIn();
  }
}
