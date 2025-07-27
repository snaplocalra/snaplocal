import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

class CreatePageModel {
  final String pageName;
  final CategoryListModelV2 category;
  final String description;
  final int pagePreferenceRadius;
  final double latitude;
  final double longitude;
  final String address;
  final bool enableChat;
  final bool showFollower;

  CreatePageModel(
      {required this.pageName,
      required this.category,
      required this.description,
      required this.pagePreferenceRadius,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.enableChat,
      required this.showFollower});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': pageName,
      'category': category.selectedDataJson(),
      'description': description,
      'page_preference_radius': pagePreferenceRadius,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      "enable_chat": enableChat,
      "show_follower": showFollower,
    };
  }
}
