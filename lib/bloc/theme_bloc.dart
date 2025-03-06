import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

class ThemeBloc extends Cubit<ThemeData> {
  ThemeBloc() : super(ThemeData.light());

  void toggleTheme() {
    emit(state.brightness == Brightness.light
        ? ThemeData.dark()
        : ThemeData.light());
  }
}
