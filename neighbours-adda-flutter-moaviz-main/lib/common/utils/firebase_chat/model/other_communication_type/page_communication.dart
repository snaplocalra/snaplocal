//Job post
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/logic/page_details/page_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/repository/page_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_list_tile_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_post_details_bg.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_contact_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/firebase_chat_user_shimmer.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/other_communication_details_display.dart';

class PageCommunicationImpl extends OtherCommunicationPost {
  final String pageName;
  final String pageAdminId;

  PageCommunicationImpl({
    required super.id,
    required this.pageName,
    required this.pageAdminId,
  }) : super(
          otherCommunicationType: OtherCommunicationType.page,
          displayName: pageName,
        );

  @override
  String get displayName => pageName;

  factory PageCommunicationImpl.fromMap(Map<String, dynamic> json) =>
      PageCommunicationImpl(
        id: json["id"],
        pageName: json["page_name"],
        pageAdminId: json["page_admin_id"],
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'other_communication_type': otherCommunicationType.value,
      'page_name': pageName,
      'page_admin_id': pageAdminId,
    };
  }

  @override
  PageCommunicationModel createCommunication({
    required String communicationId,
    required List<String> users,
    required List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics,
  }) {
    return PageCommunicationModel(
      otherCommunicationPost: this,
      communicationId: communicationId,
      users: users,
      communicationUsersAnalytics: communicationUsersAnalytics,
    );
  }

  @override
  Widget buildDetails(BuildContext context) {
    return BlocProvider(
      create: (context) => PageDetailsCubit(PageDetailsRepository())
        ..fetchPageDetails(pageId: id),
      child: BlocBuilder<PageDetailsCubit, PageDetailsState>(
        builder: (context, state) {
          if (state.error != null) {
            return const SizedBox.shrink();
          } else if (state.dataLoading || state.pageDetailsModel == null) {
            return const OtherPostDetailsBG(
              child: OtherCommunicationDisplayShimmer(height: 80),
            );
          } else {
            final pageDetails = state.pageDetailsModel!.pageProfileDetailsModel;
            return pageDetails.isPageAdmin
                ? OtherPostDetailsBG(
                    child: PageListTileWidget(
                      key: ValueKey(pageDetails.id),
                      pageName: pageDetails.name,
                      isVerified: pageDetails.isVerified,
                      pageDescription: pageDetails.description,
                      pageId: pageDetails.id,
                      pageImageUrl: pageDetails.coverImage,
                      isPageAdmin: pageDetails.isPageAdmin,
                      isBlockByUser: pageDetails.blockedByUser,
                      isBlockByAdmin: pageDetails.blockedByAdmin,
                      unSeenPostCount: 0,
                      isFollowing: false,
                    ),
                  )
                : const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  Widget buildContactDetails(BuildContext context, Widget placeHolder) {
    return BlocProvider(
      create: (context) => PageDetailsCubit(PageDetailsRepository())
        ..fetchPageDetails(pageId: id),
      child: BlocBuilder<PageDetailsCubit, PageDetailsState>(
        builder: (context, state) {
          if (state.error != null) {
            return placeHolder;
          } else if (state.dataLoading || state.pageDetailsModel == null) {
            return const FirebaseUserShimmer();
          } else {
            final pageDetails = state.pageDetailsModel!.pageProfileDetailsModel;
            return pageDetails.isPageAdmin
                ? placeHolder
                : ChatScreenContactWidget(
                    key: ValueKey(pageDetails.id),
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        PageDetailsScreen.routeName,
                        queryParameters: {'id': pageDetails.id},
                      );
                    },
                    name: pageDetails.name,
                    image: pageDetails.coverImage,
                  );
          }
        },
      ),
    );
  }

//copy with method
  @override
  PageCommunicationImpl copyWith({String? id, String? displayName}) {
    return PageCommunicationImpl(
      id: id ?? this.id,
      pageName: displayName ?? pageName,
      pageAdminId: pageAdminId,
    );
  }
}

class PageCommunicationModel extends OtherCommunicationModel {
  final OtherCommunicationPost _pagePostImpl;

  PageCommunicationModel({
    required super.otherCommunicationPost,
    required super.communicationId,
    required super.users,
    super.isLastMessageDeleted,
    super.lastMessage,
    required super.communicationUsersAnalytics,
  }) : _pagePostImpl = otherCommunicationPost;

  @override
  OtherCommunicationPost get otherCommunicationPost => _pagePostImpl;

  //from map
  factory PageCommunicationModel.fromMap(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final communicationModel =
        CommunicationModel.fromMap(json, currentUserId: currentUserId);

    return PageCommunicationModel(
      otherCommunicationPost:
          PageCommunicationImpl.fromMap(json['other_communication_details']),
      communicationId: communicationModel.communicationId,
      users: communicationModel.users,
      isLastMessageDeleted: communicationModel.isLastMessageDeleted,
      lastMessage: communicationModel.lastMessage,
      communicationUsersAnalytics:
          communicationModel.communicationUsersAnalytics,
    );
  }

  //copy with
  @override
  PageCommunicationModel copyWith({
    OtherCommunicationPost? otherCommunicationPost,
    String? communicationId,
    List<String>? users,
    bool? isLastMessageDeleted,
    ConversationModel? lastMessage,
    List<CommunicationUsersAnalyticsModel>? communicationUsersAnalytics,
  }) {
    return PageCommunicationModel(
      otherCommunicationPost: otherCommunicationPost ?? _pagePostImpl,
      communicationId: communicationId ?? this.communicationId,
      users: users ?? this.users,
      isLastMessageDeleted: isLastMessageDeleted ?? this.isLastMessageDeleted,
      lastMessage: lastMessage ?? this.lastMessage,
      communicationUsersAnalytics:
          communicationUsersAnalytics ?? this.communicationUsersAnalytics,
    );
  }
}
