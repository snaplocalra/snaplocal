import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_status_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/short_business_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_hours_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_discount_option_model.dart';
import 'package:snap_local/common/market_places/models/post_owner_details.dart';
import 'package:snap_local/common/review_module/model/ratings_model.dart';
import 'package:snap_local/common/review_module/model/ratings_review_model.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

import '../../../../../../utility/constant/errors.dart';

class BusinessDetailsModel {
  final String id;
  final CategoryListModelV2 category;
  final String businessAddress;
  final LocationAddressWithLatLng businessLocation;
  final String websiteLink;
  final bool enableChat;
  final List<BusinessDiscountOptionModel> discountInPercentage;
  final List<BusinessDiscountOptionModel> discountInPrice;
  final double businessPreferenceRadius;
  final LocationAddressWithLatLng postLocation;
  final BusinessHoursModel businessHoursModel;
  final String phoneNumber;
  final bool hasDiscount;
  final String businessName;
  final String distance;
  final List<NetworkMediaModel> media;
  final RatingsModel ratingsModel;
  final bool hasUserRated;
  final CustomerReview? viewingUserReview;
  final bool isPostOwner;
  final PostOwnerDetailsModel postOwnerDetails;
  final List<ShortBusinessDetailsModel> nearbyList;
  final bool reportedByUser;
  final BusinessStatus businessStatus;

  BusinessDetailsModel({
    required this.id,
    required this.category,
    required this.businessAddress,
    required this.businessLocation,
    required this.websiteLink,
    required this.enableChat,
    required this.discountInPercentage,
    required this.discountInPrice,
    required this.businessPreferenceRadius,
    required this.postLocation,
    required this.businessHoursModel,
    required this.phoneNumber,
    required this.hasDiscount,
    required this.businessName,
    required this.distance,
    required this.media,
    required this.ratingsModel,
    required this.hasUserRated,
    required this.nearbyList,
    required this.isPostOwner,
    required this.postOwnerDetails,
    required this.viewingUserReview,
    required this.reportedByUser,
    required this.businessStatus,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildBusinessDetails(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildBusinessDetails(json);
    }
  }

  static BusinessDetailsModel _buildBusinessDetails(Map<String, dynamic> json) =>
      BusinessDetailsModel(
        id: json["id"],
        // businessDealsIn: List.from(json["deals_in"]),

        discountInPercentage: List<BusinessDiscountOptionModel>.from(
          json["discount_in_percentage"]
              .map((x) => BusinessDiscountOptionModel.fromMap(x)),
        ),

        discountInPrice: List<BusinessDiscountOptionModel>.from(
          json["discount_in_price"]
              .map((x) => BusinessDiscountOptionModel.fromMap(x)),
        ),

        category: CategoryListModelV2.fromMap(json["category"]),
        businessPreferenceRadius:
            double.parse(json["business_preference_radius"].toString()),
        postLocation: LocationAddressWithLatLng.fromMap(json["post_location"]),
        businessHoursModel: BusinessHoursModel.fromMap(json["business_hours"]),
        phoneNumber: json["mobile"] ?? "N/A",
        hasDiscount: json["has_discount"],
        businessName: json["business_name"],
        distance: json["distance"],
        media: List<NetworkMediaModel>.from(
          json["media"].map((x) => NetworkMediaModel.fromMap(x)),
        ),
        businessAddress: json["business_address"],
        businessLocation:
            LocationAddressWithLatLng.fromMap(json["business_location"]),
        websiteLink: json["website_link"] ?? "",
        enableChat: json["enable_chat"],
        ratingsModel: RatingsModel.fromMap(json["ratings"]),
        hasUserRated: json["user_has_rated"],
        nearbyList: json["nearby_list"] == null
            ? []
            : List<ShortBusinessDetailsModel>.from(
                json["nearby_list"]
                    .map((x) => ShortBusinessDetailsModel.fromMap(x)),
              ),
        isPostOwner: json["is_post_owner"] ?? false,
        postOwnerDetails:
            PostOwnerDetailsModel.fromJson(json["post_owner_details"]),
        viewingUserReview: json["viewing_user_review"] == null
            ? null
            : CustomerReview.fromJson(json["viewing_user_review"]),
        reportedByUser: json["reported_by_user"] ?? false,
        businessStatus: BusinessStatus.fromString(json["business_status"]),
      );
}
