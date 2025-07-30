import 'dart:io';

class CachedMediaModel {
  final String id;
  final String url;
  final String localPath;
  final String? thumbnailPath;
  final DateTime cachedAt;
  final int fileSize;
  final String mediaType; // 'video', 'image'
  final DateTime? lastAccessed;

  CachedMediaModel({
    required this.id,
    required this.url,
    required this.localPath,
    this.thumbnailPath,
    required this.cachedAt,
    required this.fileSize,
    required this.mediaType,
    this.lastAccessed,
  });

  bool get exists {
    try {
      return File(localPath).existsSync();
    } catch (e) {
      return false;
    }
  }

  bool get isExpired {
    const maxAge = Duration(days: 7); // Cache for 7 days
    return DateTime.now().difference(cachedAt) > maxAge;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'localPath': localPath,
      'thumbnailPath': thumbnailPath,
      'cachedAt': cachedAt.millisecondsSinceEpoch,
      'fileSize': fileSize,
      'mediaType': mediaType,
      'lastAccessed': lastAccessed?.millisecondsSinceEpoch,
    };
  }

  factory CachedMediaModel.fromJson(Map<String, dynamic> json) {
    return CachedMediaModel(
      id: json['id'],
      url: json['url'],
      localPath: json['localPath'],
      thumbnailPath: json['thumbnailPath'],
      cachedAt: DateTime.fromMillisecondsSinceEpoch(json['cachedAt']),
      fileSize: json['fileSize'],
      mediaType: json['mediaType'],
      lastAccessed: json['lastAccessed'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['lastAccessed'])
          : null,
    );
  }

  CachedMediaModel copyWith({
    String? id,
    String? url,
    String? localPath,
    String? thumbnailPath,
    DateTime? cachedAt,
    int? fileSize,
    String? mediaType,
    DateTime? lastAccessed,
  }) {
    return CachedMediaModel(
      id: id ?? this.id,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      cachedAt: cachedAt ?? this.cachedAt,
      fileSize: fileSize ?? this.fileSize,
      mediaType: mediaType ?? this.mediaType,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}
