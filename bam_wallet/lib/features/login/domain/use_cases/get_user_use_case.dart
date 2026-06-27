import 'package:bam_wallet/features/login/domain/entities/user.dart';
import 'package:bam_wallet/features/login/domain/repositories/authentication_repository.dart';

class GetUserUseCase {
  final AuthenticationRepository _authenticationRepository;

  GetUserUseCase({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  Future<User?> call() async {
    return await _authenticationRepository.getUserData();
  }
}
