import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_feeding_app/modals/general_response.dart';
import 'package:smart_feeding_app/modals/status_response.dart';

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
    final uri = Uri.parse('$baseUrl/set-interval').replace(queryParameters: {
      'hourValue': hourValue.toString(),
      'minuteValue': minuteValue.toString(),
      'startHour': _formatTimeOfDay(startHour),
      'endHour': _formatTimeOfDay(endHour),
      'amount': amount.toInt().toString(),
    });
    final res = await _http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('setInterval failed: ${res.statusCode}');
    }
    return ApiResponse.fromJson(json.decode(res.body));
  }

  /// 2) /feed?amount=
  Future<ApiResponse> triggerManualFeed({required double amount}) async {
    final uri = Uri.parse('$baseUrl/feed').replace(queryParameters: {
      'amount': amount.toString(),
    });
    final res = await _http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('triggerManualFeed failed: ${res.statusCode}');
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

  void dispose() {
    _http.close();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
