import 'dart:convert';

import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class MediaUploadResponse {
  final List<NetworkMediaModel> mediaList;

  MediaUploadResponse({required this.mediaList});

  factory MediaUploadResponse.fromMap(Map<String, dynamic> map) {
    return MediaUploadResponse(
      mediaList: List<NetworkMediaModel>.from(
        (map['data'])
            .map<NetworkMediaModel>((x) => NetworkMediaModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(mediaList.map((x) => x.toMap()).toList());
}
