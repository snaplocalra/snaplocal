// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class ProfileConnectionTypeModel {
  final ProfileConnectionListModel myConnections;
  final ProfileConnectionListModel requestedConnection;
  ProfileConnectionTypeModel({
    required this.myConnections,
    required this.requestedConnection,
  });
  bool get isEmpty =>
      myConnections.data.isEmpty || requestedConnection.data.isEmpty;

  bool get isBothListEmpty =>
      myConnections.data.isEmpty && requestedConnection.data.isEmpty;

  ProfileConnectionTypeModel copyWith({
    ProfileConnectionListModel? myConnections,
    ProfileConnectionListModel? requestedConnection,
  }) {
    return ProfileConnectionTypeModel(
      myConnections: myConnections ?? this.myConnections,
      requestedConnection: requestedConnection ?? this.requestedConnection,
    );
  }
}

class ProfileConnectionListModel {
  final List<ProfileConnectionModel> data;
  PaginationModel paginationModel;

  ProfileConnectionListModel({
    required this.data,
    required this.paginationModel,
  });

  factory ProfileConnectionListModel.fromJson(Map<String, dynamic> json) =>
      ProfileConnectionListModel(
        data: List<ProfileConnectionModel>.from(
            json["data"].map((x) => ProfileConnectionModel.fromJson(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  //Use for pagination
  ProfileConnectionListModel paginationCopyWith(
      {required ProfileConnectionListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return ProfileConnectionListModel(
        data: data, paginationModel: paginationModel);
  }
}

class ProfileConnectionModel {
  final String id;
  final String requestedUserId;
  final String targetingUserId;
  final String status;
  final bool isVerified;
  final String requestedUserName;
  final String requestedUserImage;
  final String? address;

  ProfileConnectionModel({
    required this.id,
    required this.requestedUserId,
    required this.targetingUserId,
    required this.status,
    required this.isVerified,
    required this.requestedUserName,
    required this.requestedUserImage,
    this.address,
  });

  factory ProfileConnectionModel.fromJson(Map<String, dynamic> json) =>
      ProfileConnectionModel(
        id: json["id"],
        requestedUserId: json["requested_user_id"],
        targetingUserId: json["targeting_user_id"],
        status: json["status"],
        isVerified: json["is_verified"]??false,
        requestedUserName: json["requested_user_name"],
        requestedUserImage: json["requested_user_image"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requested_user_id": requestedUserId,
        "targeting_user_id": targetingUserId,
        "status": status,
        "is_verified": isVerified,
        "requested_user_name": requestedUserName,
        "requested_user_image": requestedUserImage,
        "address": address,
      };
}
