// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class GroupConnectionListModel {
  final List<GroupConnectionModel> data;
  PaginationModel paginationModel;

  GroupConnectionListModel({
    required this.data,
    required this.paginationModel,
  });

  factory GroupConnectionListModel.fromJson(Map<String, dynamic> json) =>
      GroupConnectionListModel(
        data: List<GroupConnectionModel>.from(
            json["data"].map((x) => GroupConnectionModel.fromJson(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  Map<String, dynamic> toJson() =>
      {"data": List<dynamic>.from(data.map((x) => x.toJson()))};

  //Use for pagination
  GroupConnectionListModel paginationCopyWith(
      {required GroupConnectionListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return GroupConnectionListModel(
        data: data, paginationModel: paginationModel);
  }
}

class GroupConnectionModel {
  final String id;
  final String groupId;
  final String status;
  final String requestedUserId;
  final String requestedUserName;
  final String requestedUserImage;
  final String? address;

  GroupConnectionModel({
    required this.id,
    required this.groupId,
    required this.status,
    required this.requestedUserId,
    required this.requestedUserName,
    required this.requestedUserImage,
    this.address,
  });

  factory GroupConnectionModel.fromJson(Map<String, dynamic> json) =>
      GroupConnectionModel(
        id: json["id"],
        status: json["status"],
        address: json["address"],
        groupId: json["group_id"],
        requestedUserId: json["requested_user_id"],
        requestedUserName: json["requested_user_name"],
        requestedUserImage: json["requested_user_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "address": address,
        "group_id": groupId,
        "requested_user_id": requestedUserId,
        "requested_user_name": requestedUserName,
        "requested_user_image": requestedUserImage,
      };
}
