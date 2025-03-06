import 'dart:io';

class WebSocketService {
  final Function(dynamic) onData;
  final Function onError;
  WebSocket? _socket;
  final String url =
      'ws://example.com'; // Replace with your ESP32 WebSocket URL

  WebSocketService({required this.onData, required this.onError});

  Future<void> connect() async {
    try {
      _socket = await WebSocket.connect(url);
      _socket!.listen(
        onData,
        onError: (_) => onError(),
        onDone: () => onError(),
      );
    } catch (e) {
      onError();
    }
  }

  void send(String data) {
    _socket?.add(data);
  }

  void disconnect() {
    _socket?.close();
  }
}
