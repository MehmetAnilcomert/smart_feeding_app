import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/app_cubit.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/language_bloc.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/pages/mobile_screen.dart';
import 'package:smart_feeding_app/pages/web_screen.dart';
import 'package:smart_feeding_app/services/notification_service.dart';
import 'package:smart_feeding_app/widgets/responsive_layout.dart';

class AppView extends StatelessWidget {
  final NotificationService notificationService;

  const AppView({required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, appState) {
        final appCubit = context.read<AppCubit>();

        return BlocProvider<FeederBloc>.value(
          value: appCubit.feederBloc,
          child: Builder(
            builder: (context) {
              final themeBloc = context.watch<ThemeBloc>();
              final languageCubit = context.watch<LanguageCubit>();
              final locale = languageCubit.languageManager.locale;

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Smart Chicken Feeder',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeBloc.state.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                locale: locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                navigatorKey: notificationService.navigatorKey,
                home: _buildHomeScreen(appState),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHomeScreen(AppState appState) {
    // Uygulama hazır olmadan önce loading göster
    if (appState is AppLoading || appState is AppInitial) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ResponsiveLayout(
      mobileScreenLayout: MobileHomeScreen(),
      webScreenLayout: WebHomeScreen(),
    );
  }
}
