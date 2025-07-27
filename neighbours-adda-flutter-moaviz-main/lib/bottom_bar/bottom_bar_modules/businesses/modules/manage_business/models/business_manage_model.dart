import 'dart:convert';

import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_hours_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_discount_option_model.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class BusinessManageModel {
  final String? id;
  final CategoryListModelV2 category;
  final String businessAddress;
  final LocationAddressWithLatLng businessLocation;
  final String websiteLink;
  final bool enableChat;
  final BusinessDiscountOptionList discountInPercentage;
  final BusinessDiscountOptionList discountInPrice;
  final double businessPreferenceRadius;
  final LocationAddressWithLatLng postLocation;
  final BusinessHoursModel businessHoursModel;
  final String phoneNumber;
  final bool hasDiscount;
  final String businessName;
  final String otherBusinessCategory;
  final List<NetworkMediaModel> media;

  BusinessManageModel({
    this.id,
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
    required this.otherBusinessCategory,
    required this.media,
  });

  // toMap

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enable_chat': enableChat,
      'website_link': websiteLink,
      'business_address': businessAddress,
      'category': category.selectedDataJson(),
      'business_location': jsonEncode(businessLocation.toMap()),
      'discount_in_percentage': jsonEncode(discountInPercentage
          .filterEmptyOptions()
          .data
          .map((e) => e.toMap())
          .toList()),
      'discount_in_price': jsonEncode(discountInPrice
          .filterEmptyOptions()
          .data
          .map((e) => e.toMap())
          .toList()),
      'post_location': jsonEncode(postLocation.toMap()),
      'business_hours': jsonEncode(businessHoursModel.toMap()),
      'business_preference_radius': businessPreferenceRadius,
      'mobile': phoneNumber,
      'has_discount': hasDiscount,
      'business_name': businessName,
      'other_business_category': otherBusinessCategory,
      'media': jsonEncode(media.map((e) => e.toMap()).toList()),
    };
  }
}
