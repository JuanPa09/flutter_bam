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
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
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
        .set({'token': token, 'updatedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      print('[NOTIFICATION] Sending notification to user: $userId');
      print('[NOTIFICATION] Title: $title');
      print('[NOTIFICATION] Body: $body');

      // Guardar evento de notificación en Firestore
      // Una Cloud Function escuchará esta colección y enviará la notificación
      final docRef = await _firestore.collection('notification_events').add({
        'userId': userId,
        'title': title,
        'body': body,
        'data': data ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'sent': false,
      });

      print('[NOTIFICATION] ✅ Document saved to Firestore: ${docRef.id}');
    } catch (e) {
      print('[NOTIFICATION] ❌ Error: $e');
      throw Exception('Error sending notification: $e');
    }
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
