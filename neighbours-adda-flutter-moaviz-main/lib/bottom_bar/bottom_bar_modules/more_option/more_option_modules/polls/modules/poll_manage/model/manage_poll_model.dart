import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_option_model.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

class ManagePollModel {
  final String? id;
  final String pollQuestion;
  final DateTime? pollEndDate;
  final bool hideResultUntilPollEnds;
  final int pollPreferenceRadius;
  final ManagePollOptionList managePollOptionList;
  final PollTypeEnum pollTypeEnum;
  final bool isGlobalLocation;
  final String categoryId;
  final String otherCategoryName;

  //post settings
  final PostCommentPermission commentPermission;
  final PostVisibilityControlEnum visibilityPermission;
  final PostSharePermission sharePermission;

  //post location
  final LocationAddressWithLatLng postLocation;
  final LocationAddressWithLatLng? targetLocation;

  ManagePollModel({
    required this.id,
    required this.pollQuestion,
    this.pollEndDate,
    required this.hideResultUntilPollEnds,
    required this.pollPreferenceRadius,
    required this.sharePermission,
    required this.visibilityPermission,
    required this.commentPermission,
    required this.managePollOptionList,
    required this.categoryId,
    required this.otherCategoryName,

    //poll type
    required this.pollTypeEnum,
    required this.isGlobalLocation,

    //location
    required this.postLocation,
    required this.targetLocation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poll_question': pollQuestion,
      'end_date': pollEndDate?.millisecondsSinceEpoch,
      'poll_preference_radius': pollPreferenceRadius,
      'hide_result_until_poll_ends': hideResultUntilPollEnds,
      'options': managePollOptionList.toJson(),

      'post_visibility': visibilityPermission.type,
      'is_sharing_allowed': sharePermission.allowShare,
      'is_commenting_allowed': commentPermission.allowComment,
      'is_global_location': isGlobalLocation,
      'poll_type': pollTypeEnum.json,
      'category_id': categoryId,
      'other_category_name': otherCategoryName,

      //post location
      'post_location': postLocation.toJson(),
      'target_location': targetLocation?.toJson(),
    };
  }
}
