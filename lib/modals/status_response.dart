/// /status endpoint cevabı
class StatusResponse {
  final bool esp32Connected;
  final DateTime serverTime;
  final double? temperature;
  final double? humidity;

  StatusResponse({
    required this.esp32Connected,
    required this.serverTime,
    this.temperature,
    this.humidity,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      esp32Connected: json['esp32Connected'] as bool,
      serverTime: DateTime.parse(json['serverTime'] as String),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
    );
  }
}
