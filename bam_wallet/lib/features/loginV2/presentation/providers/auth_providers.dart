import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/get_user_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/remote_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/local_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/domain/entities/user.dart';
import 'package:bam_wallet/features/loginV2/presentation/state/auth_state.dart';
import 'package:dio/dio.dart' as dio;

// Dio Provider
final dioProvider = Provider<dio.Dio>((ref) {
  return dio.Dio();
});

// Data Sources
final remoteAuthDataSourceProvider = Provider<RemoteAuthenticationDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return RemoteAuthenticationDataSource(dio: dio);
});

final localAuthDataSourceProvider = Provider<LocalAuthenticationDataSource>((
  ref,
) {
  return LocalAuthenticationDataSource();
});

// Repository
final authRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(remoteAuthDataSourceProvider);
  final localDataSource = ref.watch(localAuthDataSourceProvider);
  return AuthenticationRepositoryImpl(
    remoteAuthenticationDataSource: remoteDataSource,
    localAuthenticationDataSource: localDataSource,
  );
});

// Use Cases
final loginUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authenticationRepository: repository);
});

final logOutUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogOutUseCase(repository);
});

final getUserUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetUserUseCase(authenticationRepository: repository);
});

final isLoggedUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return IsLoggedUseCase(authenticationRepository: repository);
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
        final userModel = await _getUserUseCase();
        if (userModel != null) {
          final user = User.fromModel(userModel);
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
}

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final logOutUseCase = ref.watch(logOutUseCaseProvider);
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  final isLoggedUseCase = ref.watch(isLoggedUseCaseProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    logOutUseCase: logOutUseCase,
    getUserUseCase: getUserUseCase,
    isLoggedUseCase: isLoggedUseCase,
  );
});

// Convenience providers
final userProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(authenticated: (user) => user);
});

final isAuthenticatedProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(authenticated: (_) => true, orElse: () => false);
});
