import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';

class SavedItemModel {
  final List<SocialPostModel> postsList;
  final List<SalesPostShortDetailsModel> salesPostShortDetailsList;
  final List<JobShortDetailsModel> jobsShortDetailsList;

  SavedItemModel({
    required this.postsList,
    required this.salesPostShortDetailsList,
    required this.jobsShortDetailsList,
  });

  factory SavedItemModel.fromMap(Map<String, dynamic> map) {
    return SavedItemModel(
      postsList: List<SocialPostModel>.from(
        (map['posts'])
            .map<SocialPostModel>((x) => SocialPostModel.getModelByType(x)),
      ),
      salesPostShortDetailsList: List<SalesPostShortDetailsModel>.from(
        (map['market_posts']).map<SalesPostShortDetailsModel>(
          (x) => SalesPostShortDetailsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      jobsShortDetailsList: List<JobShortDetailsModel>.from(
        (map['job_posts']).map<JobShortDetailsModel>(
          (x) => JobShortDetailsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
