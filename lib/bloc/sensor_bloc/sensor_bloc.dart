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
          final temp = data['temperature'];
          final hum = data['humidity'];
          final connected = data['connected'] as bool? ?? false;

          double? t = temp != null ? (temp as num).toDouble() : null;
          double? h = hum != null ? (hum as num).toDouble() : null;

          print(" ${connected} Temperature: $t, Humidity: $h");
          add(SensorDataReceived(
            temperature: t,
            humidity: h,
            connected: connected,
          ));
        },
        onErrorOrDone: () => add(ConnectWebSocket()),
        handshakeTimeout: const Duration(seconds: 5),
      );
    } catch (_) {}
  }

  void _onDataReceived(SensorDataReceived event, Emitter<SensorState> emit) {
    emit(state.copyWith(
      temperature: event.temperature,
      humidity: event.humidity,
      connected: event.connected,
    ));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _ws.disconnect();
    return super.close();
  }
}
