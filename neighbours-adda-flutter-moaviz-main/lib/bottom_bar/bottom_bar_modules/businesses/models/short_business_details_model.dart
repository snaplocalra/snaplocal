import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_status_enum.dart';
import 'package:snap_local/common/review_module/model/ratings_model.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

import '../../../../utility/constant/errors.dart';

class ShortBusinessDetailsModel {
  final String id;
  final LocationAddressWithLatLng postLocation;
  final LocationAddressWithLatLng businessLocation;
  final String distance;
  final String businessName;
  final CategoryListModelV2 category;
  final RatingsModel ratingsModel;
  final List<NetworkMediaModel> media;
  final BusinessStatus businessStatus;
  final bool isUnbeatableDeal;

  ShortBusinessDetailsModel({
    required this.id,
    required this.distance,
    required this.businessName,
    required this.category,
    required this.media,
    required this.postLocation,
    required this.businessLocation,
    required this.ratingsModel,
    required this.businessStatus,
    required this.isUnbeatableDeal,
  });

  factory ShortBusinessDetailsModel.fromMap(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildShortBusinessDetails(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildShortBusinessDetails(json);
    }
  }

  static ShortBusinessDetailsModel _buildShortBusinessDetails(Map<String, dynamic> json) =>
      ShortBusinessDetailsModel(
        id: json["id"],
        distance: json["distance"],
        businessName: json["business_name"],
        category: CategoryListModelV2.fromMap(json["category"]),
        media: List<NetworkMediaModel>.from(
          json["media"].map((x) => NetworkMediaModel.fromMap(x)),
        ),
        postLocation: LocationAddressWithLatLng.fromMap(json["post_location"]),
        businessLocation:
            LocationAddressWithLatLng.fromMap(json["business_location"]),
        ratingsModel: RatingsModel.fromMap(json["ratings"]),
        businessStatus: BusinessStatus.fromString(json["business_status"]),
        isUnbeatableDeal: json["is_unbeatable_deal"] ?? false,
      );

  //search keyword:
  /// Returns true if the search query matches the business name or category.
  /// If the search query is null, it returns true.
  /// check for Business Name, ⁠Business Category
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }
    final lowerCaseSearchQuery = searchQuery.toLowerCase();
    return businessName.toLowerCase().contains(lowerCaseSearchQuery) ||
        category.selectedCategories
            .map((e) => e.name.toLowerCase())
            .any((name) => name.contains(lowerCaseSearchQuery));
  }
}
