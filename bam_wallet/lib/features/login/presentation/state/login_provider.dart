import 'package:bam_wallet/features/login/domain/entities/user.dart';
import 'package:bam_wallet/features/login/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/get_user_use_case.dart';
import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final IsLoggedUseCase _isLoggedUseCase;
  final LogOutUseCase _logOutUseCase;
  final GetUserUseCase _getUserUseCase;

  LoginProvider({
    required LoginUseCase loginUseCase,
    required IsLoggedUseCase isLoggedUseCase,
    required LogOutUseCase logOutUseCase,
    required GetUserUseCase getUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _isLoggedUseCase = isLoggedUseCase,
       _logOutUseCase = logOutUseCase,
       _getUserUseCase = getUserUseCase,
       super();

  String title = 'Login';
  bool logged = false;
  bool isLoading = false;
  bool isInitialized = false;
  String? errorMessage;
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => logged;

  Future<void> checkLoggedIn() async {
    title = 'Verificando sesión...';
    notifyListeners();
    try {
      final isLogged = await _isLoggedUseCase.call();
      if (isLogged) {
        title = 'Welcome back!';
        logged = true;
        try {
          final user = await _getUserUseCase.call();
          if (user != null) {
            _user = user;
          }
        } catch (e) {
          // User data may fail to load, but user is still logged in
          debugPrint('Error loading user data: $e');
          logged = true;
        }
      } else {
        title = 'Please log in';
        logged = false;
      }
    } catch (e) {
      debugPrint('Error checking logged in status: $e');
      logged = false;
      title = 'Please log in';
    } finally {
      isInitialized = true;
      notifyListeners();
    }
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
      final errorStr = e.toString();

      // Extrae el código de error de la excepción
      // Formato: "Exception: error_code"
      String errorCode = 'error_unexpected';
      if (errorStr.contains('Exception: ')) {
        final parts = errorStr.split('Exception: ');
        if (parts.length > 1) {
          errorCode = parts[1].replaceAll(')', '').trim();
        }
      }

      // Almacena el código de error para que se traduzca en la UI
      errorMessage = errorCode;
      title = 'Login Failed';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logOutUseCase.call();
    _user = null;
    logged = false;
    notifyListeners();
  }
}
