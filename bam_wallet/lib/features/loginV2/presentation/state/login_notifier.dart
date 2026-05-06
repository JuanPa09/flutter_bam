import 'package:bam_wallet/features/loginV2/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/loginV2/presentation/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginRiverpodProvider =
    StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final IsLoggedUseCase _isLoggedUseCase;

  LoginNotifier(
    {LoginUseCase? loginUseCase, IsLoggedUseCase? isLoggedUseCase}
  ) : _loginUseCase = loginUseCase ?? LoginUseCase(),
      _isLoggedUseCase = isLoggedUseCase ?? IsLoggedUseCase(),
       super(LoginInitialState());

  Future<void> checkIfLogged(String username, String password) async {
    state = LoginCheckingCacheState();
    final isLogged = await _isLoggedUseCase.call();
    if (isLogged) {
      state = LoginSuccessState('Usuario');
    } else {
      state = LoginInitialState();
    }
  }

  Future<bool> login(String username, String password) async {
    state = LoginLoadingState();
    try {
      final user = await _loginUseCase.call(username, password);
      state = LoginSuccessState(user.username);
      return true;
    } catch (e) {
      state = LoginErrorState(e.toString());
      return false;
    }
  }

}
