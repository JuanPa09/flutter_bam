import 'package:bam_wallet/features/login/data/datasources/login_remote_datasource.dart';
import 'package:bam_wallet/features/login/data/models/user_model.dart';
import 'package:bam_wallet/features/login/domain/entities/user.dart';
import 'package:bam_wallet/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  UserModel? _cachedUser;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    _cachedUser = userModel;
    return userModel;
  }

  @override
  Future<void> logout() async {
    _cachedUser = null;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return _cachedUser != null;
  }
}
