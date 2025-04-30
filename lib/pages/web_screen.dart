import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';
import 'package:smart_feeding_app/bloc/log_expand.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/feed_setting.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/temperature.dart';
import 'package:smart_feeding_app/widgets/connectivity_dialog.dart';
import 'package:smart_feeding_app/widgets/drawer/drawer.dart';
import 'package:smart_feeding_app/widgets/web_widgets/collapsible_log_header_delegate.dart';
import 'package:smart_feeding_app/widgets/web_widgets/log_content_widget.dart';

class WebHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final padding = MediaQuery.of(context).size.width * 0.02;
    final iconSize = MediaQuery.of(context).size.shortestSide * 0.08;

    return MultiBlocProvider(
      providers: [
        BlocProvider<LogExpandCubit>(create: (_) => LogExpandCubit()),
      ],
      child: BlocListener<ConnectivityBloc, ConnectivityState>(
        listener: (context, state) {
          if (state is ConnectivityDisconnected) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const ConnectivityDialog(),
            );
          }
        },
        child: Scaffold(
          endDrawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: isDarkMode ? Color(0xFF795548) : null,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/chicken.png",
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: AppTheme.spacingSmall),
                Text(s.app_title),
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
              color: isDarkMode ? Color(0xFF303030) : null,
              padding: EdgeInsets.all(padding),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availHeight = constraints.maxHeight;
                  final isWide = constraints.maxWidth > 600;
                  return CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // 1. satır: sıcaklık + besleme ayarları
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: availHeight,
                          child: Row(
                            children: [
                              Expanded(child: TemperatureWidget()),
                              SizedBox(width: AppTheme.spacingMedium),
                              Expanded(
                                  flex: isWide ? 1 : 2,
                                  child: FeedSettingsWidget()),
                            ],
                          ),
                        ),
                      ),

                      // başlık + içeriği Cubit’ten okuyarak göster
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: CollapsibleLogHeaderDelegate(
                          isExpanded: context.watch<LogExpandCubit>().state,
                          onToggle: () =>
                              context.read<LogExpandCubit>().toggle(),
                        ),
                      ),
                      if (context.watch<LogExpandCubit>().state)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              height: 400,
                              child: LogContentWidget(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
