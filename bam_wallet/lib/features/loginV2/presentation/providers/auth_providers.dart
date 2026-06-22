import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/get_user_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/loginV2/presentation/state/auth_state.dart';
import 'package:bam_wallet/features/loginV2/data/di/authentication_di.dart';

// Use Cases
final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(authenticationRepository: ref.watch(authRepositoryProvider));
});

final logOutUseCaseProvider = Provider((ref) {
  return LogOutUseCase(ref.watch(authRepositoryProvider));
});

final getUserUseCaseProvider = Provider((ref) {
  return GetUserUseCase(authenticationRepository: ref.watch(authRepositoryProvider));
});

final isLoggedUseCaseProvider = Provider((ref) {
  return IsLoggedUseCase(authenticationRepository: ref.watch(authRepositoryProvider));
});

// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogOutUseCase _logOutUseCase;
  final GetUserUseCase _getUserUseCase;
  final IsLoggedUseCase _isLoggedUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required LogOutUseCase logOutUseCase,
    required GetUserUseCase getUserUseCase,
    required IsLoggedUseCase isLoggedUseCase,
  }) : _loginUseCase = loginUseCase,
       _logOutUseCase = logOutUseCase,
       _getUserUseCase = getUserUseCase,
       _isLoggedUseCase = isLoggedUseCase,
       super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLogged = await _isLoggedUseCase();
      if (isLogged) {
        final user = await _getUserUseCase();
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> login(String username, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _loginUseCase(username, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _logOutUseCase();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void clearError() {
    state = const AuthState.initial();
  }
}

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    logOutUseCase: ref.watch(logOutUseCaseProvider),
    getUserUseCase: ref.watch(getUserUseCaseProvider),
    isLoggedUseCase: ref.watch(isLoggedUseCaseProvider),
  );
});

// Convenience providers
final userProvider = Provider((ref) {
  return ref.watch(authStateProvider).whenOrNull(authenticated: (user) => user);
});

final isAuthenticatedProvider = Provider((ref) {
  return ref.watch(authStateProvider).maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
});

