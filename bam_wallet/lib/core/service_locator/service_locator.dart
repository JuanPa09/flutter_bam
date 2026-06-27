import 'package:bam_wallet/features/login/presentation/state/login_provider.dart';
import 'package:bam_wallet/features/login/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/get_user_use_case.dart';
import 'package:bam_wallet/features/login/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/login/data/data_sources/remote_authentication_data_source.dart';
import 'package:bam_wallet/features/login/data/data_sources/local_authentication_data_source.dart';
import 'package:dio/dio.dart' as dio;
import 'package:bam_wallet/core/network/dio_interceptor.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late dio.Dio _dioClient;
  late LoginProvider _loginProvider;

  Future<void> setup(String environment) async {
    // Dio Client
    _dioClient = dio.Dio();
    _dioClient.interceptors.add(DioInterceptor(dio: _dioClient));

    // Authentication (loginV2)
    final remoteAuthenticationDataSource = RemoteAuthenticationDataSource(
      dio: _dioClient,
    );
    final localAuthenticationDataSource = LocalAuthenticationDataSource();
    final authenticationRepository = AuthenticationRepositoryImpl(
      remoteAuthenticationDataSource: remoteAuthenticationDataSource,
      localAuthenticationDataSource: localAuthenticationDataSource,
    );

    // Use cases
    final loginUseCase = LoginUseCase(
      authenticationRepository: authenticationRepository,
    );
    final isLoggedUseCase = IsLoggedUseCase(
      authenticationRepository: authenticationRepository,
    );
    final logOutUseCase = LogOutUseCase(authenticationRepository);
    final getUserUseCase = GetUserUseCase(
      authenticationRepository: authenticationRepository,
    );

    // Provider
    _loginProvider = LoginProvider(
      loginUseCase: loginUseCase,
      isLoggedUseCase: isLoggedUseCase,
      logOutUseCase: logOutUseCase,
      getUserUseCase: getUserUseCase,
    );

    await _loginProvider.checkLoggedIn();
  }

  LoginProvider get loginProvider => _loginProvider;
}

