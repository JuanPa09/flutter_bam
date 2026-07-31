# Cloud Function: Notification Handler

## Overview
This Cloud Function processes notification events from Firestore and sends them via Firebase Cloud Messaging (FCM) to user devices.

## Setup Instructions

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Initialize Firebase Functions
```bash
cd bam_wallet
firebase init functions
# Select TypeScript when prompted
# Choose existing project: bam-wallet-4995c
```

### 3. Create the Function

Create or update `functions/src/index.ts`:

```typescript
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

exports.sendNotificationToUser = functions.firestore
  .document("notification_events/{docId}")
  .onCreate(async (snap, context) => {
    const notificationData = snap.data() as NotificationEvent;
    const { userId, title, body, data } = notificationData;

    try {
      // Get user's FCM tokens
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

      // Send message to all user tokens
      const message = {
        notification: {
          title: title,
          body: body,
        },
        data: data || {},
        android: {
          priority: "high",
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

      // Send to all tokens
      const sendPromises = tokens.map((token) =>
        messaging.send({
          ...message,
          token: token,
        })
      );

      const results = await Promise.allSettled(sendPromises);

      // Count successes/failures
      const successful = results.filter((r) => r.status === "fulfilled").length;
      const failed = results.filter((r) => r.status === "rejected").length;

      // Update notification document as sent
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
      // Update with error status
      await snap.ref.update({
        sent: false,
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  });
```

### 4. Update `functions/package.json`

Ensure dependencies include:
```json
{
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.4.0"
  },
  "devDependencies": {
    "@types/node": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
```

### 5. Deploy the Function

```bash
# From project root
firebase deploy --only functions

# Or specific function
firebase deploy --only functions:sendNotificationToUser
```

### 6. Verify Deployment

```bash
# List deployed functions
firebase functions:list

# View logs
firebase functions:log
```

## Testing

### Test via Firestore Console

1. Go to Firebase Console → Firestore Database
2. Create a test document in `notification_events`:
```json
{
  "userId": "USER_ID_HERE",
  "title": "Test Notification",
  "body": "This is a test",
  "data": {
    "type": "transfer",
    "amount": "100"
  },
  "createdAt": "2024-01-15T10:00:00Z",
  "sent": false
}
```

3. Monitor Cloud Function logs in Firebase Console
4. Check device for notification

### Test via Flutter App

1. Make a transfer from transfer screen
2. Check Firestore `notification_events` collection for new document
3. Wait a few seconds for Cloud Function to process
4. Check notification appears on device
5. Verify `sent: true` updated in Firestore

## Troubleshooting

### "No tokens found for user"
- Ensure user has called `saveTokenToFirestore()` after login
- Check `users/{userId}/fcm_tokens/` collection is not empty

### "Permission denied" error
- Update Firestore security rules to allow Cloud Function to read tokens
- Example rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Message not appearing on device
- Check device has notification permissions enabled
- Verify device has active FCM token
- Check Cloud Function logs for send errors
- Ensure payload size < 4KB (total message size limit)

## Monitoring

### Key Metrics to Track
- `sentAt` timestamp for latency measurement
- `successCount` vs `failureCount` for delivery rate
- `error` field for debugging failed sends

### Query Examples (Firestore)

Failed notifications:
```
sent == false
```

Successful notifications:
```
sent == true AND successCount > 0
```

Notifications sent in last hour:
```
sentAt >= Timestamp.now() - 3600 seconds
```

## Security Considerations

1. **Authentication**: Cloud Function executes with admin privileges
2. **Rate Limiting**: Consider adding rate limits to prevent abuse
3. **Token Rotation**: Regularly clean up old/invalid tokens
4. **Data Validation**: Validate notification payload before sending
5. **Encryption**: Consider encrypting sensitive data in notification data field

## Cost Optimization

1. Delete old notification_events documents (older than 30 days)
2. Batch send operations to reduce API calls
3. Cache frequently used user tokens
4. Monitor FCM usage in Firebase Console

## Production Checklist

- [ ] Cloud Function deployed and tested
- [ ] Firestore rules updated for function access
- [ ] Error handling and logging in place
- [ ] Notification templates reviewed and approved
- [ ] Device testing completed (iOS, Android)
- [ ] Performance monitoring enabled
- [ ] Rate limiting configured
- [ ] Rollback plan documented
