import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// TODO: Impl this and open right view depending on notification

bool _initialized = false;

void initFirebase() {
  if (_initialized) {
    return;
  }

  _initialized = true;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // {notification: {title: this is a title, body: this is a body}, data: {status: done, id: 1, color: #ff0000, click_action: FLUTTER_NOTIFICATION_CLICK}}
    print("onMessage: $message");
  });
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}

Future<dynamic> handleBackgroundMessage(RemoteMessage message) async {
  // Handle data message
  print('Data : ');
  print(message.data);

  print('Notification : ');
  print(message.notification);

  // Or do other work.
  return "";
}

Future<String?> getDeviceToken() async {
  try {
    return await _firebaseMessaging.getToken();
  } catch (e) {
    print('Error while getting device token');
    print(e);

    return "nope";
  }
}
