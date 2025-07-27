import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class NewsDashboardNewsListModel extends Equatable {
  final SocialPostsList topPerformingNews;
  final SocialPostsList myApprovedNews;

  const NewsDashboardNewsListModel({
    required this.topPerformingNews,
    required this.myApprovedNews,
  });

  factory NewsDashboardNewsListModel.fromJson(Map<String, dynamic> map) {
    return NewsDashboardNewsListModel(
      topPerformingNews: SocialPostsList(
        socialPostList: List<SocialPostModel>.from(
          map['top_performing_news'].map((x) => NewsPostModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.initial(),
      ),
      myApprovedNews: SocialPostsList(
        socialPostList: List<SocialPostModel>.from(
          map['my_approved_news'].map((x) => NewsPostModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.initial(),
      ),
    );
  }

  NewsDashboardNewsListModel copyWith({
    SocialPostsList? topPerformingNews,
    SocialPostsList? myApprovedNews,
  }) {
    return NewsDashboardNewsListModel(
      topPerformingNews: topPerformingNews ?? this.topPerformingNews,
      myApprovedNews: myApprovedNews ?? this.myApprovedNews,
    );
  }

  @override
  List<Object?> get props => [topPerformingNews, myApprovedNews];
}

class NewsDashboardChannelStatisticsModel {
  final int totalNewsSubmitted;
  final int totalApprovedPosts;
  final int totalLikes;
  final int totalViews;
  final int totalShares;

  NewsDashboardChannelStatisticsModel({
    required this.totalNewsSubmitted,
    required this.totalApprovedPosts,
    required this.totalLikes,
    required this.totalViews,
    required this.totalShares,
  });

  factory NewsDashboardChannelStatisticsModel.fromJson(
      Map<String, dynamic> json) {
    return NewsDashboardChannelStatisticsModel(
      totalNewsSubmitted: json["total_news_submitted"],
      totalApprovedPosts: json["total_approved_posts"],
      totalLikes: json["total_likes"],
      totalViews: json["total_views"],
      totalShares: json["total_shares"],
    );
  }
}
