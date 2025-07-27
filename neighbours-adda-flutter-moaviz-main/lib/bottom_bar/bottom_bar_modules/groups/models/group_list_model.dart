// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

import '../../../../utility/constant/errors.dart';

class GroupTypeListModel {
  final GroupListModel groupsYouJoined;
  final GroupListModel managedByYou;
  GroupTypeListModel({
    required this.groupsYouJoined,
    required this.managedByYou,
  });
  bool get isEmpty => groupsYouJoined.data.isEmpty || managedByYou.data.isEmpty;

  bool get isBothListEmpty =>
      groupsYouJoined.data.isEmpty && managedByYou.data.isEmpty;

  GroupTypeListModel copyWith({
    GroupListModel? groupsYouJoined,
    GroupListModel? managedByYou,
  }) {
    return GroupTypeListModel(
      groupsYouJoined: groupsYouJoined ?? this.groupsYouJoined,
      managedByYou: managedByYou ?? this.managedByYou,
    );
  }
}

class GroupListModel {
  final List<GroupModel> data;
  PaginationModel paginationModel;

  GroupListModel({
    required this.data,
    required this.paginationModel,
  });

  factory GroupListModel.emptyModel() =>
      GroupListModel(data: [], paginationModel: PaginationModel.initial());

  factory GroupListModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildGroupList(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildGroupList(json);
    }
  }

  static GroupListModel _buildGroupList(Map<String, dynamic> json) => GroupListModel(
        data: List<GroupModel>.from(
            json["data"].map((x) => GroupModel.fromMap(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  GroupListModel paginationCopyWith({required GroupListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return GroupListModel(data: data, paginationModel: paginationModel);
  }
}

class GroupModel {
  final String groupId;
  final String groupImage;
  final String groupName;
  final String groupDescription;
  final int groupMemberCount;
  final LocationAddressWithLatLng location;
  final int unseenPostCount;
  bool isJoined;
  final bool isGroupAdmin;
  final bool isVerified;

  GroupModel({
    required this.groupId,
    required this.groupImage,
    required this.groupName,
    required this.groupDescription,
    required this.location,
    required this.groupMemberCount,
    required this.unseenPostCount,
    required this.isJoined,
    required this.isGroupAdmin,
    this.isVerified=false,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildGroup(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildGroup(map);
    }
  }


  static GroupModel _buildGroup(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['group_id'],
      groupImage: map['group_image'],
      groupName: map['group_name'],
      groupDescription: map['group_description'],
      location: LocationAddressWithLatLng.fromMap(map['location']),
      groupMemberCount: map['group_member_count'] ?? 0,
      unseenPostCount: map['unseen_post_count'] ?? 0,
      isJoined: map['is_joined'] ?? false,
      isGroupAdmin: map['is_group_admin'] ?? false,
      //isVerified: map['is_verified'] ?? false,
    );
  }

  //search keyword:
  /// Returns true if the search query matches the group name or description.
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }

    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    return groupName.toLowerCase().contains(lowerCaseSearchQuery) ||
        groupDescription.toLowerCase().contains(lowerCaseSearchQuery);
  }
}
