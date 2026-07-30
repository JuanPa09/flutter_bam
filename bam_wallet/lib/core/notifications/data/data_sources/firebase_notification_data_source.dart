import 'package:bam_wallet/core/notifications/data/data_sources/notification_data_source.dart';
import 'package:bam_wallet/core/notifications/domain/entities/notification_entity.dart';
import 'package:bam_wallet/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationDataSource implements NotificationDataSource {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  FirebaseNotificationDataSource({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken(
        vapidKey: DefaultFirebaseOptions.webVapidKey,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveTokenToFirestore({
    required String userId,
    required String token,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('fcm_tokens')
        .doc(token)
        .set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<NotificationEntity> get onForegroundNotification {
    return FirebaseMessaging.onMessage.map(
      (message) => NotificationEntity(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        data: message.data,
        receivedAt: DateTime.now(),
      ),
    );
  }
}
