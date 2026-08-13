import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const firestore = admin.firestore();
const messaging = admin.messaging();

interface NotificationEvent {
  userId: string;
  title: string;
  body: string;
  data?: Record<string, string>;
  createdAt: admin.firestore.Timestamp;
  sent: boolean;
}

export const sendNotificationToUser = functions.firestore
  .document("notification_events/{docId}")
  .onCreate(async (snap) => {
    const notificationData = snap.data() as NotificationEvent;
    const { userId, title, body, data } = notificationData;

    try {
      const tokensSnapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("fcm_tokens")
        .get();

      const tokens = tokensSnapshot.docs.map((doc) => doc.id);

      if (tokens.length === 0) {
        console.log(`No tokens found for user ${userId}`);
        await snap.ref.update({ sent: true, reason: "no_tokens" });
        return;
      }

      const message = {
        notification: {
          title: title,
          body: body,
        },
        data: data || {},
        android: {
          priority: "high" as const,
          notification: {
            sound: "default",
            channelId: "default",
          },
        },
        apns: {
          headers: {
            "apns-priority": "10",
          },
          payload: {
            aps: {
              alert: {
                title: title,
                body: body,
              },
              sound: "default",
              badge: 1,
            },
          },
        },
      };

      const sendPromises = tokens.map((token) =>
        messaging.send({
          ...message,
          token: token,
        })
      );

      const results = await Promise.allSettled(sendPromises);

      const successful = results.filter((r) => r.status === "fulfilled").length;
      const failed = results.filter((r) => r.status === "rejected").length;

      await snap.ref.update({
        sent: true,
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
        tokensCount: tokens.length,
        successCount: successful,
        failureCount: failed,
      });

      console.log(
        `Notification sent to user ${userId}: ${successful} success, ${failed} failed`
      );
    } catch (error) {
      console.error(`Error sending notification: ${error}`);
      await snap.ref.update({
        sent: false,
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  });
