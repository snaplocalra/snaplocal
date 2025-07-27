import 'dart:io';

abstract class MediaFileModel {
  File get file;
}

abstract class MediaDataMapper {
  Future<Map<String, dynamic>> toMap();
}

//Image media
class ImageFileMediaModel implements MediaFileModel {
  final File imageFile;
  ImageFileMediaModel({
    required this.imageFile,
  });

  @override
  File get file => imageFile;
}

//Video media
class VideoFileMediaModel implements MediaFileModel {
  final File videoFile;
  final File thumbnailFile;
  VideoFileMediaModel({
    required this.videoFile,
    required this.thumbnailFile,
  });

  @override
  File get file => videoFile;
}

//Other types
class GeneralFileMediaModel implements MediaFileModel {
  final File generalFile;
  GeneralFileMediaModel({required this.generalFile});

  @override
  File get file => generalFile;
}
