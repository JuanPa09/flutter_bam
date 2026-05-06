import 'package:bam_wallet/features/loginV2/presentation/state/login_provider.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/loginV2/domain/use_cases/get_user_use_case.dart';
import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/remote_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/local_authentication_data_source.dart';
import 'package:dio/dio.dart' as dio;
import 'package:bam_wallet/core/network/dio_interceptor.dart';
import 'package:bam_wallet/features/login/data/datasources/login_remote_datasource.dart';
import 'package:bam_wallet/features/login/data/datasources/mock_login_datasource.dart';
import 'package:bam_wallet/features/login/data/repositories/login_repository_impl.dart';
import 'package:bam_wallet/features/login/data/repositories/login_repository_mock_impl.dart';
import 'package:bam_wallet/features/login/domain/repositories/login_repository.dart';
// import 'package:bam_wallet/features/login/domain/usecases/login_usecase.dart';
// import 'package:bam_wallet/features/login/domain/usecases/logout_usecase.dart';
// import 'package:bam_wallet/features/login/presentation/providers/login_provider.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late LoginRepository _loginRepository;
  late dio.Dio _dioClient;
  // late LoginUseCase _loginUseCase;
  // late LogOutUseCase _logoutUseCase;
  late LoginProvider _loginProvider;
  // late LoginProvider _loginProvider;

  Future<void> setup(String environment) async {
    // Dio Client
    _dioClient = dio.Dio();
    _dioClient.interceptors.add(DioInterceptor(dio: _dioClient));

    // Repositories
    if (environment == 'mock') {
      _loginRepository = LoginRepositoryMockImpl(
        mockDataSource: MockLoginDataSource(),
      );
    } else {
      final loginRemoteDataSource = LoginRemoteDataSource(
        dioClient: _dioClient,
      );
      _loginRepository = LoginRepositoryImpl(
        remoteDataSource: loginRemoteDataSource,
      );
    }

    // LoginV2 - Authentication
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

    // Providers
    _loginProvider = LoginProvider(
      loginUseCase: loginUseCase,
      isLoggedUseCase: isLoggedUseCase,
      logOutUseCase: logOutUseCase,
      getUserUseCase: getUserUseCase,
    );

    // Espera a que se verifique la sesión antes de retornar
    await _loginProvider.checkLoggedIn();
  }

  LoginProvider get loginProvider => _loginProvider;
  LoginRepository get loginRepository => _loginRepository;
}
