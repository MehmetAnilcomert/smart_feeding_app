import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_view.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/temperature.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';

class MobileHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

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
              Text(s.app_title),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TemperatureWidget(),
                SizedBox(height: AppTheme.spacingLarge),
                FeedSettingsWidget(),
                SizedBox(height: AppTheme.spacingLarge),
                LogViewWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
