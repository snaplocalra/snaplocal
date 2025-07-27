// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/profile/profile_settings/models/profile_account_details.dart';

class ProfileSettingsModel extends Equatable {
  final FeedRadiusModel feedRadiusModel;
  final LocationAddressWithLatLng? socialMediaLocation;
  final LocationAddressWithLatLng? marketPlaceLocation;
  final ProfileAccountDetails profileAccountDetails;

  const ProfileSettingsModel({
    required this.feedRadiusModel,
    required this.socialMediaLocation,
    required this.marketPlaceLocation,
    required this.profileAccountDetails,
  });

  ProfileSettingsModel copyWith({
    FeedRadiusModel? feedRadiusModel,
    LocationAddressWithLatLng? socialMediaLocation,
    LocationAddressWithLatLng? marketPlaceLocation,
    ProfileAccountDetails? profileAccountDetails,
  }) {
    return ProfileSettingsModel(
      feedRadiusModel: feedRadiusModel ?? this.feedRadiusModel,
      socialMediaLocation: socialMediaLocation ?? this.socialMediaLocation,
      marketPlaceLocation: marketPlaceLocation ?? this.marketPlaceLocation,
      profileAccountDetails:
          profileAccountDetails ?? this.profileAccountDetails,
    );
  }

  @override
  List<Object?> get props => [
        feedRadiusModel,
        socialMediaLocation,
        marketPlaceLocation,
        profileAccountDetails,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'feed_radius_details': feedRadiusModel.toMap(),
      'social_media_location_details': socialMediaLocation?.toMap(),
      'market_place_location_details': marketPlaceLocation?.toMap(),
      'account_details': profileAccountDetails.toMap(),
    };
  }

  factory ProfileSettingsModel.fromMap(Map<String, dynamic> map) {
    final socialMediaLocation = map['social_media_location_details'];
    final marketPlaceLocation = map['market_place_location_details'];
    return ProfileSettingsModel(
      feedRadiusModel: FeedRadiusModel.fromMap(
          map['feed_radius_details'] as Map<String, dynamic>),
      socialMediaLocation: socialMediaLocation == null
          ? null
          : LocationAddressWithLatLng.fromMap(socialMediaLocation),
      marketPlaceLocation: marketPlaceLocation == null
          ? null
          : LocationAddressWithLatLng.fromMap(marketPlaceLocation),
      profileAccountDetails: ProfileAccountDetails.fromMap(
          map['account_details'] as Map<String, dynamic>),
    );
  }
}
