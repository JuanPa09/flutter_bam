import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class IsLoggedUseCase {
  
  final AuthenticationRepository _authenticationRepository;

  IsLoggedUseCase({AuthenticationRepository? authenticationRepository})
      : _authenticationRepository = authenticationRepository ?? AuthenticationRepositoryImpl();

  Future<bool> call() async {
    return _authenticationRepository.isLoggedIn();
  }

}
