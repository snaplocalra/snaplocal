import 'package:snap_local/profile/connections/models/profile_connection_details.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';

class NeighboursProfileModel {
  final bool allowUserToSendMessage;
  final bool isFollowing;
  final bool isFollowingViewedUser;
  final bool isFollowedByViewedUser;
  final ProfileDetailsModel profileDetailsModel;
  final ProfileConnectionDetailsModel connectionDetailsModel;

  NeighboursProfileModel({
    required this.profileDetailsModel,
    required this.allowUserToSendMessage,
    required this.isFollowing,
    required this.isFollowingViewedUser,
    required this.isFollowedByViewedUser,
    required this.connectionDetailsModel,
  });

  NeighboursProfileModel copyWith({
    bool? allowUserToSendMessage,
    ProfileDetailsModel? profileDetailsModel,
    ProfileConnectionDetailsModel? connectionDetailsModel,
  }) {
    return NeighboursProfileModel(
      allowUserToSendMessage: allowUserToSendMessage ?? this.allowUserToSendMessage,
      isFollowing: isFollowing,
      isFollowingViewedUser: isFollowingViewedUser,
      isFollowedByViewedUser: isFollowedByViewedUser,
      profileDetailsModel: profileDetailsModel ?? this.profileDetailsModel,
      connectionDetailsModel:
          connectionDetailsModel ?? this.connectionDetailsModel,
    );
  }

  factory NeighboursProfileModel.fromMap(Map<String, dynamic> map) {
    return NeighboursProfileModel(
      profileDetailsModel: ProfileDetailsModel.fromJson(
        map['profile_data'] as Map<String, dynamic>,
        isOwnProfile: false,
      ),
      allowUserToSendMessage: map["allow_user_to_send_message"],
      isFollowing: map["is_following"]??false,
      isFollowingViewedUser: map["is_following_viewed_user"]??false,
      isFollowedByViewedUser: map["is_followed_by_viewed_user"]??false,
      connectionDetailsModel:
          ProfileConnectionDetailsModel.fromMap(map['connection_details']),
    );
  }
}
