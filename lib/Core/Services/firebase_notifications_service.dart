// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../Config/app_constants.dart';
// import '../Config/storage_constants.dart';
// import 'storege_service.dart';
//
// // Background message handler (must be top-level function)
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('📬 Background Message: ${message.messageId}');
// }
//
// class FirebaseNotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   // Initialize Firebase Messaging
//   static Future<void> initialize() async {
//     // Request permission (iOS)
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('✅ User granted permission');
//     } else {
//       print('❌ User declined permission');
//     }
//
//     // Get FCM token
//     String? token = await _messaging.getToken();
//     print('🔑 FCM Token: $token');
//
//     if (token != null) {
//       AppConstants.fcmToken = token;
//       await StorageService.setString(StorageConstants.fcmToken, token);
//     }
//
//     // Listen to token refresh
//     _messaging.onTokenRefresh.listen((newToken) async {
//       print('🔄 FCM Token Refreshed: $newToken');
//       AppConstants.fcmToken = newToken;
//       await StorageService.setString(StorageConstants.fcmToken, newToken);
//     });
//
//     // TODO: Send this token to your backend
//     // await sendTokenToBackend(token);
//
//     // Initialize local notifications
//     await _initializeLocalNotifications();
//
//     // Set up background message handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('📨 Foreground Message: ${message.notification?.title}');
//       _showLocalNotification(message);
//     });
//
//     // Listen to notification taps
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('🔔 Notification Tapped: ${message.data}');
//       _handleNotificationTap(message);
//     });
//
//     // Check if app was opened from terminated state
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       print('🚀 App opened from notification: ${initialMessage.data}');
//       _handleNotificationTap(initialMessage);
//     }
//   }
//
//   // Initialize local notifications
//   static Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print('🔔 Local notification tapped: ${response.payload}');
//         // Handle tap
//       },
//     );
//
//     // Create notification channel (Android)
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin
//     >()
//         ?.createNotificationChannel(channel);
//   }
//
//   // Show local notification when app is in foreground
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     if (notification != null) {
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             channelDescription:
//             'This channel is used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: message.data.toString(),
//       );
//     }
//   }
//
//   // Handle notification tap
//   static void _handleNotificationTap(RemoteMessage message) {
//     // Navigate based on notification data
//     Map<String, dynamic> data = message.data;
//
//     if (data['type'] == 'order_update') {
//       // Navigate to order details
//       // Get.to(() => OrderDetailsScreen(orderId: data['orderId']));
//     } else if (data['type'] == 'promotion') {
//       // Navigate to promotions
//       // Get.to(() => PromotionsScreen());
//     }
//
//     print('📍 Navigating based on: $data');
//   }
//
//   // Send token to backend
//   static Future<void> sendTokenToBackend(String? token) async {
//     if (token == null) return;
//
//     // TODO: Replace with your API call
//     /*
//     try {
//       await Dio().post(
//         'YOUR_BACKEND_URL/api/save-fcm-token',
//         data: {
//           'userId': 'USER_ID',
//           'fcmToken': token,
//           'platform': Platform.isAndroid ? 'android' : 'ios',
//         },
//       );
//       print('✅ Token sent to backend');
//     } catch (e) {
//       print('❌ Error sending token: $e');
//     }
//     */
//   }
//
//   // Subscribe to topic
//   static Future<void> subscribeToTopic(String topic) async {
//     await _messaging.subscribeToTopic(topic);
//     print('✅ Subscribed to topic: $topic');
//   }
//
//   // Unsubscribe from topic
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     await _messaging.unsubscribeFromTopic(topic);
//     print('❌ Unsubscribed from topic: $topic');
//   }
// }