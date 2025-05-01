import 'dart:convert';
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
    required int startHour,
    required int endHour,
    required double amount,
  }) async {
    final uri = Uri.parse('$baseUrl/set-interval').replace(queryParameters: {
      'hourValue': hourValue.toString(),
      'minuteValue': minuteValue.toString(),
      'startHour': startHour.toString(),
      'endHour': endHour.toString(),
      'amount': amount.toString(),
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
    print('triggerManualFeed uri: $uri');
    print('triggerManualFeed amount: $amount');
    final res = await _http.get(uri);
    print('triggerManualFeed response: ${res.body}');
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
}
