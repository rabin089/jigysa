// import 'dart:convert';
//
// import 'package:docprep/services/navigator/navigator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import '../../modules/assessment/screen/assessment.details.screen.dart';
// import '../../modules/result_logs/screen/result.screen.dart';
//
// class LocalNotificationService {
//   final FlutterLocalNotificationsPlugin _localNotificationPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification() async {
//     // Initialize timezone data for scheduling
//     tz.initializeTimeZones();
//
//     // Android Initialization
//     const AndroidInitializationSettings androidInitialization =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS Initialization
//     const DarwinInitializationSettings iOSInitialization = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     // Initialize Settings
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitialization,
//       iOS: iOSInitialization,
//     );
//
//     // Initialize Plugin
//     await _localNotificationPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         if (details.payload != null) {
//           _handleNotificationTap(details.payload!);
//         }
//       },
//     );
//   }
//
//   Future<NotificationDetails> _notificationDetails() async {
//     // Android Notification Details
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_id', // Unique channel ID
//       'channel_name', // Channel Name
//       channelDescription: 'This is the description of the channel.',
//       importance: Importance.max,
//       priority: Priority.high,
//       styleInformation: BigTextStyleInformation(''),
//     );
//
//     // iOS Notification Details
//     const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();
//
//     return const NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );
//   }
//
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     try {
//       final details = await _notificationDetails();
//       await _localNotificationPlugin.show(id, title, body, details, payload: payload);
//     } catch (e) {
//       debugPrint('Error displaying notification: $e');
//     }
//   }
//
//   static void _handleNotificationTap(String data) {
//     final payload = jsonDecode(data);
//     // Always route to home root first
//     AppNavigator.pushNamedAndRemoveUntil('/home', (route) => false);
//
//     // Defer actual deep link navigation slightly to allow home to mount
//     Future.delayed(const Duration(milliseconds: 300), () {
//       try {
//         final attemptId = payload['attemptId'];
//         final status = payload['status'];
//         final topicId = payload['topicId'];
//
//         final ctx = AppNavigator.currentContext;
//         if (ctx == null) return;
//
//         if (attemptId != null) {
//           if (status == 'IN_PROGRESS') {
//             Navigator.of(ctx).push(
//               MaterialPageRoute(
//                 builder: (_) => AssessmentDetailsScreen(
//                   id: topicId?.toString(),
//                   status: status?.toString(),
//                 ),
//               ),
//             );
//           } else if (status == 'COMPLETED') {
//             Navigator.of(ctx).push(
//               MaterialPageRoute(
//                 builder: (_) => ResultScreen(
//                   logId: attemptId.toString(),
//                   title: 'Log Details',
//                 ),
//               ),
//             );
//           } else {
//             Navigator.of(ctx).push(
//               MaterialPageRoute(
//                 builder: (_) => ResultScreen(
//                   logId: attemptId.toString(),
//                   title: 'Log Details',
//                 ),
//               ),
//             );
//           }
//         } else {
//           // Fallback to Home
//           AppNavigator.pushNamedAndRemoveUntil('/home', (route) => false);
//         }
//       } catch (e) {
//         // In case of any parsing/navigation issues, ensure the app is at home
//         AppNavigator.pushNamedAndRemoveUntil('/home', (route) => false);
//       }
//     });
//   }
// }
