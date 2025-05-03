// sensor_event.dart
abstract class SensorEvent {}

class ConnectWebSocket extends SensorEvent {}

class SensorDataReceived extends SensorEvent {
  final double temperature, humidity;
  SensorDataReceived({required this.temperature, required this.humidity});
}

class ConnectionLost extends SensorEvent {}

class ConnectionRestored extends SensorEvent {}
