abstract class SensorEvent {}

class ConnectWebSocket extends SensorEvent {}

class SensorDataReceived extends SensorEvent {
  final double temperature;
  final double humidity;

  SensorDataReceived({required this.temperature, required this.humidity});
}
