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

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDarkMode ? AppTheme.primaryDarkBrown : AppTheme.primaryBrown,
              isDarkMode
                  ? AppTheme.primaryBrown.withOpacity(0.7)
                  : AppTheme.primaryLightBrown,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20, bottom: 20),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(Icons.person,
                        size: 50,
                        color: isDarkMode
                            ? AppTheme.primaryLightBrown
                            : AppTheme.primaryBrown),
                  ),
                  SizedBox(height: 12),
                  Text(
                    s.user,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    s.user_email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
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
                                languageCubit: languageCubit),
                          ),
                        );
                      }),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.3)),
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: s.settings,
                      onTap: () {
                        // Navigate to settings
                      },
                      isDarkMode: isDarkMode,
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      title: s.help,
                      onTap: () {
                        // Navigate to help
                      },
                      isDarkMode: isDarkMode,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.3)),
                    ),

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
