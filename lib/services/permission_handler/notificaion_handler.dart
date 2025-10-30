// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../notifications/local_notification_services.dart';
//
// class NotificationHandler extends StatefulWidget {
//   final Widget child;
//   const NotificationHandler({super.key, required this.child});
//
//   @override
//   State<NotificationHandler> createState() => _NotificationHandlerState();
// }
//
// class _NotificationHandlerState extends State<NotificationHandler> {
//   @override
//   void initState() {
//     super.initState();
//     _initFCM();
//   }
//
//   Future<void> _initFCM() async {
//     final messaging = FirebaseMessaging.instance;
//
//     // Init local notifications
//     await LocalNotificationService().initNotification();
//
//     // Request permission
//     await messaging.requestPermission(alert: true, badge: true, sound: true);
//
//     // Foreground messages → show local notification
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("📩 Foreground: ${message.notification?.title}");
//       if (message.notification != null) {
//         final data = message.data;
//         final String title = message.notification?.title ?? "";
//         final String body = message.notification?.body ?? "";
//
//         final payload = {
//           'title': title,
//           'body': body,
//           if (data.containsKey('attemptId')) 'attemptId': data['attemptId'],
//           if (data.containsKey('attemptedStatus'))
//             'status': data['attemptedStatus'],
//           if (data.containsKey('topicId')) 'topicId': data['topicId'],
//         };
//
//         int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//         LocalNotificationService().showNotification(
//           id: notificationId,
//           title: title,
//           body: body,
//           payload: jsonEncode(payload),
//         );
//       }
//     });
//
//     // When app is opened from background (tray tapped)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("📩 Opened from background: ${message.data}");
//       // TODO: navigate using message.data
//     });
//
//     // When app is launched from terminated state
//     final initialMsg = await messaging.getInitialMessage();
//     if (initialMsg != null) {
//       debugPrint(
//         "🚀 Launched from terminated by notification: ${initialMsg.data}",
//       );
//       // TODO: handle deep link navigation
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
