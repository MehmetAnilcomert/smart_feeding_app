import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme Events
abstract class ThemeEvent {}

class ThemeToggled extends ThemeEvent {}

class ThemeInitialized extends ThemeEvent {
  final bool isDarkMode;
  ThemeInitialized(this.isDarkMode);
}

// Theme State
class ThemeState {
  final bool isDarkMode;
  ThemeState(this.isDarkMode);
}

// Theme Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(false)) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeInitialized>(_onThemeInitialized);
    _loadTheme();
  }

  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) async {
    final newState = ThemeState(!state.isDarkMode);
    emit(newState);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newState.isDarkMode);
  }

  void _onThemeInitialized(ThemeInitialized event, Emitter<ThemeState> emit) {
    emit(ThemeState(event.isDarkMode));
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    add(ThemeInitialized(isDarkMode));
  }

  void toggleTheme() {
    add(ThemeToggled());
  }
}
