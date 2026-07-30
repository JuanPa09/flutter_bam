import 'package:bam_wallet/core/notifications/data/data_sources/notification_data_source.dart';
import 'package:bam_wallet/core/notifications/domain/entities/notification_entity.dart';
import 'package:bam_wallet/core/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl({required NotificationDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<bool> requestPermission() => _dataSource.requestPermission();

  @override
  Future<String?> getFCMToken() => _dataSource.getFCMToken();

  @override
  Future<void> saveTokenToFirestore({
    required String userId,
    required String token,
  }) => _dataSource.saveTokenToFirestore(userId: userId, token: token);

  @override
  Stream<NotificationEntity> get onForegroundNotification =>
      _dataSource.onForegroundNotification;
}
