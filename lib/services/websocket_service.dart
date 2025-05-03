import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String webSocketUrl;
  late WebSocketChannel _channel;

  WebSocketService({required this.webSocketUrl});

  void connect(void Function(Map<String, dynamic>) onData) {
    _channel = WebSocketChannel.connect(Uri.parse(webSocketUrl));

    _channel.stream.listen((message) {
      print('Gelen WebSocket mesajı: $message');

      if (message.trim().startsWith('{') && message.trim().endsWith('}')) {
        try {
          final decoded = jsonDecode(message);
          if (decoded is Map) {
            final safeMap =
                decoded.map((key, value) => MapEntry(key.toString(), value));
            onData(safeMap);
          }
        } catch (e) {
          print('Invalid Json message catched: $message');
        }
      } else {
        print('Metinsel mesaj atlandı: $message');
      }
    });
  }

  void disconnect() {
    _channel.sink.close();
  }

  void send(Map<String, dynamic> data) {
    _channel.sink.add(jsonEncode(data));
  }
}
