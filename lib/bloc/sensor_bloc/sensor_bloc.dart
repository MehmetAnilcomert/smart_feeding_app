import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_event.dart';
import 'package:smart_feeding_app/bloc/sensor_bloc/sensor_state.dart';
import 'package:smart_feeding_app/services/websocket_service.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final WebSocketService webSocketService;

  SensorBloc(this.webSocketService) : super(SensorState()) {
    on<ConnectWebSocket>((event, emit) {
      webSocketService.connect((data) {
        if (data['type'] == 'sensor_data') {
          final temp = (data['temperature'] as num).toDouble();
          final hum = (data['humidity'] as num).toDouble();

          print('Sensor verisi alındı: $temp');
          add(SensorDataReceived(
            temperature: temp,
            humidity: hum,
          ));
        }
      });
      emit(state.copyWith(connected: true));
    });

    on<SensorDataReceived>((event, emit) {
      emit(state.copyWith(
        temperature: event.temperature,
        humidity: event.humidity,
      ));
    });
  }

  @override
  Future<void> close() {
    webSocketService.disconnect();
    return super.close();
  }
}
