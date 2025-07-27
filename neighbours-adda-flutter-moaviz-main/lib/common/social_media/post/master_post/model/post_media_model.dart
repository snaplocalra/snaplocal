import 'package:equatable/equatable.dart';

class PostMediaModel extends Equatable {
  final String mediaPath;
  final String mediaType;
  final int height;
  final int width;
  final String? thumbnail;

  const PostMediaModel({
    required this.mediaPath,
    required this.mediaType,
    required this.height,
    required this.width,
    this.thumbnail,
  });

  factory PostMediaModel.fromMap(Map<String, dynamic> map) {
    return PostMediaModel(
      mediaPath: map['media_path'] ?? '',
      mediaType: map['media_type'] ?? '',
      height: map['height'] ?? 0,
      width: map['width'] ?? 0,
      thumbnail: map['thumbnail'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'media_path': mediaPath,
      'media_type': mediaType,
      'height': height,
      'width': width,
      'thumbnail': thumbnail
    };
  }

  @override
  List<Object?> get props => [mediaPath, mediaType, height, width];
} 