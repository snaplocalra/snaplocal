import 'dart:io';

abstract class VideoCompressor {
  //Future<File?> compressVideo(File rawVideo);
  Future<File?> getCompressVideo(File rawVideo);
}
