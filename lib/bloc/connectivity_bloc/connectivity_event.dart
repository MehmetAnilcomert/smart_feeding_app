import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityEvent {}

class ConnectivityObserve extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> results;
  ConnectivityChanged(this.results);
}

class ConnectivityErrorOccurred extends ConnectivityEvent {
  final String message;
  ConnectivityErrorOccurred(this.message);
}
