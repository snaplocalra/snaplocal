// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/common/market_places/models/post_owner_details.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';

class OwnerActivityDetailsModel {
  final PostOwnerDetailsModel postOwnerDetails;
  final bool hasUserRated;
  const OwnerActivityDetailsModel({
    required this.postOwnerDetails,
    required this.hasUserRated,
  });

  factory OwnerActivityDetailsModel.fromMap(Map<String, dynamic> map) {
    return OwnerActivityDetailsModel(
      postOwnerDetails:
          PostOwnerDetailsModel.fromJson(map['post_owner_details']),
      hasUserRated: map['has_user_rated'] ?? false,
    );
  }

  factory OwnerActivityDetailsModel.getModelByType(Map<String, dynamic> json) {
    final ownerActivityType =
        OwnerActivityType.fromString(json['activity_type']);

    switch (ownerActivityType) {
      case OwnerActivityType.job:
        return JobActivityModel.fromMap(json);

      case OwnerActivityType.market:
        return BuySellActivityModel.fromMap(json);

      default:
        throw Exception("Unknown post type: $ownerActivityType");
    }
  }
}

class BuySellActivityModel extends OwnerActivityDetailsModel {
  final int boughtCount;
  final int soldCount;
  final List<SalesPostShortDetailsModel> itemsFromSeller;

  const BuySellActivityModel({
    required super.postOwnerDetails,
    required this.boughtCount,
    required this.soldCount,
    required this.itemsFromSeller,
    required super.hasUserRated,
  });

  factory BuySellActivityModel.fromMap(Map<String, dynamic> map) {
    final superData = OwnerActivityDetailsModel.fromMap(map);

    return BuySellActivityModel(
      postOwnerDetails: superData.postOwnerDetails,
      hasUserRated: superData.hasUserRated,
      boughtCount: (map['bought'] ?? 0) as int,
      soldCount: (map['sold'] ?? 0) as int,
      itemsFromSeller: List<SalesPostShortDetailsModel>.from(
        (map['item_from_seller'])
            .map((x) => SalesPostShortDetailsModel.fromMap(x)),
      ),
    );
  }
}

class JobActivityModel extends OwnerActivityDetailsModel {
  final int jobPosted;
  final List<JobShortDetailsModel> jobsPostedByOwner;

  const JobActivityModel({
    required super.hasUserRated,
    required super.postOwnerDetails,
    required this.jobPosted,
    required this.jobsPostedByOwner,
  });

  factory JobActivityModel.fromMap(Map<String, dynamic> map) {
    final superData = OwnerActivityDetailsModel.fromMap(map);
    return JobActivityModel(
      hasUserRated: superData.hasUserRated,
      postOwnerDetails: superData.postOwnerDetails,
      jobPosted: (map['posted'] ?? 0) as int,
      jobsPostedByOwner: List<JobShortDetailsModel>.from(
        (map['job_posted_by_owner']).map<JobShortDetailsModel>(
          (x) => JobShortDetailsModel.fromMap(x),
        ),
      ),
    );
  }
}
