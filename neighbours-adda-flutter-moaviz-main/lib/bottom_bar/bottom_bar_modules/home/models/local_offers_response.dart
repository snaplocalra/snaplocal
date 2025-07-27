import 'package:equatable/equatable.dart';

import '../../../../utility/constant/errors.dart';

class LocalOffersResponse extends Equatable {
  final String status;
  final String message;
  final List<LocalOffer> data;

  const LocalOffersResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocalOffersResponse.fromMap(Map<String, dynamic> map) {
    return LocalOffersResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: List<LocalOffer>.from(
        (map['data'] ?? []).map((x) => LocalOffer.fromMap(x)),
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

class LocalOffer extends Equatable {
  final String id;
  final String? businessName;
  final String? businessAddress;
  final String? businessLatitude;
  final String? businessLongitude;
  final String? businessLocation;
  final String? websiteLink;
  final bool discount;
  final String? totalView;
  final String? enableChat;
  final String? alwaysOpen;
  final String? distance;
  final String? rating;
  final String? discountPercentage;
  final String postType;
  final String? couponLink;
  final String? couponImage;
  final List<OfferMedia> media;

  const LocalOffer({
    required this.id,
    this.businessName,
    this.businessAddress,
    this.businessLatitude,
    this.businessLongitude,
    this.businessLocation,
    this.websiteLink,
    required this.discount,
    this.totalView,
    this.enableChat,
    this.alwaysOpen,
    this.distance,
    this.rating,
    this.discountPercentage,
    required this.postType,
    this.couponLink,
    this.couponImage,
    required this.media,
  });


  factory LocalOffer.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocalOffer(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalOffer(map);
    }
  }

  static LocalOffer _buildLocalOffer(Map<String, dynamic> map) {
    if (map['post_type'] == 'coupon') {
      return LocalOffer(
        id: map['id']?.toString() ?? '',
        postType: map['post_type'] ?? '',
        couponLink: map['coupon_link'],
        couponImage: map['coupon_image'],
        discount: false,
        media: [],
      );
    }

    return LocalOffer(
      id: map['id']?.toString() ?? '',
      businessName: map['business_name'],
      businessAddress: map['business_address'],
      businessLatitude: map['business_latitude'],
      businessLongitude: map['business_longitude'],
      businessLocation: map['business_location'],
      websiteLink: map['website_link'],
      discount: map['discount'] ?? false,
      totalView: map['total_view'],
      enableChat: map['enable_chat'],
      alwaysOpen: map['always_open'],
      distance: map['distance'],
      rating: map['rating'],
      discountPercentage: map['discount_percentage'],
      postType: map['post_type'] ?? '',
      media: List<OfferMedia>.from(
        (map['media'] ?? []).map((x) => OfferMedia.fromMap(x)),
      ),
      couponLink: null,
      couponImage: null,
    );
  }

  Map<String, dynamic> toMap() {
    if (postType == 'coupon') {
      return {
        'id': id,
        'post_type': postType,
        'coupon_link': couponLink,
        'coupon_image': couponImage,
      };
    }

    return {
      'id': id,
      'business_name': businessName,
      'business_address': businessAddress,
      'business_latitude': businessLatitude,
      'business_longitude': businessLongitude,
      'business_location': businessLocation,
      'website_link': websiteLink,
      'discount': discount,
      'total_view': totalView,
      'enable_chat': enableChat,
      'always_open': alwaysOpen,
      'distance': distance,
      'rating': rating,
      'discount_percentage': discountPercentage,
      'post_type': postType,
      'media': media.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        businessName,
        businessAddress,
        businessLatitude,
        businessLongitude,
        businessLocation,
        websiteLink,
        discount,
        totalView,
        enableChat,
        alwaysOpen,
        distance,
        rating,
        discountPercentage,
        postType,
        couponLink,
        couponImage,
        media,
      ];
}

class OfferMedia extends Equatable {
  final String mediaPath;
  final String mediaType;
  final int height;
  final int width;
  final String? thumbnail;

  const OfferMedia({
    required this.mediaPath,
    required this.mediaType,
    required this.height,
    required this.width,
    this.thumbnail,
  });

  factory OfferMedia.fromMap(Map<String, dynamic> map) {
    return OfferMedia(
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