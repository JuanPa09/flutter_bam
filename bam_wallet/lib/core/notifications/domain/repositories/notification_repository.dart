import 'package:bam_wallet/core/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<bool> requestPermission();
  Future<String?> getFCMToken();
  Future<void> saveTokenToFirestore({
    required String userId,
    required String token,
  });
  Stream<NotificationEntity> get onForegroundNotification;
}
