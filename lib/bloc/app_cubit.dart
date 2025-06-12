// lib/bloc/app_cubit/app_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';

class AppCubit extends Cubit<AppState> {
  late final FeederBloc feederBloc;
  final String httpUrl;

  AppCubit({required this.httpUrl}) : super(AppInitial()) {
    feederBloc = FeederBloc(httpUrl: httpUrl);
    _initialize();
  }

  void _initialize() async {
    emit(AppLoading());

    // With a delay to simulate loading
    await Future.delayed(Duration(milliseconds: 100));

    // Load settings and initial data
    feederBloc.add(LoadSettingsEvent());

    emit(AppReady());
  }

  @override
  Future<void> close() {
    feederBloc.close();
    return super.close();
  }
}

// States
abstract class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppReady extends AppState {}
