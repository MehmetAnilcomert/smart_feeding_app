// sensor_event.dart
abstract class SensorEvent {}

class ConnectWebSocket extends SensorEvent {}

class SensorDataReceived extends SensorEvent {
  final double? temperature;
  final double? humidity;
  final bool connected;
  SensorDataReceived({
    this.temperature,
    this.humidity,
    required this.connected,
  });
}
