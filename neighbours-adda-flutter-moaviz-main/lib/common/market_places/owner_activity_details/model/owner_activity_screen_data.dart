import 'dart:convert';

import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';

class OwnerActivityDetailsScreenData {
  final String postId;
  final OwnerActivityType ownerActivityType;

  OwnerActivityDetailsScreenData({
    required this.postId,
    required this.ownerActivityType,
  });

  //from map
  factory OwnerActivityDetailsScreenData.fromMap(Map<String, dynamic> map) {
    return OwnerActivityDetailsScreenData(
      postId: map['post_id'],
      ownerActivityType:
          OwnerActivityType.fromString(map['owner_activity_type']),
    );
  }

  //from json
  factory OwnerActivityDetailsScreenData.fromJson(String json) =>
      OwnerActivityDetailsScreenData.fromMap(jsonDecode(json));

  //to map
  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'owner_activity_type': ownerActivityType.jsonName,
    };
  }

  //to json
  String toJson() => jsonEncode(toMap());
}
