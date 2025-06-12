import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/tab_cubit.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/command_log_view.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/system_log_view.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/humidity_card.dart';
import 'package:smart_feeding_app/widgets/sensor_widgets/temperature_card.dart';

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
          elevation: 0,
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
          child: Column(
            children: [
              // Custom Tab Bar - Separated from AppBar
              _CustomTabBar(),
              // Tab Content
              Expanded(
                child: BlocBuilder<TabCubit, int>(
                  builder: (context, selectedIndex) {
                    // Use IndexedStack to keep both tabs alive
                    return IndexedStack(
                      index: selectedIndex,
                      children: [
                        _DashboardTab(cardHeight: cardHeight),
                        _LogsTab(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing,
          vertical: AppTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: BlocBuilder<TabCubit, int>(
          builder: (context, selectedIndex) {
            return Row(
              children: [
                Expanded(
                  child: _TabItem(
                    title: s.dashboard_tab,
                    icon: Icons.dashboard,
                    isSelected: selectedIndex == 0,
                    onTap: () => context.read<TabCubit>().changeTab(0),
                    isFirst: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.dividerColor.withOpacity(0.2),
                ),
                Expanded(
                  child: _TabItem(
                    title: s.logs_tab,
                    icon: Icons.history,
                    isSelected: selectedIndex == 1,
                    onTap: () => context.read<TabCubit>().changeTab(1),
                    isFirst: false,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;

  const _TabItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? theme.colorScheme.primary.withOpacity(isDarkMode ? 0.3 : 0.15)
        : Colors.transparent;

    final foregroundColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(0.7);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: isFirst
              ? Radius.circular(AppTheme.borderRadius - 1)
              : Radius.zero,
          bottomLeft: isFirst
              ? Radius.circular(AppTheme.borderRadius - 1)
              : Radius.zero,
          topRight: !isFirst
              ? Radius.circular(AppTheme.borderRadius - 1)
              : Radius.zero,
          bottomRight: !isFirst
              ? Radius.circular(AppTheme.borderRadius - 1)
              : Radius.zero,
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: isFirst
                  ? Radius.circular(AppTheme.borderRadius - 1)
                  : Radius.zero,
              bottomLeft: isFirst
                  ? Radius.circular(AppTheme.borderRadius - 1)
                  : Radius.zero,
              topRight: !isFirst
                  ? Radius.circular(AppTheme.borderRadius - 1)
                  : Radius.zero,
              bottomRight: !isFirst
                  ? Radius.circular(AppTheme.borderRadius - 1)
                  : Radius.zero,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing,
            vertical: AppTheme.spacingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: foregroundColor,
                size: 20,
              ),
              SizedBox(width: AppTheme.spacingSmall),
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final double cardHeight;

  const _DashboardTab({Key? key, required this.cardHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(AppTheme.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fixed height container with AspectRatio to maintain proportions
          SizedBox(
            height: cardHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TemperatureCard(),
                ),
                SizedBox(width: AppTheme.spacing),
                Expanded(
                  child: HumidityCard(),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.spacingLarge),
          FeedSettingsWidget(),
        ],
      ),
    );
  }
}

class _LogsTab extends StatelessWidget {
  const _LogsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(AppTheme.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommandLogView(),
          SizedBox(height: AppTheme.spacingLarge),
          SystemLogView(),
        ],
      ),
    );
  }
}
