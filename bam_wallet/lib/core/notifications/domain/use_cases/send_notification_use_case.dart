import 'package:bam_wallet/core/notifications/domain/repositories/notification_repository.dart';

class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase({required this.repository});

  Future<void> call({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    return repository.sendNotification(
      userId: userId,
      title: title,
      body: body,
      data: data,
    );
  }
}
