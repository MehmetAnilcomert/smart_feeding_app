import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/modals/language.dart';
import 'dart:ui';

enum AppLanguage { en, tr }

class LanguageCubit extends Cubit<AppLanguage> {
  final LanguageManager languageManager;

  LanguageCubit(this.languageManager) : super(AppLanguage.tr);

  Future<void> loadSavedLanguage() async {
    await languageManager.loadLanguagePreference();
    final languageCode = languageManager.locale.languageCode;

    if (languageCode == 'en') {
      emit(AppLanguage.en);
    } else {
      emit(AppLanguage.tr);
    }
  }

  Future<void> changeLanguage(AppLanguage language) async {
    if (language == AppLanguage.tr) {
      await languageManager.setLanguage(Locale('tr'));
      emit(AppLanguage.tr);
    } else {
      await languageManager.setLanguage(Locale('en'));
      emit(AppLanguage.en);
    }
  }
}
