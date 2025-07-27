import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

import '../../../../../utility/constant/errors.dart';
class GroupPageInfo {
  final String id;
  final String name;
  final String image;
  final CategoryListModelV2 category;
  final bool blockedByUser;
  final bool blockedByAdmin;
  final bool postAdmin;
  final bool isVerified;

  GroupPageInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.blockedByUser,
    required this.blockedByAdmin,
    required this.postAdmin,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'category': category.data.map((e) => e.toMap()).toList(),
      'blocked_by_user': blockedByUser,
      'blocked_by_admin': blockedByAdmin,
      'post_admin': postAdmin,
      'is_verified': isVerified,
    };
  }

  factory GroupPageInfo.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildGroupPageInfo(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildGroupPageInfo(map);
    }
  }

  static GroupPageInfo _buildGroupPageInfo(Map<String, dynamic> map) {
    return GroupPageInfo(
      id: map['id'],
      name: map['name'],
      image: map['image'] ?? map['post_type_image'],
      category: CategoryListModelV2.fromMap(map['category']),
      blockedByUser: map['blocked_by_user'] ?? false,
      blockedByAdmin: map['blocked_by_admin'] ?? false,
      postAdmin: map['is_post_admin'] ?? false,
      isVerified: map['is_verified'] ?? false,
    );
  }
}
