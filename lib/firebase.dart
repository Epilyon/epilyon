import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

// TODO: Impl this and open right view depending on notification

bool _initialized = false;

void initFirebase()
{
  if (_initialized) {
    return;
  }

  _initialized = true;

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      // {notification: {title: this is a title, body: this is a body}, data: {status: done, id: 1, color: #ff0000, click_action: FLUTTER_NOTIFICATION_CLICK}}
      print("onMessage: $message");
    },
    onBackgroundMessage: handleBackgroundMessage,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      // {notification: {}, data: {collapse_key: com.litarvan.epilyon, color: #ff0000, google.original_priority: high, google.sent_time: 1581341404242, google.delivered_priority: high, google.ttl: 2419200, from: 472301904711, id: 1, click_action: FLUTTER_NOTIFICATION_CLICK, google.message_id: 0:1581341404252844%4fecd5444fecd544, status: done}}
      print("onResume: $message");
    },
  );
}

Future<dynamic> handleBackgroundMessage(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('Data : ');
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('Notification : ');
    print(notification);
  }

  // Or do other work.
  return "";
}

Future<String> getDeviceToken() async {
  try {
    return await _firebaseMessaging.getToken();
  } catch (e) {
    print('Error while getting device token');
    print(e);

    return "nope";
  }
}
