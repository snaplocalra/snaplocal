import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

class ComplimentedUserModel {
  final String userId;
  final String userImage;
  final String userName;
  final bool isGivenByYou;
  final LocationAddressWithLatLng userLocation;
  final String givenBadgeSvg;

  ComplimentedUserModel({
    required this.userId,
    required this.userImage,
    required this.userName,
    required this.userLocation,
    required this.givenBadgeSvg,
    this.isGivenByYou = false,
  });

  factory ComplimentedUserModel.fromJson(Map<String, dynamic> json) {
    return ComplimentedUserModel(
      userId: json['user_id'],
      userImage: json['user_image'],
      userName: json['user_name'],
      userLocation: LocationAddressWithLatLng.fromMap(json['user_location']),
      givenBadgeSvg: json['given_badge_svg'],
      isGivenByYou: json['is_given_by_you'] ?? false,
    );
  }
}
