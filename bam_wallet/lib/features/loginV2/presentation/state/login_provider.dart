import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/domain/entities/user.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/login_use_case.dart';
import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final IsLoggedUseCase _isLoggedUseCase;
  final LogOutUseCase _logOutUseCase;

  LoginProvider({LoginUseCase? loginUseCase, IsLoggedUseCase? isLoggedUseCase, LogOutUseCase? logOutUseCase})
    : _loginUseCase = loginUseCase ?? LoginUseCase(),
      _isLoggedUseCase = isLoggedUseCase ?? IsLoggedUseCase(),
      _logOutUseCase = logOutUseCase ?? LogOutUseCase(AuthenticationRepositoryImpl()),
      super() {
        checkLoggedIn();
      }

  String title = 'Login';
  bool logged = false;
  bool isLoading = false;
  String? errorMessage;
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => logged;

  Future<void> checkLoggedIn() async {
    title = 'Verificando sesión...';
    notifyListeners();
    final isLogged = await _isLoggedUseCase.call();
    if (isLogged) {
      title = 'Welcome back!';
      logged = true;
    } else {
      title = 'Please log in';
      logged = false;
    }
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    title = 'Logging in...';
    notifyListeners();
    try {
      final user = await _loginUseCase.call(username, password);
      _user = user;
      logged = true;
      isLoading = false;
      title = 'Welcome, ${user.fullName}!';
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      print('Login error: $e');
      if (e.toString().contains('400')) {
        errorMessage = 'error_invalid_credentials';
      } else {
        errorMessage = e.toString();
      }
      title = 'Login';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logOutUseCase.call();
    _user = null;
    logged = false;
    title = 'Login';
    notifyListeners();
  }
}
