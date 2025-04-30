import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/drawer/build_drawer.dart';
import 'package:smart_feeding_app/widgets/drawer/darkmode_toggle.dart';
import 'package:smart_feeding_app/widgets/drawer/help_row.dart';
import 'package:smart_feeding_app/widgets/drawer/language_selector.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final topHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    final GlobalKey _helpIconKey = GlobalKey();

    // Header gradient colors
    final Color headerStartColor =
        isDarkMode ? AppTheme.primaryDarkBrown : AppTheme.primaryBrown;
    final Color headerEndColor =
        isDarkMode ? AppTheme.primaryBrown : AppTheme.primaryLightBrown;

    return Drawer(
      backgroundColor: headerEndColor,
      child: Column(
        children: [
          Container(
            height: topHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [headerStartColor, headerEndColor],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.backgroundDark
                    : AppTheme.backgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  // Dark mode toggle
                  DarkModeToggle(isDarkMode: isDarkMode, s: s),

                  // Language selector
                  LanguageSelector(isDarkMode: isDarkMode, s: s),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),

                  // Help item with info note
                  HelpRow(
                      isDarkMode: isDarkMode, s: s, helpIconKey: _helpIconKey),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),

                  // Logout item
                  buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: s.logout,
                    isDestructive: true,
                    onTap: () => SystemNavigator.pop(),
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
