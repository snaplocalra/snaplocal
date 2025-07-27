import 'dart:convert';

import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/share/model/share_type.dart';

class SharedPostDataModel {
  final String postId;
  final PostType postType;
  final PostFrom postFrom;
  final ShareType shareType;

  SharedPostDataModel({
    required this.postId,
    required this.postType,
    required this.postFrom,
    required this.shareType,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'post_type': postType.param,
      'post_from': postFrom.jsonName,
      'share_type': shareType.param,
    };
  }

  //to json
  String toJson() => json.encode(toMap());

  factory SharedPostDataModel.fromMap(Map<String, dynamic> map) {
    return SharedPostDataModel(
      postId: map['post_id'],
      postType: PostType.fromString(map['post_type']),
      postFrom: PostFrom.fromString(map['post_from']),
      shareType: ShareType.fromString(map['share_type']),
    );
  }

  factory SharedPostDataModel.fromJson(String source) =>
      SharedPostDataModel.fromMap(json.decode(source));
}
