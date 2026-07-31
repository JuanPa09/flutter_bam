import 'package:bam_wallet/core/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<bool> requestPermission();
  Future<String?> getFCMToken();
  Future<void> saveTokenToFirestore({
    required String userId,
    required String token,
  });
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  });
  Stream<NotificationEntity> get onForegroundNotification;
}
