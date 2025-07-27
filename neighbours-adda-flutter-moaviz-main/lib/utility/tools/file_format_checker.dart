import 'package:path/path.dart' as path;

class FileExtensionChecker {
  static FileExtension extractExtension(String filePath) {
    final fileExtension = path.extension(filePath);

    switch (fileExtension.toLowerCase()) {
      case ".pdf":
        return FileExtension.pdf;
      case ".jpg":
      case ".jpeg":
      case ".png":
      case ".gif":
      case ".bmp":
        return FileExtension.image;
      case ".mp4":
      case ".mov":
      case ".avi":
      case ".mkv":
        return FileExtension.video;
      case ".mp3":
      case ".wav":
      case ".aac":
      case ".m4a":
        return FileExtension.audio;
      default:
        return FileExtension.none;
    }
  }
}

enum FileExtension {
  video,
  audio,
  image,
  pdf,
  none;
}
