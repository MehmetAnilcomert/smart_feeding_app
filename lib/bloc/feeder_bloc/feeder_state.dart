abstract class FeederState {}

class FeederInitial extends FeederState {}

class FeederConnected extends FeederState {}

class FeederDisconnected extends FeederState {}

class FeederDataState extends FeederState {
  final List<String> logs;
  final double temperature;
  final int feedingFrequency;
  FeederDataState({
    required this.logs,
    required this.temperature,
    required this.feedingFrequency,
  });
}
