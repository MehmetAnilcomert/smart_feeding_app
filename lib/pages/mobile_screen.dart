import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/tab_cubit.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/custom_navbar.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/dashboard_tab.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/logs_tab.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';

class MobileHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabCubit(),
      child: _MobileHomeView(),
    );
  }
}

class _MobileHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    // Set fixed height for consistent card sizing across languages
    final cardHeight = 200.0; // Fixed consistent height

    // Load all data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feederBloc = context.read<FeederBloc>();
      feederBloc.add(LoadSystemLogsEvent());
      feederBloc.add(LoadCommandLogsEvent());
    });

    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => const ConnectivityDialog(),
          );
        }
      },
      child: Scaffold(
        endDrawer: AppDrawer(),
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: MediaQuery.of(context).size.shortestSide * 0.12,
                  height: MediaQuery.of(context).size.shortestSide * 0.12,
                  color: Colors.transparent,
                  child: Image.asset(
                    "assets/chicken.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacingSmall),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(s.app_title),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<TabCubit, int>(
            builder: (context, selectedIndex) {
              // Use IndexedStack to keep both tabs alive
              return IndexedStack(
                index: selectedIndex,
                children: [
                  DashboardTab(cardHeight: cardHeight),
                  LogsTab(),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}
