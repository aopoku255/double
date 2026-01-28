import 'package:doubles/src/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title😊: ${message.notification?.title}');
  print('Body😁: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

Future<void> handleForegroundMessage(RemoteMessage message) async {
  print('😁: ${message.notification?.body}');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;



  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('FCM Token😁😁: $token');

    FirebaseMessaging.onMessage.listen(handleForegroundMessage);
    
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
