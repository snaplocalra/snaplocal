import 'package:equatable/equatable.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';

import '../../../../utility/constant/errors.dart';

class FeedRadiusModel extends Equatable {
  //User selected radius
  final double marketPlaceSearchRadius;
  final double socialMediaSearchRadius;

  //Max visibility radius
  final double maxSearchVisibilityRadius;
  final double maxPageVisibilityRadius;
  final double maxPollVisibilityRadius;

  const FeedRadiusModel({
    this.socialMediaSearchRadius = 0,
    this.marketPlaceSearchRadius = 0,
    this.maxSearchVisibilityRadius = 20,
    this.maxPageVisibilityRadius = 20,
    this.maxPollVisibilityRadius = 20,
  });

  @override
  List<Object> get props => [
        socialMediaSearchRadius,
        marketPlaceSearchRadius,
        maxSearchVisibilityRadius,
        maxPageVisibilityRadius,
        maxPollVisibilityRadius,
      ];

  double radiusByLocationType(LocationType locationType) {
    late double radiusByLocationType;
    if (locationType == LocationType.socialMedia) {
      radiusByLocationType = socialMediaSearchRadius;
    } else if (locationType == LocationType.marketPlace) {
      radiusByLocationType = marketPlaceSearchRadius;
    }

    return radiusByLocationType;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'market_place_search_radius': marketPlaceSearchRadius,
      'social_media_search_radius': socialMediaSearchRadius,
      'max_page_visibility_radius': maxPageVisibilityRadius,
      'max_search_visibility_radius': maxSearchVisibilityRadius,
      'max_poll_visibility_radius': maxPollVisibilityRadius,
    };
  }


  factory FeedRadiusModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildFeedRadius(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildFeedRadius(map);
    }
  }

  static FeedRadiusModel _buildFeedRadius(Map<String, dynamic> map) {
    return FeedRadiusModel(
      marketPlaceSearchRadius:
          double.parse(map['market_place_search_radius'].toString()),
      socialMediaSearchRadius:
          double.parse(map['social_media_search_radius'].toString()),
      maxSearchVisibilityRadius:
          double.parse(map['max_search_visibility_radius'].toString()),
      maxPageVisibilityRadius:
          double.parse(map['max_page_visibility_radius'].toString()),
      maxPollVisibilityRadius:
          double.parse(map['max_poll_visibility_radius'].toString()),
    );
  }

  FeedRadiusModel copyWith({
    double? marketPlaceSearchRadius,
    double? socialMediaSearchRadius,
    double? maxSearchVisibilityRadius,
    double? maxPageVisibilityRadius,
    double? maxPollVisibilityRadius,
    double? maxNewsVisibilityRadius,
  }) {
    return FeedRadiusModel(
      marketPlaceSearchRadius:
          marketPlaceSearchRadius ?? this.marketPlaceSearchRadius,
      socialMediaSearchRadius:
          socialMediaSearchRadius ?? this.socialMediaSearchRadius,
      maxSearchVisibilityRadius:
          maxSearchVisibilityRadius ?? this.maxSearchVisibilityRadius,
      maxPageVisibilityRadius:
          maxPageVisibilityRadius ?? this.maxPageVisibilityRadius,
      maxPollVisibilityRadius:
          maxPollVisibilityRadius ?? this.maxPollVisibilityRadius,
    );
  }
}
