import 'dart:convert';

import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';

class RouteNavigationModel {
  final String screenRoute;
  final String? navigationId;
  final SocialPostNavigationDetailsModel? socialPostNavigationDetailsModel;
  final OtherCommunicationChatNavigationDetailsModel?
      otherCommunicationChatNavigationDetailsModel;

  RouteNavigationModel({
    required this.screenRoute,
    this.navigationId,
    this.socialPostNavigationDetailsModel,
    this.otherCommunicationChatNavigationDetailsModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'screen_name': screenRoute,
      'navigation_id': navigationId,
      'social_post_navigation_details':
          socialPostNavigationDetailsModel?.toMap(),
      'other_communication_chat_navigation_details':
          otherCommunicationChatNavigationDetailsModel?.toMap(),
    };
  }

  factory RouteNavigationModel.fromMap(Map<String, dynamic> map) {
    final otherCommunicationChatNavigationDetailsModel =
        map['other_communication_chat_navigation_details'];
    return RouteNavigationModel(
      screenRoute: map['screen_name'],
      navigationId: map['navigation_id'],
      socialPostNavigationDetailsModel:
          map['social_post_navigation_details'] != null
              ? SocialPostNavigationDetailsModel.fromMap(
                  map['social_post_navigation_details'],
                )
              : null,
      otherCommunicationChatNavigationDetailsModel:
          otherCommunicationChatNavigationDetailsModel != null
              ? OtherCommunicationChatNavigationDetailsModel.fromMap(
                  otherCommunicationChatNavigationDetailsModel,
                )
              : null,
    );
  }
}

class SocialPostNavigationDetailsModel {
  final PostType postType;
  final PostFrom postFrom;

  SocialPostNavigationDetailsModel({
    required this.postType,
    required this.postFrom,
  });

  factory SocialPostNavigationDetailsModel.fromMap(Map<String, dynamic> map) {
    return SocialPostNavigationDetailsModel(
      postType: PostType.fromString(map['post_type']),
      postFrom: PostFrom.fromString(map['post_from']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_type': postType,
      'post_from': postFrom,
    };
  }
}

//OtherCommunicationChatNavigationDetailsModel
class OtherCommunicationChatNavigationDetailsModel {
  final String id;
  final OtherCommunicationType otherCommunicationType;

  OtherCommunicationChatNavigationDetailsModel({
    required this.id,
    required this.otherCommunicationType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'other_communication_type': otherCommunicationType.value,
    };
  }

  //toMap to json
  String toJson() => jsonEncode(toMap());

  factory OtherCommunicationChatNavigationDetailsModel.fromMap(
      Map<String, dynamic> map) {
    return OtherCommunicationChatNavigationDetailsModel(
      id: map['id'],
      otherCommunicationType:
          OtherCommunicationType.fromString(map['other_communication_type']),
    );
  }
}
