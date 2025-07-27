import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

class PostReactionDetails {
  final ReactionCountDetails reactionCountDetails;
  final List<UserReactedModel> usersReacted;

  PostReactionDetails({
    required this.reactionCountDetails,
    required this.usersReacted,
  });

  factory PostReactionDetails.fromJson(Map<String, dynamic> json) {
    return PostReactionDetails(
      reactionCountDetails:
          ReactionCountDetails.fromJson(json['reaction_counts_data']),
      usersReacted: List<UserReactedModel>.from(
          json['users_reacted'].map((x) => UserReactedModel.fromJson(x))),
    );
  }
}

class ReactionCountDetails {
  final int totalReactions;
  final List<IndividualReactionCount> individualReactionsCount;

  ReactionCountDetails({
    required this.totalReactions,
    required this.individualReactionsCount,
  });

  factory ReactionCountDetails.fromJson(Map<String, dynamic> json) {
    return ReactionCountDetails(
      totalReactions: json['total_reactions'],
      individualReactionsCount: List<IndividualReactionCount>.from(
        json['individual_reactions_count']
            .map((x) => IndividualReactionCount.fromJson(x)),
      ),
    );
  }
}

class IndividualReactionCount {
  String reactionSvg;
  int reactionCount;

  IndividualReactionCount({
    required this.reactionSvg,
    required this.reactionCount,
  });

  factory IndividualReactionCount.fromJson(Map<String, dynamic> json) {
    return IndividualReactionCount(
      reactionSvg: json['reaction_svg'],
      reactionCount: int.parse(json['reaction_count'].toString()),
    );
  }
}

class UserReactedModel {
  final String userId;
  final String userImage;
  final String userName;
  final bool isOwnReaction;
  final LocationAddressWithLatLng userLocation;
  final String givenReactionSvg;

  UserReactedModel({
    required this.userId,
    required this.userImage,
    required this.userName,
    required this.userLocation,
    required this.givenReactionSvg,
    this.isOwnReaction = false,
  });

  factory UserReactedModel.fromJson(Map<String, dynamic> json) {
    return UserReactedModel(
      userId: json['user_id'],
      userImage: json['user_image'],
      userName: json['user_name'],
      userLocation: LocationAddressWithLatLng.fromMap(json['user_location']),
      givenReactionSvg: json['given_reaction_svg'],
      isOwnReaction: json['is_own_reaction'],
    );
  }
}
