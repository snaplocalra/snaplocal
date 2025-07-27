import 'package:equatable/equatable.dart';

import '../../../../utility/constant/errors.dart';

class LocalBuyAndSellModel extends Equatable {
  final String status;
  final String message;
  final List<BuyAndSellItem> data;

  const LocalBuyAndSellModel({
    required this.status,
    required this.message,
    required this.data,
  });


  factory LocalBuyAndSellModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildBuySellSection(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildBuySellSection(map);
    }
  }

  static LocalBuyAndSellModel _buildBuySellSection(Map<String, dynamic> map) {
    return LocalBuyAndSellModel(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: List<BuyAndSellItem>.from(
        (map['data'] ?? []).map((x) => BuyAndSellItem.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];
}

class BuyAndSellItem extends Equatable {
  final String id;
  final String itemName;
  final Category category;
  final String distance;
  final Price? price;
  final int salePreferenceRadius;
  final bool isSaved;
  final String postType;
  final bool isSold;
  final bool isBought;
  final bool hideExactLocation;
  final String totalView;
  final String conditionType;
  final String saleType;
  final String details;
  final String postVisibility;
  final Location location;
  final Location taggedLocation;
  final List<Media> media;

  const BuyAndSellItem({
    required this.id,
    required this.itemName,
    required this.category,
    required this.distance,
    this.price,
    required this.salePreferenceRadius,
    required this.isSaved,
    required this.postType,
    required this.isSold,
    required this.isBought,
    required this.hideExactLocation,
    required this.totalView,
    required this.conditionType,
    required this.saleType,
    required this.details,
    required this.postVisibility,
    required this.location,
    required this.taggedLocation,
    required this.media,
  });


  factory BuyAndSellItem.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildBuySell(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildBuySell(map);
    }
  }

  static BuyAndSellItem _buildBuySell(Map<String, dynamic> map) {
    return BuyAndSellItem(
      id: map['id'] ?? '',
      itemName: map['item_name'] ?? '',
      category: Category.fromMap(map['category'] ?? {}),
      distance: map['distance'] ?? '',
      price: map['price'] != null ? Price.fromMap(map['price']) : null,
      salePreferenceRadius: map['sale_preference_radius'] ?? 0,
      isSaved: map['is_saved'] ?? false,
      postType: map['post_type'] ?? '',
      isSold: map['is_sold'] ?? false,
      isBought: map['is_bought'] ?? false,
      hideExactLocation: map['hide_exact_location'] ?? false,
      totalView: map['total_view'] ?? '',
      conditionType: map['condition_type'] ?? '',
      saleType: map['sale_type'] ?? '',
      details: map['details'] ?? '',
      postVisibility: map['post_visibility'] ?? '',
      location: Location.fromMap(map['location'] ?? {}),
      taggedLocation: Location.fromMap(map['tagged_location'] ?? {}),
      media: List<Media>.from(
        (map['media'] ?? []).map((x) => Media.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_name': itemName,
      'category': category.toMap(),
      'distance': distance,
      'price': price?.toMap(),
      'sale_preference_radius': salePreferenceRadius,
      'is_saved': isSaved,
      'post_type': postType,
      'is_sold': isSold,
      'is_bought': isBought,
      'hide_exact_location': hideExactLocation,
      'total_view': totalView,
      'condition_type': conditionType,
      'sale_type': saleType,
      'details': details,
      'post_visibility': postVisibility,
      'location': location.toMap(),
      'tagged_location': taggedLocation.toMap(),
      'media': media.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        itemName,
        category,
        distance,
        price,
        salePreferenceRadius,
        isSaved,
        postType,
        isSold,
        isBought,
        hideExactLocation,
        totalView,
        conditionType,
        saleType,
        details,
        postVisibility,
        location,
        taggedLocation,
        media,
      ];
}

class Category extends Equatable {
  final String id;
  final String name;
  final SubCategory subCategory;
  final List<DynamicCategory> dynamicCategory;

  const Category({
    required this.id,
    required this.name,
    required this.subCategory,
    required this.dynamicCategory,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subCategory: SubCategory.fromMap(map['sub_category'] ?? {}),
      dynamicCategory: List<DynamicCategory>.from(
        (map['dynamic_category'] ?? []).map((x) => DynamicCategory.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sub_category': subCategory.toMap(),
      'dynamic_category': dynamicCategory.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, subCategory, dynamicCategory];
}

class SubCategory extends Equatable {
  final String id;
  final String name;

  const SubCategory({
    required this.id,
    required this.name,
  });

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class DynamicCategory extends Equatable {
  final String fieldId;
  final String fieldType;
  final String? fieldValue;
  final String? fieldValueId;

  const DynamicCategory({
    required this.fieldId,
    required this.fieldType,
    this.fieldValue,
    this.fieldValueId,
  });

  factory DynamicCategory.fromMap(Map<String, dynamic> map) {
    return DynamicCategory(
      fieldId: map['field_id'] ?? '',
      fieldType: map['field_type'] ?? '',
      fieldValue: map['field_value'],
      fieldValueId: map['field_value_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'field_id': fieldId,
      'field_type': fieldType,
      'field_value': fieldValue,
      'field_value_id': fieldValueId,
    };
  }

  @override
  List<Object?> get props => [fieldId, fieldType, fieldValue, fieldValueId];
}

class Price extends Equatable {
  final String currency;
  final int amount;

  const Price({
    required this.currency,
    required this.amount,
  });

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      currency: map['currency'] ?? '',
      amount: map['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [currency, amount];
}

class Location extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [address, latitude, longitude];
}

class Media extends Equatable {
  final String mediaPath;
  final String mediaType;
  final int height;
  final int width;
  final String? thumbnail;

  const Media({
    required this.mediaPath,
    required this.mediaType,
    required this.height,
    required this.width,
    this.thumbnail,
  });

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      mediaPath: map['media_path'] ?? '',
      mediaType: map['media_type'] ?? '',
      height: map['height'] ?? 0,
      width: map['width'] ?? 0,
      thumbnail: map['thumbnail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'media_path': mediaPath,
      'media_type': mediaType,
      'height': height,
      'width': width,
      'thumbnail': thumbnail,
    };
  }

  @override
  List<Object?> get props => [mediaPath, mediaType, height, width, thumbnail];
} 