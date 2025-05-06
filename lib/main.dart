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
import 'package:smart_feeding_app/services/notification_service.dart';
import 'package:smart_feeding_app/services/websocket_service.dart';
import 'package:smart_feeding_app/widgets/responsive_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  final languageManager = LanguageManager();
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
          navigatorKey: notificationService.navigatorKey,
          home: ResponsiveLayout(
            mobileScreenLayout: MobileHomeScreen(),
            webScreenLayout: WebHomeScreen(),
          ),
        );
      }),
    );
  }
}
