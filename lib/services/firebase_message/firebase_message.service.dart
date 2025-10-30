// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:docprep/services/navigator/navigator.dart';
// import 'package:docprep/modules/assessment/screen/assessment.details.screen.dart';
// import 'package:docprep/modules/result_logs/screen/result.screen.dart';
// import '../notifications/local_notification_services.dart';
// import '../local_storage/local_storage.services.dart';
//
// class FirebaseMessageService {
//   final FirebaseMessaging messageInstance = FirebaseMessaging.instance;
//
//   String firebaseToken = "";
//
//   FirebaseMessageService() {
//     messageInstance.onTokenRefresh
//         .listen((fcmToken) {
//           firebaseToken = fcmToken;
//           // TODO: If necessary send token to application server.
//           // Note: This callback is fired at each app startup and whenever a new
//           // token is generated.
//         })
//         .onError((err) {
//           debugPrint("error on refresh token ::: $err");
//         });
//   }
//
//   _onNotificationTapListen() async {
//     // Handle terminated state
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _navigateFromMessage(initialMessage);
//     }
//
//     // Handle background state
//     FirebaseMessaging.onMessageOpenedApp.listen(_navigateFromMessage);
//   }
//
//   void _navigateFromMessage(RemoteMessage message) {
//     // Always go to Home first to ensure context exists
//     AppNavigator.pushNamedAndRemoveUntil('/home', (route) => false);
//
//     // Now handle actual navigation after Home is mounted
//     Future.delayed(const Duration(milliseconds: 300), () {
//       final ctx = AppNavigator.currentContext;
//       if (ctx == null) return;
//
//       final data = message.data;
//       final attemptId = data['attemptId'];
//       final attemptedStatus = data['attemptedStatus'];
//       final topicId = data['topicId'];
//
//       if (attemptId != null) {
//         if (attemptedStatus == 'IN_PROGRESS') {
//           Navigator.of(ctx).push(
//             MaterialPageRoute(
//               builder: (_) => AssessmentDetailsScreen(
//                 id: topicId?.toString(),
//                 status: attemptedStatus?.toString(),
//               ),
//             ),
//           );
//         } else if (attemptedStatus == 'COMPLETED') {
//           Navigator.of(ctx).push(
//             MaterialPageRoute(
//               builder: (_) => ResultScreen(
//                 logId: attemptId.toString(),
//                 title: 'Log Details',
//               ),
//             ),
//           );
//         } else {
//           Navigator.of(ctx).push(
//             MaterialPageRoute(
//               builder: (_) => ResultScreen(
//                 logId: attemptId.toString(),
//                 title: 'Log Details',
//               ),
//             ),
//           );
//         }
//       }
//     });
//   }
//
//   Future<void> init() async {
//     await getFirebaseToken();
//     await subscribeToTopic();
//     _onNotificationTapListen();
//   }
//
//   getFirebaseToken() async {
//     messageInstance.getToken().then((token) {
//       if (token != null) {
//         debugPrint("firebase token ::: $token");
//         // TODO: If necessary send token to application server.
//         firebaseToken = token;
//       }
//     });
//   }
//
//   _listenToMessage() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("message ::: ${message.data}");
//
//       if (message.notification != null) {
//         final data = message.data;
//         final String title = message.notification?.title ?? "";
//         final String body = message.notification?.body ?? "";
//
//         final payload = {
//           'title': title,
//           'body': body,
//           if (data.containsKey('attemptId')) 'attemptId': data['attemptId'],
//           if (data.containsKey('attemptedStatus')) 'status': data['attemptedStatus'],
//           if (data.containsKey('topicId')) 'topicId': data['topicId'],
//         };
//
//         // Ensure a numeric ID for local notification
//         int notificationId = 1;
//         try {
//           if (message.ttl != null) {
//             notificationId = message.ttl!;
//           } else if (data['topicId'] != null) {
//             notificationId = int.tryParse(data['topicId'].toString()) ?? 1;
//           }
//         } catch (_) {}
//
//         LocalNotificationService().showNotification(
//           id: notificationId,
//           title: title,
//           body: body,
//           payload: jsonEncode(payload),
//         );
//       }
//     });
//   }
//
//   Future<void> subscribeToTopic() async {
//     String? id = await storageInstance.getFromStore(key: 'userId');
//     if (id != null) {
//       await messageInstance.subscribeToTopic("_$id");
//     }
//     await messageInstance.subscribeToTopic('docprep_general');
//     _listenToMessage();
//   }
//
//   unSubscribeToTopic() async {
//     String? id = await storageInstance.getFromStore(key: 'userId');
//     if (id != null) {
//       await messageInstance.unsubscribeFromTopic(id);
//     }
//   }
// }
