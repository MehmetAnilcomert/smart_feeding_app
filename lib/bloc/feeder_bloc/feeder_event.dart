abstract class FeederEvent {}

class FeederConnectEvent extends FeederEvent {}

class FeederDisconnectEvent extends FeederEvent {}

class FeederDataReceivedEvent extends FeederEvent {
  final String data;
  FeederDataReceivedEvent(this.data);
}

class FeedingFrequencyChangedEvent extends FeederEvent {
  final int frequency;
  FeedingFrequencyChangedEvent(this.frequency);
}
