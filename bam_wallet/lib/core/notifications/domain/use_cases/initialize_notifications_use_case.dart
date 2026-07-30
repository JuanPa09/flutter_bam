import 'package:bam_wallet/core/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter/foundation.dart';

/// Solicita permisos, obtiene el token FCM y lo persiste en Firestore.
/// Retorna el token o null si el usuario denegó los permisos.
class InitializeNotificationsUseCase {
  final NotificationRepository repository;

  InitializeNotificationsUseCase({required this.repository});

  Future<String?> call({required String userId}) async {
    final granted = await repository.requestPermission();
    if (!granted) return null;

    final token = await repository.getFCMToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
      await repository.saveTokenToFirestore(userId: userId, token: token);
    }
    return token;
  }
}
