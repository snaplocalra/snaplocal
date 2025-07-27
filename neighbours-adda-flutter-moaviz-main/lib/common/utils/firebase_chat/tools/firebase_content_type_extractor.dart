import 'dart:io';

String firebaseContentTypeFromFile(File file) {
  final String filePath = file.path;
  final String extension = filePath.split('.').last.toLowerCase();

  // Map extension to content type
  final Map<String, String> contentTypeMap = {
    // Images
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
    "gif": "image/gif",
    "bmp": "image/bmp",
    // Videos
    "mp4": "video/mp4",
    "mov": "video/quicktime",
    "avi": "video/x-msvideo",
    "mkv": "video/x-matroska",
    // Audios
    "mp3": "audio/mpeg",
    "wav": "audio/wav",
    "aac": "audio/aac",
    // Documents
    "pdf": "application/pdf",
    "doc": "application/msword",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    // Add more mappings for other formats
  };

  // Look up the content type in the map
  final String contentType = contentTypeMap[extension] ?? 'application/octet-stream';
  return contentType;
}
