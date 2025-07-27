import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/tools/text_field_regx.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class ManageEventModel {
  final String? id;
  final String title;
  final String description;
  final String eventCategoryId;
  final PostType postType;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final PostCommentPermission commentPermission;
  final PostVisibilityControlEnum visibilityPermission;
  final PostSharePermission sharePermission;
  final double postRadiusPreference;
  final LocationAddressWithLatLng postLocation;
  final LocationAddressWithLatLng? eventLocation;

  final List<NetworkMediaModel> media;

  ManageEventModel({
    this.eventLocation,
    this.id,
    required this.title,
    required this.eventCategoryId,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.postType,
    required this.description,
    required this.postRadiusPreference,
    required this.postLocation,
    required this.commentPermission,
    required this.visibilityPermission,
    required this.sharePermission,
    required this.media,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'topic_id': eventCategoryId,
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'start_time':
          FormatDate.timeOfTheDayToDateTime(startTime).millisecondsSinceEpoch,
      'end_time':
          FormatDate.timeOfTheDayToDateTime(endTime).millisecondsSinceEpoch,
      'post_type': postType.param,
      'post_visibility': visibilityPermission.type,
      'is_sharing_allowed': sharePermission.allowShare,
      'is_commenting_allowed': commentPermission.allowComment,
      'description': TextFormatter.removeBlankSpace(description),
      'post_radius_preference': postRadiusPreference,

      //post location
      'post_location': postLocation.toJson(),
      'tagged_location': eventLocation?.toJson(),

      'media': jsonEncode(media.map((x) => x.toMap()).toList()),
    };
  }
}
