import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

class NewsChannelOverViewModel extends Equatable {
  final NewsChannelInfoModel newsChannelInfoModel;
  final NewsChannelOverviewStatisticsModel newsChannelOverviewStatistics;
  final SocialPostsList newsFromThisContrubutor;

  const NewsChannelOverViewModel({
    required this.newsChannelInfoModel,
    required this.newsFromThisContrubutor,
    required this.newsChannelOverviewStatistics,
  });

  factory NewsChannelOverViewModel.fromJson(Map<String, dynamic> map) {
    return NewsChannelOverViewModel(
      newsChannelInfoModel:
          NewsChannelInfoModel.fromJson(map['news_channel_info']),
      newsFromThisContrubutor:
          SocialPostsList.fromMap(map['news_from_this_contributor']),
      newsChannelOverviewStatistics:
          NewsChannelOverviewStatisticsModel.fromJson(map['statistics']),
    );
  }

  NewsChannelOverViewModel copyWith({
    NewsChannelInfoModel? newsChannelInfoModel,
    SocialPostsList? newsFromThisContrubutor,
    NewsChannelOverviewStatisticsModel? newsChannelOverviewStatistics,
  }) {
    return NewsChannelOverViewModel(
      newsChannelInfoModel: newsChannelInfoModel ?? this.newsChannelInfoModel,
      newsFromThisContrubutor:
          newsFromThisContrubutor ?? this.newsFromThisContrubutor,
      newsChannelOverviewStatistics:
          newsChannelOverviewStatistics ?? this.newsChannelOverviewStatistics,
    );
  }

  @override
  List<Object?> get props => [
        newsChannelInfoModel,
        newsFromThisContrubutor,
        newsChannelOverviewStatistics,
      ];
}

class NewsChannelInfoModel {
  final String id;
  final String userId;
  final String name;
  final String newsContributorName;
  final String description;
  final String coverImage;
  final LocationAddressWithLatLng postLocation;
  final int postPreferenceRadius;
  final DateTime createdAt;
  final bool enableChat;
  final int totalFollowers;
  final bool isChannelAdmin;
  final bool blockedByYou;
  final bool isFollowing;
  NewsChannelInfoModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.newsContributorName,
    required this.description,
    required this.coverImage,
    required this.totalFollowers,
    required this.isChannelAdmin,
    required this.postPreferenceRadius,
    required this.postLocation,
    required this.enableChat,
    required this.blockedByYou,
    required this.isFollowing,
  });

  factory NewsChannelInfoModel.fromJson(Map<String, dynamic> json) =>
      NewsChannelInfoModel(
          id: json["id"],
          name: json["name"],
          userId: json["user_id"],
          newsContributorName: json["news_contributor"],
          description: json["description"] ?? "",
          coverImage: json["cover_image"],
          totalFollowers: json["total_followers"] ?? 0,
          isChannelAdmin: json["is_channel_admin"],
          postPreferenceRadius: json["post_preference_radius"],
          postLocation:
              LocationAddressWithLatLng.fromMap(json["post_location"]),
          enableChat: json["enable_chat"],
          blockedByYou: json["blocked_by_you"],
          isFollowing: json["is_following"],
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(json["channel_created_on"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "news_contributor": newsContributorName,
        "description": description,
        "cover_image": coverImage,
        "total_followers": totalFollowers,
        "is_channel_admin": isChannelAdmin,
        "post_preference_radius": postPreferenceRadius,
        "post_location": postLocation.toJson(),
        "enable_chat": enableChat,
        "blocked_by_you": blockedByYou,
        "channel_created_on": createdAt.millisecondsSinceEpoch,
        "is_following": isFollowing,
      };
}

class NewsChannelOverviewStatisticsModel {
  final int totalNewsPosted;
  final int totalLikes;
  final int totalViews;
  final int totalShares;

  NewsChannelOverviewStatisticsModel({
    required this.totalNewsPosted,
    required this.totalLikes,
    required this.totalViews,
    required this.totalShares,
  });

  factory NewsChannelOverviewStatisticsModel.fromJson(
      Map<String, dynamic> json) {
    return NewsChannelOverviewStatisticsModel(
      totalNewsPosted: json["total_approved_news"],
      totalLikes: json["total_likes"],
      totalViews: json["total_views"],
      totalShares: json["total_share"],
    );
  }
}
