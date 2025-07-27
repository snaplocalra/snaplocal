// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class InterestedPeopleListModel {
  final List<InterestedPeopleModel> data;
  PaginationModel paginationModel;

  InterestedPeopleListModel({
    required this.data,
    required this.paginationModel,
  });

  factory InterestedPeopleListModel.emptyModel() => InterestedPeopleListModel(
      data: [], paginationModel: PaginationModel.initial());

  factory InterestedPeopleListModel.fromJson(Map<String, dynamic> json) =>
      InterestedPeopleListModel(
        data: List<InterestedPeopleModel>.from(
          json["data"].map((x) => InterestedPeopleModel.fromMap(x)),
        ),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  InterestedPeopleListModel paginationCopyWith(
      {required InterestedPeopleListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return InterestedPeopleListModel(
        data: data, paginationModel: paginationModel);
  }
}

class InterestedPeopleModel {
  final String userId;
  final String userName;
  final String userImage;
  final LocationAddressWithLatLng location;

  ///To indicate whether the current user is viewing
  final bool isViewingUser;
  final bool isVerified;

  InterestedPeopleModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.location,
    required this.isViewingUser,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'user_name': userName,
      'user_image': userImage,
      'location': location.toMap(),
      'is_viewing_user': isViewingUser,
      'is_verified': isVerified,
    };
  }

  factory InterestedPeopleModel.fromMap(Map<String, dynamic> map) {
    return InterestedPeopleModel(
      userId: map['user_id'],
      userName: map['user_name'],
      userImage: map['user_image'],
      location: LocationAddressWithLatLng.fromMap(map['location']),
      isViewingUser: map['is_viewing_user'],
      isVerified: map['is_verified'],
    );
  }
}
