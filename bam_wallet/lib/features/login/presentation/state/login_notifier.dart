import 'package:bam_wallet/features/login/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/login/presentation/providers/auth_providers.dart';
import 'package:bam_wallet/features/login/presentation/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginRiverpodProvider =
    StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    isLoggedUseCase: ref.watch(isLoggedUseCaseProvider),
  ),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final IsLoggedUseCase _isLoggedUseCase;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required IsLoggedUseCase isLoggedUseCase,
  }) : _loginUseCase = loginUseCase,
       _isLoggedUseCase = isLoggedUseCase,
       super(const LoginState.initial());

  Future<void> checkIfLogged() async {
    state = const LoginState.checkingCache();
    final isLogged = await _isLoggedUseCase.call();
    state = isLogged
        ? const LoginState.success('Usuario')
        : const LoginState.initial();
  }

  Future<bool> login(String username, String password) async {
    state = const LoginState.loading();
    try {
      final user = await _loginUseCase.call(username, password);
      state = LoginState.success(user.username);
      return true;
    } catch (e) {
      state = LoginState.error(e.toString());
      return false;
    }
  }
}

