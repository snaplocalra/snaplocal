import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

class CreateGroupModel {
  final String groupName;
  final CategoryListModelV2 category;
  final String groupPrivacyType;
  final String description;
  final int groupPreferenceRadius;
  final double latitude;
  final double longitude;
  final String address;
  final bool enableFollower;
  CreateGroupModel({
    required this.groupName,
    required this.groupPrivacyType,
    required this.category,
    required this.description,
    required this.groupPreferenceRadius,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.enableFollower,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': groupName,
      'privacy_type': groupPrivacyType,
      'category': category.selectedDataJson(),
      'description': description,
      'group_preference_radius': groupPreferenceRadius,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'show_follower': enableFollower,
    };
  }
}
