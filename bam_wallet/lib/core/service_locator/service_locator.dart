import 'package:bam_wallet/features/login/presentation/state/login_provider.dart';
import 'package:bam_wallet/features/login/domain/use_cases/is_logged_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/login_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/log_out_use_case.dart';
import 'package:bam_wallet/features/login/domain/use_cases/get_user_use_case.dart';
import 'package:bam_wallet/features/login/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/login/data/data_sources/firebase_login_data_source.dart';
import 'package:bam_wallet/features/login/data/data_sources/local_authentication_data_source.dart';
import 'package:bam_wallet/core/notifications/data/data_sources/firebase_notification_data_source.dart';
import 'package:bam_wallet/core/notifications/data/repositories/notification_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bam_wallet/features/home/data/data_sources/firebase_bank_account_data_source.dart';
import 'package:bam_wallet/features/home/data/repositories/home_repository_impl.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late LoginProvider _loginProvider;
  late HomeRepositoryImpl _homeRepository;

  Future<void> setup(String environment) async {
    // Firebase Auth initialization
    final firebaseAuth = FirebaseAuth.instance;

    final localAuthenticationDataSource = LocalAuthenticationDataSource();
    final firebaseLoginDataSource = FirebaseLoginDataSource(
      firebaseAuth: firebaseAuth,
    );
    final authenticationRepository = AuthenticationRepositoryImpl(
      loginDataSource: firebaseLoginDataSource,
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

    // Firebase
    final firebaseFirestore = FirebaseFirestore.instance;
    final firebaseBankAccountDataSource = FirebaseBankAccountDataSource(
      firestore: firebaseFirestore,
    );

    // Notification Repository
    final firebaseNotificationDataSource = FirebaseNotificationDataSource();
    final notificationRepository = NotificationRepositoryImpl(
      dataSource: firebaseNotificationDataSource,
    );

    // Home Repository
    _homeRepository = HomeRepositoryImpl(
      firebaseBankAccountDataSource: firebaseBankAccountDataSource,
      notificationRepository: notificationRepository,
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
  HomeRepositoryImpl get homeRepository => _homeRepository;
}
