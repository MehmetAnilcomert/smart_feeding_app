import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/app_cubit.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_event.dart';
import 'package:smart_feeding_app/bloc/language_bloc.dart';
import 'package:smart_feeding_app/bloc/log_expand.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_bloc.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_event.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/modals/language.dart';
import 'package:smart_feeding_app/services/notification_service.dart';
import 'package:smart_feeding_app/services/websocket_service.dart';
import 'package:smart_feeding_app/widgets/app_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize LanguageManager and load saved language preference
  final languageManager = LanguageManager();
  await languageManager.loadLanguagePreference();

  runApp(MyApp(
    languageManager: languageManager,
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final LanguageManager languageManager;
  final NotificationService notificationService;

  MyApp({
    required this.languageManager,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AppCubit - Ana uygulama yöneticisi
        BlocProvider<AppCubit>(
          create: (_) => AppCubit(httpUrl: dotenv.env['HTTP_URL']!),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(languageManager)..loadSavedLanguage(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc()..add(ConnectivityObserve()),
        ),
        BlocProvider<SensorBloc>(
          create: (_) => SensorBloc(
            WebSocketService(webSocketUrl: dotenv.env['WEBSOCKET_URL']!),
          )..add(ConnectWebSocket()),
        ),
        BlocProvider<LogExpandCubit>(
          create: (_) => LogExpandCubit(),
        ),
      ],
      child: AppView(notificationService: notificationService),
    );
  }
}
