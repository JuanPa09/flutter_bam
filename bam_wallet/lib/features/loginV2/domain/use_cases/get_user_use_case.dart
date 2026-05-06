import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';
import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';

class GetUserUseCase {
  final AuthenticationRepository _authenticationRepository;

  GetUserUseCase({AuthenticationRepository? authenticationRepository})
    : _authenticationRepository =
          authenticationRepository ?? AuthenticationRepositoryImpl();

  Future<UserModel?> call() async {
    return await _authenticationRepository.getUserData();
  }
}
