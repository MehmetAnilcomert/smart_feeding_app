// lib/bloc/sensor_bloc/sensor_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sensor_event.dart';
import 'sensor_state.dart';
import '../../services/websocket_service.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final WebSocketService _ws;
  StreamSubscription<dynamic>? _sub;

  SensorBloc(this._ws) : super(const SensorState()) {
    on<ConnectWebSocket>(_onConnect);
    on<SensorDataReceived>(_onDataReceived);
    on<ConnectionLost>(_onConnectionLost);

    add(ConnectWebSocket());
  }

  Future<void> _onConnect(ConnectWebSocket _, Emitter<SensorState> emit) async {
    await _sub?.cancel();
    await _ws.disconnect();

    emit(
        const SensorState(temperature: null, humidity: null, connected: false));

    try {
      _sub = await _ws.connect(
        onData: (data) {
          final t = (data['temperature'] as num).toDouble();
          final h = (data['humidity'] as num).toDouble();
          add(SensorDataReceived(temperature: t, humidity: h));
        },
        onErrorOrDone: () => add(ConnectionLost()),
        handshakeTimeout: const Duration(seconds: 5),
      );
    } catch (_) {}
  }

  void _onDataReceived(SensorDataReceived event, Emitter<SensorState> emit) {
    emit(state.copyWith(
      temperature: event.temperature,
      humidity: event.humidity,
      connected: true,
    ));
  }

  void _onConnectionLost(ConnectionLost _, Emitter<SensorState> emit) {
    emit(
        const SensorState(temperature: null, humidity: null, connected: false));
    Future.delayed(const Duration(seconds: 1), () {
      add(ConnectWebSocket());
    });
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _ws.disconnect();
    return super.close();
  }
}
