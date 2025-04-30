import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/language_bloc.dart';
import 'package:smart_feeding_app/generated/l10n.dart';
import 'package:smart_feeding_app/widgets/language_dropdown.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.isDarkMode,
    required this.s,
  });

  final bool isDarkMode;
  final S s;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          leading: Icon(
            Icons.language,
            color:
                isDarkMode ? AppTheme.primaryLightBrown : AppTheme.primaryBrown,
          ),
          title: Text(
            s.language,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: LanguageDropdown(
            currentLanguage: currentLanguage,
            isDarkMode: isDarkMode,
            languageCubit: languageCubit,
          ),
        );
      }),
    );
  }
}
