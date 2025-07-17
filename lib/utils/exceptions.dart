class NotFoundException implements Exception {
  NotFoundException({this.message = "Not found."});
  final String message;
}
class NoNetworkException implements Exception {}