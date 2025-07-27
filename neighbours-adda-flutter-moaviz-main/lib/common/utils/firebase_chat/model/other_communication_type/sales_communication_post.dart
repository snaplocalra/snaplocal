//Sales post
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/logic/sales_post_details/sales_post_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/repository/sales_post_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/widgets/sales_post_card_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_post_details_bg.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/firebase_chat_user_shimmer.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';

class SalesCommunicationPost extends OtherCommunicationPost {
  final String itemName;

  SalesCommunicationPost({
    required super.id,
    required this.itemName,
  }) : super(
          otherCommunicationType: OtherCommunicationType.salesPost,
          displayName: itemName,
        );

  @override
  String get displayName => itemName;

  factory SalesCommunicationPost.fromMap(Map<String, dynamic> json) =>
      SalesCommunicationPost(
        id: json["id"],
        itemName: json["item_name"],
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'item_name': itemName,
        'other_communication_type': otherCommunicationType.value,
      };

  @override
  SalesPostCommunicationModel createCommunication({
    required String communicationId,
    required List<String> users,
    required List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics,
  }) {
    return SalesPostCommunicationModel(
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
        create: (context) => SalesPostDetailsCubit(SalesPostDetailsRepository())
          ..fetchSalesPostDetails(id),
        child: BlocBuilder<SalesPostDetailsCubit, SalesPostDetailsState>(
          builder: (context, state) {
            if (state.error != null) {
              return const SizedBox.shrink();
            } else if (state.dataLoading) {
              return const FirebaseUserShimmer();
            } else {
              final salesPost = state.salesPostDetailModel;
              return BlocProvider(
                create: (context) => PostActionCubit(PostActionRepository()),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SalesPostCardWidget(
                    media: salesPost!.media.first,
                    id: salesPost.id,
                    title: salesPost.name,
                    category: salesPost.category.subCategory.name,
                    address: salesPost.postLocation.address,
                    distance: salesPost.distance,
                    price: salesPost.price,
                  ),
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

  //copy with method
  @override
  SalesCommunicationPost copyWith({String? id, String? displayName}) {
    return SalesCommunicationPost(
      id: id ?? super.id,
      itemName: displayName ?? itemName,
    );
  }
}

class SalesPostCommunicationModel extends OtherCommunicationModel {
  final OtherCommunicationPost _salesPostDetailsImpl;

  SalesPostCommunicationModel({
    required super.otherCommunicationPost,
    required super.communicationId,
    required super.users,
    super.isLastMessageDeleted,
    super.lastMessage,
    required super.communicationUsersAnalytics,
  }) : _salesPostDetailsImpl = otherCommunicationPost;

  @override
  OtherCommunicationPost get otherCommunicationPost => _salesPostDetailsImpl;

  factory SalesPostCommunicationModel.fromMap(
    Map<String, dynamic> map, {
    String? currentUserId,
  }) {
    final communicationModel =
        CommunicationModel.fromMap(map, currentUserId: currentUserId);

    return SalesPostCommunicationModel(
      otherCommunicationPost:
          SalesCommunicationPost.fromMap(map['other_communication_details']),
      communicationUsersAnalytics:
          communicationModel.communicationUsersAnalytics,
      communicationId: communicationModel.communicationId,
      users: communicationModel.users,
      isLastMessageDeleted: communicationModel.isLastMessageDeleted,
      lastMessage: communicationModel.lastMessage,
    );
  }

  @override
  SalesPostCommunicationModel copyWith({
    OtherCommunicationPost? otherCommunicationPost,
    String? communicationId,
    List<String>? users,
    bool? isLastMessageDeleted,
    ConversationModel? lastMessage,
    List<CommunicationUsersAnalyticsModel>? communicationUsersAnalytics,
  }) {
    return SalesPostCommunicationModel(
      otherCommunicationPost: otherCommunicationPost ?? _salesPostDetailsImpl,
      communicationId: communicationId ?? super.communicationId,
      users: users ?? super.users,
      isLastMessageDeleted: isLastMessageDeleted ?? super.isLastMessageDeleted,
      lastMessage: lastMessage ?? super.lastMessage,
      communicationUsersAnalytics:
          communicationUsersAnalytics ?? super.communicationUsersAnalytics,
    );
  }
}
