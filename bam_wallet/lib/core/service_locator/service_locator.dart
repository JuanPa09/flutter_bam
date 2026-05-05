import 'package:dio/dio.dart' as dio;
import 'package:bam_wallet/core/network/dio_interceptor.dart';
import 'package:bam_wallet/features/login/data/datasources/login_remote_datasource.dart';
import 'package:bam_wallet/features/login/data/datasources/mock_login_datasource.dart';
import 'package:bam_wallet/features/login/data/repositories/login_repository_impl.dart';
import 'package:bam_wallet/features/login/data/repositories/login_repository_mock_impl.dart';
import 'package:bam_wallet/features/login/domain/repositories/login_repository.dart';
import 'package:bam_wallet/features/login/domain/usecases/login_usecase.dart';
import 'package:bam_wallet/features/login/domain/usecases/logout_usecase.dart';
import 'package:bam_wallet/features/login/presentation/providers/login_provider.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late LoginRepository _loginRepository;
  late LoginUseCase _loginUseCase;
  late LogoutUseCase _logoutUseCase;
  late LoginProvider _loginProvider;

  Future<void> setup(String environment) async {
    // Repositories
    if (environment == 'mock') {
      _loginRepository = LoginRepositoryMockImpl(
        mockDataSource: MockLoginDataSource(),
      );
    } else {
      final dioClient = dio.Dio();
      dioClient.interceptors.add(DioInterceptor(dio: dioClient));

      final loginRemoteDataSource = LoginRemoteDataSource(dioClient: dioClient);
      _loginRepository = LoginRepositoryImpl(
        remoteDataSource: loginRemoteDataSource,
      );
    }

    // Use cases
    _loginUseCase = LoginUseCase(_loginRepository);
    _logoutUseCase = LogoutUseCase(_loginRepository);

    // Providers
    _loginProvider = LoginProvider(
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
    );
  }

  LoginProvider get loginProvider => _loginProvider;
  LoginRepository get loginRepository => _loginRepository;
}
