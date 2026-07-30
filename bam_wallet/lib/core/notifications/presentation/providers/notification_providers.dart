import 'package:bam_wallet/core/notifications/data/di/notification_di.dart';
import 'package:bam_wallet/core/notifications/domain/entities/notification_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stream de notificaciones recibidas en primer plano.
final foregroundNotificationProvider = StreamProvider<NotificationEntity>((ref) {
  return ref.watch(notificationRepositoryProvider).onForegroundNotification;
});

/// Inicializa FCM para el usuario dado: solicita permisos,
/// obtiene el token y lo persiste en Firestore.
/// Retorna el token FCM o null si se denegaron permisos.
final fcmTokenProvider =
    FutureProvider.family<String?, String>((ref, userId) async {
  final useCase = ref.watch(initializeNotificationsUseCaseProvider);
  return useCase(userId: userId);
});
