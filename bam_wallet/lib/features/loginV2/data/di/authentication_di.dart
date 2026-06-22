import 'package:bam_wallet/features/loginV2/data/data_sources/local_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/data/data_sources/remote_authentication_data_source.dart';
import 'package:bam_wallet/features/loginV2/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/loginV2/domain/repositories/authentication_repository.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<dio.Dio>((ref) => dio.Dio());

final remoteAuthDataSourceProvider = Provider<RemoteAuthenticationDataSource>((ref) {
  return RemoteAuthenticationDataSource(dio: ref.watch(dioProvider));
});

final localAuthDataSourceProvider = Provider<LocalAuthenticationDataSource>((ref) {
  return LocalAuthenticationDataSource();
});

/// Typed as the abstract [AuthenticationRepository] so consumers
/// never depend on the concrete implementation.
final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    remoteAuthenticationDataSource: ref.watch(remoteAuthDataSourceProvider),
    localAuthenticationDataSource: ref.watch(localAuthDataSourceProvider),
  );
});
