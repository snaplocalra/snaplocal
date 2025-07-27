// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/item_condition_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sell_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class SalesPostManageModel {
  final String? id;
  final CategoryModelV3 category;

  final double salesPreferenceRadius;
  final LocationAddressWithLatLng postLocation;
  final LocationAddressWithLatLng taggedLocation;
  final String itemName;
  final String itemPrice;
  final ItemCondition itemCondition;
  final SellType sellType;
  final String itemDescription;
  final List<NetworkMediaModel> media;
  final bool hideExactLocation;
  final PostVisibilityControlEnum visibilityPermission;

  SalesPostManageModel({
    this.id,
    required this.category,
    required this.salesPreferenceRadius,
    required this.postLocation,
    required this.taggedLocation,
    required this.itemName,
    required this.itemPrice,
    required this.itemCondition,
    required this.sellType,
    required this.itemDescription,
    required this.media,
    required this.visibilityPermission,
    required this.hideExactLocation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category.toJson(),
      'sale_preference_radius': salesPreferenceRadius,
      'post_location': postLocation.toJson(),
      'tagged_location': taggedLocation.toJson(),
      'name': itemName,
      'price': itemPrice,
      'condition_type': itemCondition.json,
      'sale_type': sellType.name,
      'description': itemDescription,
      'post_visibility': visibilityPermission.type,
      'hide_exact_location': hideExactLocation,
      'media': jsonEncode(media.map((x) => x.toMap()).toList()),
    };
  }
}
