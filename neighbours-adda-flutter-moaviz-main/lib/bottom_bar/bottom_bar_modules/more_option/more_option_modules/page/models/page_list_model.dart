// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

import '../../../../../../utility/constant/errors.dart';

class PageTypeListModel {
  final PageListModel pagesYouFollow;
  final PageListModel managedByYou;
  PageTypeListModel({
    required this.pagesYouFollow,
    required this.managedByYou,
  });
  bool get isEmpty => pagesYouFollow.data.isEmpty || managedByYou.data.isEmpty;

  bool get isBothListEmpty =>
      pagesYouFollow.data.isEmpty && managedByYou.data.isEmpty;

  PageTypeListModel copyWith({
    PageListModel? pagesYouFollow,
    PageListModel? managedByYou,
  }) {
    return PageTypeListModel(
      pagesYouFollow: pagesYouFollow ?? this.pagesYouFollow,
      managedByYou: managedByYou ?? this.managedByYou,
    );
  }
}

class PageListModel {
  final List<PageModel> data;
  PaginationModel paginationModel;

  PageListModel({
    required this.data,
    required this.paginationModel,
  });

  factory PageListModel.emptyModel() =>
      PageListModel(data: [], paginationModel: PaginationModel.initial());


  factory PageListModel.fromJson(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildPageList(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildPageList(json);
    }
  }

  static PageListModel _buildPageList(Map<String, dynamic> json) => PageListModel(
        data:
            List<PageModel>.from(json["data"].map((x) => PageModel.fromMap(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  PageListModel paginationCopyWith({required PageListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return PageListModel(data: data, paginationModel: paginationModel);
  }
}

class PageModel {
  final String pageId;
  final String pageImage;
  final String pageName;
  final String pageDescription;
  bool isFollowing;
  final bool isPageAdmin;
  final int unseenPostCount;
  final LocationAddressWithLatLng location;
  final bool blockedByAdmin;
  final bool blockedByUser;
  final int pageMemberCount;
  final bool isVerified;
  PageModel({
    required this.pageId,
    required this.pageImage,
    required this.pageName,
    required this.pageDescription,
    required this.isFollowing,
    required this.isPageAdmin,
    required this.unseenPostCount,
    required this.location,
    required this.blockedByAdmin,
    required this.blockedByUser,
    required this.pageMemberCount,
    this.isVerified=false,
  });


  factory PageModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildPage(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildPage(map);
    }
  }

  static PageModel _buildPage(Map<String, dynamic> map) {
    return PageModel(
      pageId: map['page_id'],
      pageImage: map['page_image'],
      pageName: map['page_name'],
      pageDescription: map['page_description'],
      isFollowing: map['is_following'],
      isPageAdmin: map['is_page_admin'],
      unseenPostCount: map['unseen_post_count'] ?? 0,
      location: LocationAddressWithLatLng.fromMap(map['location']),
      blockedByAdmin: map["blocked_by_admin"],
      blockedByUser: map["blocked_by_user"],
      pageMemberCount: map["page_member_count"] ?? 0,
      //isVerified: map["is_verified"] ?? false,
    );
  }

  //search keyword:
  /// Returns true if the search query matches the page name or description.
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }

    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    return pageName.toLowerCase().contains(lowerCaseSearchQuery) ||
        pageDescription.toLowerCase().contains(lowerCaseSearchQuery);
  }
}
