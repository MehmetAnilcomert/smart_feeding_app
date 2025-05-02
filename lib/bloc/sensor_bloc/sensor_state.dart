class SensorState {
  final double? temperature;
  final double? humidity;
  final bool connected;

  SensorState({this.temperature, this.humidity, this.connected = false});

  SensorState copyWith({
    double? temperature,
    double? humidity,
    bool? connected,
  }) {
    return SensorState(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      connected: connected ?? this.connected,
    );
  }
}
