import 'package:bam_wallet/features/login/data/data_sources/local_authentication_data_source.dart';
import 'package:bam_wallet/features/login/data/data_sources/firebase_login_data_source.dart';
import 'package:bam_wallet/features/login/data/repositories/authentication_repository_impl.dart';
import 'package:bam_wallet/features/login/domain/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseLoginDataSourceProvider = Provider<FirebaseLoginDataSource>((
  ref,
) {
  return FirebaseLoginDataSource(firebaseAuth: ref.watch(firebaseAuthProvider));
});

final localAuthDataSourceProvider = Provider<LocalAuthenticationDataSource>((
  ref,
) {
  return LocalAuthenticationDataSource();
});

/// Typed as the abstract [AuthenticationRepository] so consumers
/// never depend on the concrete implementation.
final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    loginDataSource: ref.watch(firebaseLoginDataSourceProvider),
    localAuthenticationDataSource: ref.watch(localAuthDataSourceProvider),
  );
});
