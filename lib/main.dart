import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/language_bloc.dart';
import 'package:smart_feeding_app/bloc/log_expand.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_bloc.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_event.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/modals/language.dart';
import 'package:smart_feeding_app/pages/mobile_screen.dart';
import 'package:smart_feeding_app/pages/web_screen.dart';
import 'package:smart_feeding_app/services/websocket_service.dart';
import 'package:smart_feeding_app/widgets/responsive_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Define notification channel for Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

// Initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized even in the background
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permission for iOS
  await _requestNotificationPermissions();

  // Create Android notification channel
  await _setupNotificationChannel();

  // Initialize local notifications
  await _initializeLocalNotifications();

  // Set up foreground message handler
  _setupForegroundNotificationHandler();

  // Get the FCM token and print it for testing
  FirebaseMessaging.instance.getToken().then((token) {
    print("Firebase Messaging Token: $token");
  });

  // Load environment variables
  await dotenv.load(fileName: ".env");

  final languageManager = LanguageManager();
  runApp(MyApp(languageManager: languageManager));
}

// Request notification permissions (especially important for iOS)
Future<void> _requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission (required for iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User notification permission status: ${settings.authorizationStatus}');
}

// Set up Android notification channel
Future<void> _setupNotificationChannel() async {
  await flutterLocalNotificationsPlugin
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

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
      print("Notification tapped: ${response.payload}");
      if (response.payload != null) {
        navigatorKey.currentState?.pushNamed('/', arguments: {
          'message': response.payload,
        });
      }
    },
  );
}

// Set up handling of foreground messages
void _setupForegroundNotificationHandler() {
  // Handle foreground messages (when app is open)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message in the foreground!");
    print("Message data: ${message.data}");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If message contains a notification and we're on Android
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher', // You can customize this
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  });

  // Handle when a notification is clicked in the background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onMessageOpenedApp: ${message.data}");
    navigatorKey.currentState?.pushNamed('/', arguments: {
      'message': jsonEncode(message.data),
    });
  });

  // Handle when app is opened from a terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("getInitialMessage: ${message.data}");
      navigatorKey.currentState?.pushNamed('/', arguments: {
        'message': jsonEncode(message.data),
      });
    }
  });
}

class MyApp extends StatelessWidget {
  final LanguageManager languageManager;

  MyApp({required this.languageManager});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeederBloc>(
            create: (context) => FeederBloc(httpUrl: dotenv.env['HTTP_URL']!)),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(languageManager),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (context) => ConnectivityBloc()..add(ConnectivityObserve()),
        ),
        BlocProvider<SensorBloc>(
          create: (_) => SensorBloc(
            WebSocketService(webSocketUrl: dotenv.env['WEBSOCKET_URL']!),
          )..add(ConnectWebSocket()),
        ),
        BlocProvider<LogExpandCubit>(create: (_) => LogExpandCubit()),
      ],
      child: Builder(builder: (context) {
        final themeBloc = context.watch<ThemeBloc>();
        final languageCubit = context.watch<LanguageCubit>();
        final locale = languageCubit.languageManager.locale;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Chicken Feeder',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeBloc.state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          navigatorKey: navigatorKey,
          home: ResponsiveLayout(
            mobileScreenLayout: MobileHomeScreen(),
            webScreenLayout: WebHomeScreen(),
          ),
        );
      }),
    );
  }
}
