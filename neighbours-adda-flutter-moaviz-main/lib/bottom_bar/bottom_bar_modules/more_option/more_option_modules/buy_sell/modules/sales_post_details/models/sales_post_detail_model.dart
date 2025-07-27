// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/item_condition_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sell_type_enum.dart';
import 'package:snap_local/common/market_places/models/post_owner_details.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/models/price_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class SalesPostDetailModel {
  final String id;
  final double salePreferenceRadius;
  final LocationAddressWithLatLng? taggedlocation;
  final LocationAddressWithLatLng postLocation;
  final String distance;
  final String name;
  final PriceModel? price;
  final ItemCondition itemCondition;
  final SellType saleType;
  final String description;
  final DateTime createdAt;
  final bool isPostAdmin;
  final bool isSaved;
  final bool isInterested;
  final int interestedPeopleCount;
  final bool isSoldout;
  final bool hideExactLocation;
  final bool hasUserRated;
  final PostOwnerDetailsModel sellerDetails;
  final List<NetworkMediaModel> media;
  final bool reportedByUser;
  final List<SalesPostShortDetailsModel> nearByRecommendation;
  final PostVisibilityControlEnum postVisibilityPermission;
  final CategoryModelV3 category;

  SalesPostDetailModel({
    required this.id,
    required this.salePreferenceRadius,
    required this.taggedlocation,
    required this.postLocation,
    required this.distance,
    required this.name,
    required this.price,
    required this.itemCondition,
    required this.saleType,
    required this.description,
    required this.createdAt,
    required this.isPostAdmin,
    required this.interestedPeopleCount,
    required this.isSaved,
    required this.isInterested,
    required this.isSoldout,
    required this.hasUserRated,
    required this.hideExactLocation,
    required this.sellerDetails,
    required this.media,
    required this.nearByRecommendation,
    required this.reportedByUser,
    required this.postVisibilityPermission,
    required this.category,
  });

  factory SalesPostDetailModel.fromJson(Map<String, dynamic> json) =>
      SalesPostDetailModel(
        id: json["id"],
        salePreferenceRadius:
            double.parse(json["sale_preference_radius"].toString()),
        taggedlocation: json['tagged_location'] == null
            ? null
            : LocationAddressWithLatLng.fromMap(json['tagged_location']),
        postLocation: LocationAddressWithLatLng.fromMap(json['location']),
        distance: json["distance"],
        name: json["name"],
        price: json["price"] == null ? null : PriceModel.fromMap(json["price"]),
        itemCondition: ItemCondition.fromMap(json["condition_type"]),
        saleType: SellType.fromMap(json["sale_type"]),
        description: json["details"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        isPostAdmin: json["is_post_admin"],
        isSaved: json["is_saved"],
        isSoldout: json["is_sold"],
        isInterested: json["is_bought"],
        interestedPeopleCount: json["interested_people_count"] ?? 0,
        hasUserRated: json["user_has_rated"],
        hideExactLocation: json["hide_exact_location"],
        sellerDetails: PostOwnerDetailsModel.fromJson(json["user_details"]),
        reportedByUser: json["reported_by_user"] ?? false,
        media: List<NetworkMediaModel>.from(
          json["media"].map((x) => NetworkMediaModel.fromMap(x)),
        ),
        nearByRecommendation: List<SalesPostShortDetailsModel>.from(
          json["nearby_list"].map((x) => SalesPostShortDetailsModel.fromMap(x)),
        ),
        postVisibilityPermission:
            PostVisibilityControlEnum.fromString(json["post_visibility"]),
        category: CategoryModelV3.fromMap(json["category"]),
      );

  SalesPostDetailModel copyWith({
    String? id,
    double? salePreferenceRadius,
    LocationAddressWithLatLng? taggedlocation,
    LocationAddressWithLatLng? postLocation,
    String? distance,
    String? name,
    PriceModel? price,
    ItemCondition? itemCondition,
    SellType? saleType,
    String? description,
    DateTime? createdAt,
    CategoryModelV3? category,
    bool? isPostAdmin,
    bool? isSaved,
    bool? isInterested,
    int? interestedPeopleCount,
    bool? isSoldout,
    bool? hideExactLocation,
    bool? hasUserRated,
    PostOwnerDetailsModel? sellerDetails,
    List<NetworkMediaModel>? media,
    List<SalesPostShortDetailsModel>? nearByRecommendation,
    bool? reportedByUser,
    PostVisibilityControlEnum? postVisibilityPermission,
  }) {
    return SalesPostDetailModel(
      id: id ?? this.id,
      salePreferenceRadius: salePreferenceRadius ?? this.salePreferenceRadius,
      taggedlocation: taggedlocation ?? this.taggedlocation,
      postLocation: postLocation ?? this.postLocation,
      distance: distance ?? this.distance,
      name: name ?? this.name,
      price: price ?? this.price,
      itemCondition: itemCondition ?? this.itemCondition,
      saleType: saleType ?? this.saleType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isPostAdmin: isPostAdmin ?? this.isPostAdmin,
      isSaved: isSaved ?? this.isSaved,
      isInterested: isInterested ?? this.isInterested,
      interestedPeopleCount:
          interestedPeopleCount ?? this.interestedPeopleCount,
      isSoldout: isSoldout ?? this.isSoldout,
      hideExactLocation: hideExactLocation ?? this.hideExactLocation,
      hasUserRated: hasUserRated ?? this.hasUserRated,
      sellerDetails: sellerDetails ?? this.sellerDetails,
      media: media ?? this.media,
      reportedByUser: reportedByUser ?? this.reportedByUser,
      nearByRecommendation: nearByRecommendation ?? this.nearByRecommendation,
      postVisibilityPermission:
          postVisibilityPermission ?? this.postVisibilityPermission,
      category: category ?? this.category,
    );
  }
}
