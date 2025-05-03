// lib/services/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String webSocketUrl;
  WebSocketChannel? _channel;
  StreamSubscription? _sub;

  WebSocketService({required this.webSocketUrl});

  Future<StreamSubscription> connect({
    required void Function(Map<String, dynamic>) onData,
    required VoidCallback onErrorOrDone,
    Duration handshakeTimeout = const Duration(
        seconds:
            5), // After 5 seconds, the connection will be closed if not established.
  }) async {
    await disconnect();

    try {
      final socket =
          await WebSocket.connect(webSocketUrl).timeout(handshakeTimeout);
      _channel = IOWebSocketChannel(socket);

      _sub = _channel!.stream.listen(
        (message) {
          if (message is String && message.trim().startsWith('{')) {
            try {
              final decoded = jsonDecode(message);
              if (decoded is Map) {
                final safeMap = decoded.map(
                  (k, v) => MapEntry(k.toString(), v),
                );
                onData(safeMap);
              }
            } catch (_) {}
          }
        },
        onError: (_) => onErrorOrDone(),
        onDone: () => onErrorOrDone(),
      );

      return _sub!;
    } on TimeoutException {
      onErrorOrDone();
      rethrow;
    } catch (e) {
      onErrorOrDone();
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _sub?.cancel();
    await _channel?.sink.close();
    _sub = null;
    _channel = null;
  }

  void send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }
}
