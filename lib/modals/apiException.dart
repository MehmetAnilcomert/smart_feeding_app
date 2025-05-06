class ApiException implements Exception {
  final int statusCode;
  ApiException(this.statusCode);
  @override
  String toString() => 'ApiException: $statusCode';
}
