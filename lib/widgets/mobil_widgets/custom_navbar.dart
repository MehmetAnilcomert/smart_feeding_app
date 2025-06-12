import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/tab_cubit.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/mobil_widgets/nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<TabCubit, int>(
      builder: (context, selectedIndex) {
        return Container(
          decoration: BoxDecoration(
            color: theme.bottomNavigationBarTheme.backgroundColor ??
                theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Container(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: NavItem(
                      icon: Icons.dashboard,
                      selectedIcon: Icons.dashboard,
                      label: s.dashboard_tab,
                      isSelected: selectedIndex == 0,
                      onTap: () => context.read<TabCubit>().changeTab(0),
                    ),
                  ),
                  // Vertical Divider
                  Container(
                    width: 1,
                    height: 32,
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                  Expanded(
                    child: NavItem(
                      icon: Icons.history_outlined,
                      selectedIcon: Icons.history,
                      label: s.logs_tab,
                      isSelected: selectedIndex == 1,
                      onTap: () => context.read<TabCubit>().changeTab(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
