import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/models/price_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

import '../../../../../../utility/constant/errors.dart';

class SalesPostDataModel {
  final SalesPostListModel salesPostByNeighbours;
  final SalesPostListModel salesPostByYou;
  SalesPostDataModel({
    required this.salesPostByNeighbours,
    required this.salesPostByYou,
  });
  bool get isEmpty =>
      salesPostByNeighbours.data.isEmpty || salesPostByYou.data.isEmpty;

  bool get isBothListEmpty =>
      salesPostByNeighbours.data.isEmpty && salesPostByYou.data.isEmpty;

  SalesPostDataModel copyWith({
    SalesPostListModel? salesPostByNeighbours,
    SalesPostListModel? salesPostByYou,
  }) {
    return SalesPostDataModel(
      salesPostByNeighbours:
          salesPostByNeighbours ?? this.salesPostByNeighbours,
      salesPostByYou: salesPostByYou ?? this.salesPostByYou,
    );
  }
}

class SalesPostListModel {
  final List<SalesPostShortDetailsModel> data;
  PaginationModel paginationModel;

  SalesPostListModel({
    required this.data,
    required this.paginationModel,
  });

  factory SalesPostListModel.emptyModel() =>
      SalesPostListModel(data: [], paginationModel: PaginationModel.initial());
  factory SalesPostListModel.fromJson(Map<String, dynamic> json) =>
      SalesPostListModel(
        data: List<SalesPostShortDetailsModel>.from(
            json["data"].map((x) => SalesPostShortDetailsModel.fromMap(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  SalesPostListModel paginationCopyWith({required SalesPostListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return SalesPostListModel(data: data, paginationModel: paginationModel);
  }
}

class SalesPostShortDetailsModel {
  final String id;
  final int salePreferenceRadius;
  final LocationAddressWithLatLng location;
  final LocationAddressWithLatLng taggedLocation;
  final PriceModel? price;
  final String totalView;
  final String conditionType;
  final String saleType;
  final String distance;
  final String itemName;
  final bool isSaved;
  final bool isSold;
  final bool isBought;
  final bool hideExactLocation;
  final List<NetworkMediaModel> media;
  final CategoryModelV3 category;
  SalesPostShortDetailsModel({
    required this.id,
    required this.taggedLocation,
    required this.salePreferenceRadius,
    required this.location,
    required this.price,
    required this.totalView,
    required this.conditionType,
    required this.saleType,
    required this.distance,
    required this.itemName,
    required this.isSaved,
    required this.isSold,
    required this.isBought,
    required this.media,
    required this.hideExactLocation,
    required this.category,
  });

  factory SalesPostShortDetailsModel.fromMap(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildSalesPostShortDetails(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildSalesPostShortDetails(json);
    }
  }

  static SalesPostShortDetailsModel _buildSalesPostShortDetails(Map<String, dynamic> json) =>
      SalesPostShortDetailsModel(
        id: json["id"],
        salePreferenceRadius: json["sale_preference_radius"],
        taggedLocation:
            LocationAddressWithLatLng.fromMap(json["tagged_location"]),
        location: LocationAddressWithLatLng.fromMap(json["location"]),
        price: json["price"] == null ? null : PriceModel.fromMap(json["price"]),
        totalView: json["total_view"],
        conditionType: json["condition_type"],
        saleType: json["sale_type"],
        distance: json["distance"],
        itemName: json["item_name"],
        isSaved: json["is_saved"],
        isSold: json["is_sold"],
        isBought: json["is_bought"],
        media: List<NetworkMediaModel>.from(
          json["media"].map((x) => NetworkMediaModel.fromMap(x)),
        ),
        hideExactLocation: json["hide_exact_location"] ?? false,
        category: CategoryModelV3.fromMap(json["category"]),
      );

  SalesPostShortDetailsModel copyWith({
    String? id,
    String? saleCategoryId,
    int? salePreferenceRadius,
    LocationAddressWithLatLng? location,
    LocationAddressWithLatLng? taggedLocation,
    PriceModel? price,
    String? totalView,
    String? conditionType,
    String? saleType,
    String? distance,
    String? itemName,
    bool? isSaved,
    bool? isSold,
    bool? isBought,
    List<NetworkMediaModel>? media,
    bool? hideExactLocation,
  }) {
    return SalesPostShortDetailsModel(
      id: id ?? this.id,
      salePreferenceRadius: salePreferenceRadius ?? this.salePreferenceRadius,
      location: location ?? this.location,
      taggedLocation: taggedLocation ?? this.taggedLocation,
      price: price ?? this.price,
      totalView: totalView ?? this.totalView,
      conditionType: conditionType ?? this.conditionType,
      saleType: saleType ?? this.saleType,
      distance: distance ?? this.distance,
      itemName: itemName ?? this.itemName,
      isSaved: isSaved ?? this.isSaved,
      isSold: isSold ?? this.isSold,
      isBought: isBought ?? this.isBought,
      media: media ?? this.media,
      hideExactLocation: hideExactLocation ?? this.hideExactLocation,
      category: category,
    );
  }

  /// Returns true if the search query matches the ⁠Item Category, item description.
  /// If the search query is null, it returns true.
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }

    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    return itemName.toLowerCase().contains(lowerCaseSearchQuery);
    // || itemCategory.toLowerCase().contains(lowerCaseSearchQuery);
  }
}
