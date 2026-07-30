import 'package:bam_wallet/core/notifications/data/data_sources/firebase_notification_data_source.dart';
import 'package:bam_wallet/core/notifications/data/data_sources/notification_data_source.dart';
import 'package:bam_wallet/core/notifications/data/repositories/notification_repository_impl.dart';
import 'package:bam_wallet/core/notifications/domain/repositories/notification_repository.dart';
import 'package:bam_wallet/core/notifications/domain/use_cases/initialize_notifications_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
  return FirebaseNotificationDataSource();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    dataSource: ref.watch(notificationDataSourceProvider),
  );
});

final initializeNotificationsUseCaseProvider = Provider((ref) {
  return InitializeNotificationsUseCase(
    repository: ref.watch(notificationRepositoryProvider),
  );
});
