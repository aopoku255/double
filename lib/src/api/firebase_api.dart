import 'package:doubles/src/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of firebase messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Request permission for iOS
  Future<void> requestPermission() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed('/events', arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
