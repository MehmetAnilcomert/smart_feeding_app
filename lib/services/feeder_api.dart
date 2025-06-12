import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_feeding_app/modals/apiException.dart';
import 'package:smart_feeding_app/modals/general_response.dart';
import 'package:smart_feeding_app/modals/status_response.dart';

import 'package:smart_feeding_app/modals/command_log.dart';
import 'package:smart_feeding_app/modals/system_log.dart';

class FeederApiService {
  final String baseUrl;
  final http.Client _http;

  FeederApiService({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  /// 1) /set-interval?hourValue=&minuteValue=&startHour=&endHour=&amount=
  Future<ApiResponse> setInterval({
    required int hourValue,
    required int minuteValue,
    required TimeOfDay startHour,
    required TimeOfDay endHour,
    required double amount,
  }) async {
    final uri = Uri.parse('$baseUrl/set-interval');
    final body = {
      'hourValue': hourValue.toString(),
      'minuteValue': minuteValue.toString(),
      'startHour': _formatTimeOfDay(startHour),
      'endHour': _formatTimeOfDay(endHour),
      'amount': amount.toInt().toString(),
    };

    print('Setting interval with params: $hourValue, $minuteValue, '
        '${_formatTimeOfDay(startHour)}, ${_formatTimeOfDay(endHour)}, $amount');
    print('API URL: $uri');
    print('Request Body: $body');

    final res = await _http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    print('API Response: ${res.body}');

    if (res.statusCode != 200) {
      throw ApiException(res.statusCode);
    }

    return ApiResponse.fromJson(json.decode(res.body));
  }

  /// 2) /feed?amount=
  Future<ApiResponse> triggerManualFeed({required double amount}) async {
    final uri = Uri.parse('$baseUrl/feed').replace(queryParameters: {
      'value': amount.toString(),
    });
    final res = await _http.get(uri);
    print('Sending manual feed request with amount: ${res.body}');
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode);
    }
    return ApiResponse.fromJson(json.decode(res.body));
  }

  /// 3) /status
  Future<StatusResponse> getStatus() async {
    final uri = Uri.parse('${baseUrl}/status');

    final res = await _http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('getStatus failed: ${res.statusCode}');
    }
    return StatusResponse.fromJson(json.decode(res.body));
  }

  /// 4) /send-token
  Future<void> sendTokenToBackend(String token) async {
    final uri = Uri.parse('$baseUrl/send-token');
    final res = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token}),
    );

    if (res.statusCode != 200) {
      throw ApiException(res.statusCode);
    }
  }

  void dispose() {
    _http.close();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Fetch command logs from /commands endpoint
  Future<List<CommandLog>> getCommands() async {
    final uri = Uri.parse('$baseUrl/commands');
    final res = await _http.get(uri);

    if (res.statusCode != 200) {
      throw ApiException(res.statusCode);
    }

    final List<dynamic> jsonList = json.decode(res.body);
    return jsonList.map((json) => CommandLog.fromJson(json)).toList();
  }

  /// Fetch system logs from /logs endpoint
  Future<List<SystemLog>> getLogs() async {
    final uri = Uri.parse('$baseUrl/logs');
    final res = await _http.get(uri);

    if (res.statusCode != 200) {
      throw ApiException(res.statusCode);
    }

    final List<dynamic> jsonList = json.decode(res.body);
    return jsonList.map((json) => SystemLog.fromJson(json)).toList();
  }
}
