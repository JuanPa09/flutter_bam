import 'package:bam_wallet/features/login/data/datasources/mock_login_datasource.dart';
import 'package:bam_wallet/features/login/domain/entities/user.dart';
import 'package:bam_wallet/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryMockImpl implements LoginRepository {
  final MockLoginDataSource mockDataSource;

  User? _cachedUser;

  LoginRepositoryMockImpl({required this.mockDataSource});

  @override
  Future<User> login(String email, String password) async {
    final userModel = await mockDataSource.login(email, password);
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
