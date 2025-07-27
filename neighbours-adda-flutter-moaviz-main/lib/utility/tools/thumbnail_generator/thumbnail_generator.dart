import 'dart:io';

abstract class ThumbnailGenerator {
  //Future<File?> generateThumbnail(File videoFile);
  Future<File> getThumbnail(File videoFile);
}

abstract class VideoThumbnailGenerator {
  Future<File> getThumbnail();
}
