import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_feeding_app/services/firebase_messaging_handler.dart';

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Define notification channel for Android
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  // Initialize notification service
  Future<void> initialize() async {
    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission for iOS
    await _requestNotificationPermissions();

    // Create Android notification channel
    await _setupNotificationChannel();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set up foreground message handler
    _setupForegroundNotificationHandler();

    // Get the FCM token and print it for testing
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: $token");
    });
  }

  // Request notification permissions (especially important for iOS)
  Future<void> _requestNotificationPermissions() async {
    // Request permission (required for iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print(
        'User notification permission status: ${settings.authorizationStatus}');
  }

  // Set up Android notification channel
  Future<void> _setupNotificationChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
  }

  // Handle notification tap
  void _handleNotificationResponse(NotificationResponse response) {
    print("Notification tapped: ${response.payload}");
    if (response.payload != null) {
      navigatorKey.currentState?.pushNamed('/', arguments: {
        'message': response.payload,
      });
    }
  }

  // Set up handling of foreground messages
  void _setupForegroundNotificationHandler() {
    // Handle foreground messages (when app is open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Got a message in the foreground!");
      print("Message data: ${message.data}");

      _showLocalNotification(message);
    });

    // Handle when a notification is clicked in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.data}");
      _handleMessageOpened(message);
    });

    // Handle when app is opened from a terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("getInitialMessage: ${message.data}");
        _handleMessageOpened(message);
      }
    });
  }

  // Show local notification
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If message contains a notification and we're on Android
    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  // Handle when message is opened
  void _handleMessageOpened(RemoteMessage message) {
    navigatorKey.currentState?.pushNamed('/', arguments: {
      'message': jsonEncode(message.data),
    });
  }
}
