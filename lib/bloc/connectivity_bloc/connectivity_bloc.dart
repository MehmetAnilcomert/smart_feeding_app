import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_event.dart';
import 'package:smart_feeding_app/bloc/connectivity_bloc/connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityObserve>(_observeConnection);
    on<ConnectivityChanged>(_handleConnectionChange);
    on<ConnectivityErrorOccurred>(_handleError); // Hata event handler
  }

  Future<void> _observeConnection(
    ConnectivityEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      final results = await _connectivity.checkConnectivity();
      add(ConnectivityChanged(results));

      _subscription = _connectivity.onConnectivityChanged.listen(
        (newResults) => add(ConnectivityChanged(newResults)),
        onError: (error) => add(ConnectivityErrorOccurred(// Stream hataları
            'Connection monitoring failed: ${error.toString()}')),
      );
    } catch (e) {
      emit(ConnectivityErrorState(
          'Initial connection check failed: ${e.toString()}'));
    }
  }

  void _handleConnectionChange(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    try {
      final results = event.results;

      if (results.contains(ConnectivityResult.none)) {
        emit(ConnectivityDisconnected());
      } else {
        final connectionType = _determineConnectionType(results);
        emit(ConnectivityConnected(connectionType));
      }
    } catch (e) {
      emit(ConnectivityErrorState('Connection update error: ${e.toString()}'));
    }
  }

  void _handleError(
    ConnectivityErrorOccurred event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(ConnectivityErrorState(event.message));
  }

  String _determineConnectionType(List<ConnectivityResult> results) {
    const priorityOrder = [
      ConnectivityResult.ethernet,
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
    ];

    for (final type in priorityOrder) {
      if (results.contains(type)) {
        return type.toString().split('.').last;
      }
    }
    return 'Other';
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
