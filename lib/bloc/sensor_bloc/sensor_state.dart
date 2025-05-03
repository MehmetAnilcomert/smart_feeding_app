import 'package:equatable/equatable.dart';

class SensorState extends Equatable {
  final double? temperature;
  final double? humidity;
  final bool connected;

  const SensorState({
    this.temperature,
    this.humidity,
    this.connected = false,
  });

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

  @override
  List<Object?> get props => [temperature, humidity, connected];
}
