import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/language_bloc.dart';
import 'package:smart_feeding_app/bloc/theme_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/language_dropdown.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final topHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    // Header gradient colors (fully opaque)
    final Color headerStartColor =
        isDarkMode ? AppTheme.primaryDarkBrown : AppTheme.primaryBrown;
    final Color headerEndColor = isDarkMode
        ? AppTheme.primaryBrown // make fully opaque
        : AppTheme.primaryLightBrown;

    return Drawer(
      backgroundColor: headerEndColor, // extend brown behind rounded body
      child: Column(
        children: [
          // Brown gradient header (AppBar height)
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

          // Drawer body
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
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDarkMode
                          ? AppTheme.cardDark.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: SwitchListTile(
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<ThemeBloc>().toggleTheme();
                      },
                      title: Text(
                        isDarkMode ? s.light_mode : s.dark_mode,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      secondary: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppTheme.primaryLightBrown.withOpacity(0.2)
                              : AppTheme.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: isDarkMode
                              ? AppTheme.primaryLightBrown
                              : AppTheme.primaryBrown,
                        ),
                      ),
                    ),
                  ),

                  // Language selector
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDarkMode
                          ? AppTheme.cardDark.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: Builder(builder: (context) {
                      final languageCubit = context.watch<LanguageCubit>();
                      final currentLanguage = languageCubit.state;

                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppTheme.primaryLightBrown.withOpacity(0.2)
                                : AppTheme.primaryBrown.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.language,
                            color: isDarkMode
                                ? AppTheme.primaryLightBrown
                                : AppTheme.primaryBrown,
                          ),
                        ),
                        title: Text(
                          s.language,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppTheme.primaryLightBrown.withOpacity(0.2)
                                : AppTheme.primaryBrown.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppTheme.borderRadius),
                          ),
                          child: LanguageDropdown(
                            currentLanguage: currentLanguage,
                            isDarkMode: isDarkMode,
                            languageCubit: languageCubit,
                          ),
                        ),
                      );
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),

                  // Help item with info popup
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDarkMode
                          ? AppTheme.cardDark.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: ListTile(
                      onTap: () => _showInfoDialog(context, s),
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppTheme.primaryLightBrown.withOpacity(0.2)
                              : AppTheme.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: isDarkMode
                              ? AppTheme.primaryLightBrown
                              : AppTheme.primaryBrown,
                        ),
                      ),
                      title: Text(
                        s.help,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 12,
                        backgroundColor: isDarkMode
                            ? AppTheme.primaryLightBrown
                            : AppTheme.primaryBrown,
                        child: Text(
                          '!',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),

                  // Logout item
                  _buildMenuItem(
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

  void _showInfoDialog(BuildContext context, S s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.help),
        content: Text(s.help_note),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    required bool isDarkMode,
  }) {
    final Color primaryColor =
        isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? AppTheme.cardDark.withOpacity(0.5)
            : Colors.grey.withOpacity(0.1),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.1)
                : primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive
                ? Colors.red
                : isDarkMode
                    ? Colors.white
                    : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive
              ? Colors.red
              : isDarkMode
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
