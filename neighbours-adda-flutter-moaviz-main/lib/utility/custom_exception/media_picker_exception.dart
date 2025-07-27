///Exception when user cancel media picker
class MediaPickerException implements Exception {
  final String message;
  MediaPickerException(this.message);
}