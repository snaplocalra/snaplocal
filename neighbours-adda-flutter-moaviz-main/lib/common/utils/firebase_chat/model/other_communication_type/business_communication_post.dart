//Job post
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/logic/business_details/business_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/repository/business_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/screen/business_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/business_short_details_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_post_details_bg.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/other_communication_details_display.dart';

class BusinessCommunicationPost extends OtherCommunicationPost {
  final String businessName;

  BusinessCommunicationPost({
    required super.id,
    required this.businessName,
  }) : super(
          otherCommunicationType: OtherCommunicationType.business,
          displayName: businessName,
        );

  @override
  String get displayName => businessName;

  factory BusinessCommunicationPost.fromMap(Map<String, dynamic> json) =>
      BusinessCommunicationPost(
        id: json["id"],
        businessName: json["business_name"],
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'other_communication_type': otherCommunicationType.value,
      'business_name': businessName,
    };
  }

  @override
  BusinessPostCommunicationModel createCommunication({
    required String communicationId,
    required List<String> users,
    required List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics,
  }) {
    return BusinessPostCommunicationModel(
      otherCommunicationPost: this,
      communicationId: communicationId,
      users: users,
      communicationUsersAnalytics: communicationUsersAnalytics,
    );
  }

  @override
  Widget buildDetails(BuildContext context) {
    return OtherPostDetailsBG(
      child: BlocProvider(
        create: (context) => BusinessDetailsCubit(BusinessDetailsRepository())
          ..fetchBusinessDetails(id),
        child: BlocBuilder<BusinessDetailsCubit, BusinessDetailsState>(
          builder: (context, state) {
            if (state.error != null) {
              return const SizedBox.shrink();
            } else if (state.dataLoading) {
              return const OtherCommunicationDisplayShimmer(height: 100);
            } else {
              final business = state.businessDetailsModel!;

              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                      BusinessDetailsScreen.routeName,
                      queryParameters: {'id': business.id});
                },
                child: BusinessShortDetailsWidget(
                  businessId: business.id,
                  businessName: business.businessName,
                  businessCategory: business.category.selectedCategories
                      .map((e) => e.name)
                      .join(","),
                  businessAddress: business.postLocation.address,
                  distance: business.distance,
                  businessMedia: business.media.first,
                  ratings: business.ratingsModel.starRating,
                  unbeatableDeal: false,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget buildContactDetails(BuildContext context, Widget placeHolder) {
    return placeHolder;
  }

  @override
  OtherCommunicationPost copyWith({
    String? id,
    OtherCommunicationType? otherCommunicationType,
    String? displayName,
  }) {
    return BusinessCommunicationPost(
      id: id ?? this.id,
      businessName: displayName ?? businessName,
    );
  }
}

class BusinessPostCommunicationModel extends OtherCommunicationModel {
  final OtherCommunicationPost _businessPostImpl;

  BusinessPostCommunicationModel({
    required super.otherCommunicationPost,
    required super.communicationId,
    required super.users,
    super.isLastMessageDeleted,
    super.lastMessage,
    required super.communicationUsersAnalytics,
  }) : _businessPostImpl = otherCommunicationPost;

  @override
  OtherCommunicationPost get otherCommunicationPost => _businessPostImpl;

  factory BusinessPostCommunicationModel.fromMap(
    Map<String, dynamic> map, {
    String? currentUserId,
  }) {
    final communicationModel =
        CommunicationModel.fromMap(map, currentUserId: currentUserId);

    return BusinessPostCommunicationModel(
      otherCommunicationPost:
          BusinessCommunicationPost.fromMap(map['other_communication_details']),
      communicationId: communicationModel.communicationId,
      users: communicationModel.users,
      isLastMessageDeleted: communicationModel.isLastMessageDeleted,
      lastMessage: communicationModel.lastMessage,
      communicationUsersAnalytics:
          communicationModel.communicationUsersAnalytics,
    );
  }

//copy with method

  @override
  BusinessPostCommunicationModel copyWith({
    OtherCommunicationPost? otherCommunicationPost,
    String? communicationId,
    List<String>? users,
    bool? isLastMessageDeleted,
    ConversationModel? lastMessage,
    List<CommunicationUsersAnalyticsModel>? communicationUsersAnalytics,
  }) {
    return BusinessPostCommunicationModel(
      otherCommunicationPost: otherCommunicationPost ?? _businessPostImpl,
      communicationId: communicationId ?? this.communicationId,
      users: users ?? this.users,
      isLastMessageDeleted: isLastMessageDeleted ?? this.isLastMessageDeleted,
      lastMessage: lastMessage ?? this.lastMessage,
      communicationUsersAnalytics:
          communicationUsersAnalytics ?? this.communicationUsersAnalytics,
    );
  }
}
