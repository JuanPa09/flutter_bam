import 'package:bam_wallet/core/notifications/domain/entities/notification_entity.dart';

interface class NotificationDataSource {
  Future<bool> requestPermission() async => false;
  Future<String?> getFCMToken() async => null;
  Future<void> saveTokenToFirestore({
    required String userId,
    required String token,
  }) async {}
  Stream<NotificationEntity> get onForegroundNotification =>
      const Stream.empty();
}
