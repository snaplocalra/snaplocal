abstract class NetworkMediaModel {
  //media url
  String get mediaUrl;
  String get thumbnail;
  String get views;

  //FromMap
  factory NetworkMediaModel.fromMap(Map<String, dynamic> json) {
    switch (json["media_type"]) {
      case "image":
        return NetworkImageMediaModel.fromMap(json);
      case "video":
        return NetworkVideoMediaModel.fromMap(json);
      default:
        throw Exception("Unknown media type: ${json["media_type"]}");
    }
  }

  //tomap
  Map<String, dynamic> toMap();
}

//Image media
class NetworkImageMediaModel implements NetworkMediaModel {
  final String imageUrl;
  NetworkImageMediaModel({required this.imageUrl});

  //media url
  @override
  String get mediaUrl => imageUrl;
  @override
  String get thumbnail => imageUrl;
  @override
  String get views => "";

  //ToMap
  @override
  Map<String, dynamic> toMap() {
    return {
      "media_path": imageUrl.split('/').last,
      "media_type": "image",
    };
  }

  //fromMap
  @override
  factory NetworkImageMediaModel.fromMap(Map<String, dynamic> json) {
    return NetworkImageMediaModel(imageUrl: json["media_path"]);
  }
}

//Video media
class NetworkVideoMediaModel implements NetworkMediaModel {
  final String videoUrl;
  final String thumbnailUrl;
  final String viewCount;
  NetworkVideoMediaModel({
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.viewCount,
  });

  //media url
  @override
  String get mediaUrl => videoUrl;
  @override
  String get thumbnail => thumbnailUrl;
  @override
  String get views => viewCount;

  //ToMap
  @override
  Map<String, dynamic> toMap({bool splitMediaUrl = false}) {
    return {
      //Split the last name from the url
      "media_path": videoUrl.split('/').last,
      "thumbnail": thumbnailUrl.split('/').last,
      "view_count": viewCount,
      "media_type": "video",
    };
  }

  //fromMap
  @override
  factory NetworkVideoMediaModel.fromMap(Map<String, dynamic> json) {
    return NetworkVideoMediaModel(
      videoUrl: json["media_path"],
      thumbnailUrl: json["thumbnail"]??"",
      viewCount: json["view_count"]??"",
    );
  }
}
