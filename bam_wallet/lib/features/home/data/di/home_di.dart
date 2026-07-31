import 'package:bam_wallet/core/notifications/data/di/notification_di.dart';
import 'package:bam_wallet/features/home/data/data_sources/firebase_bank_account_data_source.dart';
import 'package:bam_wallet/features/home/data/data_sources/bank_account_data_source.dart';
import 'package:bam_wallet/features/home/data/repositories/home_repository_impl.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inyección de dependencias para el módulo Home.
/// Expone abstracciones (HomeRepository) hacia arriba.
final firebaseBankAccountDataSourceProvider = Provider<BankAccountDataSource>((
  ref,
) {
  return FirebaseBankAccountDataSource(firestore: FirebaseFirestore.instance);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    firebaseBankAccountDataSource: ref.watch(
      firebaseBankAccountDataSourceProvider,
    ),
    notificationRepository: ref.watch(notificationRepositoryProvider),
  );
});
