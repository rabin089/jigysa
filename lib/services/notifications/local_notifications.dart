// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _plugin =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings();
//     const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
//
//     await _plugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (response) {
//         // Handle when user taps on notification (foreground)
//         final payload = response.payload;
//         if (payload != null) {
//
//           print("🔔 Notification tapped with payload: $payload");
//         }
//       },
//     );
//   }
//
//   static Future<void> showNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const iosDetails = DarwinNotificationDetails();
//
//     const platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _plugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       message.notification?.title ?? "No title",
//       message.notification?.body ?? "No body",
//       platformDetails,
//       payload: message.data.toString(),
//     );
//   }
// }
