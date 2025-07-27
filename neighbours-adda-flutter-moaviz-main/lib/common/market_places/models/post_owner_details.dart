import 'package:snap_local/common/review_module/model/ratings_model.dart';

class PostOwnerDetailsModel {
  final String id;
  final String name;
  final String image;
  final String address;
  final bool isVerified;
  final RatingsModel? ratingsModel;

  PostOwnerDetailsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.isVerified,
    this.ratingsModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'address': address,
      'is_verified': isVerified,
      'user_ratings': ratingsModel?.toMap(),
    };
  }

  factory PostOwnerDetailsModel.fromJson(Map<String, dynamic> json) => PostOwnerDetailsModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        address: json["address"],
        isVerified: json["is_verified"]??false,
        ratingsModel:
            json["user_ratings"] == null ? null : RatingsModel.fromMap(json["user_ratings"]),
      );
}
