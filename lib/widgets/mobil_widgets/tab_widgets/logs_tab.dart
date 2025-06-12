import 'package:flutter/material.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/command_log_view.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/log_widgets/system_log_view.dart';

class LogsTab extends StatelessWidget {
  const LogsTab({Key? key}) : super(key: key);

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
