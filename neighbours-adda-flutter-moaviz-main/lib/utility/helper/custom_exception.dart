class LocationPermissionDeniedForeverException implements Exception {
  final String message;

  LocationPermissionDeniedForeverException(this.message);
}

class NoInternetException implements Exception {
  NoInternetException();
}
