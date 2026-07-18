import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_notification_service.dart';
class FcmService {

  static Future<void> initialize() async {

    final messaging =
        FirebaseMessaging.instance;

    await messaging.requestPermission();

    final token =
        await messaging.getToken();

    print(
      "FCM TOKEN = $token",
    );

    final user =
        FirebaseAuth.instance.currentUser;

    if (user != null && token != null) {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({

        'fcmToken': token,

      });
    }

FirebaseMessaging.onMessage.listen(
  (RemoteMessage message) async {

    print(
      "NOTIFICATION RECEIVED",
    );

    print(
      "TITLE = ${message.notification?.title}",
    );

    print(
      "BODY = ${message.notification?.body}",
    );

    await LocalNotificationService
        .showNotification(
      title:
          message.notification?.title ??
          "ShieldHer Alert",
      body:
          message.notification?.body ??
          "Emergency Alert",
    );
  },

    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {

        print(
          "NOTIFICATION CLICKED",
        );
      },
    );
  }
}