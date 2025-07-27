// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class FollowerListModel {
  final List<FollowerModel> data;
  PaginationModel paginationModel;

  FollowerListModel({
    required this.data,
    required this.paginationModel,
  });

  factory FollowerListModel.emptyModel() =>
      FollowerListModel(data: [], paginationModel: PaginationModel.initial());

  factory FollowerListModel.fromJson(Map<String, dynamic> json) =>
      FollowerListModel(
        data: List<FollowerModel>.from(
          json["data"].map((x) => FollowerModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  FollowerListModel paginationCopyWith({required FollowerListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return FollowerListModel(data: data, paginationModel: paginationModel);
  }
}

class FollowerModel {
  final String userId;
  final String userName;
  final String userImage;
  bool blockedByUser;
  bool blockedByAdmin;
  final bool isAdmin;
  final bool isVerified;
  final LocationAddressWithLatLng location;

  ///To indicate whether the current user is viewing
  final bool isViewingUser;

  FollowerModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.location,
    required this.blockedByUser,
    required this.blockedByAdmin,
    required this.isViewingUser,
    required this.isAdmin,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'user_name': userName,
      'user_image': userImage,
      'location': location.toMap(),
      'is_viewing_user': isViewingUser,
      'blocked_by_user': blockedByUser,
      'blocked_by_admin': blockedByAdmin,
      'is_admin': isAdmin,
      'is_verified': isVerified,
    };
  }

  factory FollowerModel.fromMap(Map<String, dynamic> map) {
    return FollowerModel(
      userId: map['user_id'],
      userName: map['user_name'],
      userImage: map['user_image'],
      location: LocationAddressWithLatLng.fromMap(map['location']),
      isViewingUser: map['is_viewing_user']??false,
      blockedByUser: map['blocked_by_user']??false,
      blockedByAdmin: map['blocked_by_admin']??false,
      isAdmin: map['is_admin']??false,
      isVerified: map['is_verified'],
    );
  }
}
