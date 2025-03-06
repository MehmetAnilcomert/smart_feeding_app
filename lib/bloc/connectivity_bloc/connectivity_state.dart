abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {
  final String connectionType;
  ConnectivityConnected(this.connectionType);
}

class ConnectivityDisconnected extends ConnectivityState {}

class ConnectivityErrorState extends ConnectivityState {
  final String errorMessage;
  ConnectivityErrorState(this.errorMessage);
}
