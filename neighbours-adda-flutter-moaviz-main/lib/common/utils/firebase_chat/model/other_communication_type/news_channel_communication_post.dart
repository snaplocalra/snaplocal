import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/logic/channel_overview_controller/channel_overview_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/repository/news_channel_overview_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/screen/channel_overview_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_post_details_bg.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/other_communication_details_display.dart';

class NewsChannelCommunicationImpl extends OtherCommunicationPost {
  final String newsChannelName;

  NewsChannelCommunicationImpl({
    required super.id,
    required this.newsChannelName,
  }) : super(
          otherCommunicationType: OtherCommunicationType.newsChannel,
          displayName: newsChannelName,
        );

  @override
  String get displayName => newsChannelName;

  factory NewsChannelCommunicationImpl.fromMap(Map<String, dynamic> json) =>
      NewsChannelCommunicationImpl(
        id: json["id"],
        newsChannelName: json["news_channel_name"],
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'other_communication_type': otherCommunicationType.value,
      'news_channel_name': newsChannelName,
    };
  }

  @override
  NewsCommunicationModel createCommunication({
    required String communicationId,
    required List<String> users,
    required List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics,
  }) {
    return NewsCommunicationModel(
      otherCommunicationPost: this,
      communicationId: communicationId,
      users: users,
      communicationUsersAnalytics: communicationUsersAnalytics,
    );
  }

  @override
  Widget buildContactDetails(BuildContext context, Widget placeHolder) {
    return placeHolder;
  }

  @override
  Widget buildDetails(BuildContext context) {
    return OtherPostDetailsBG(
      child: BlocProvider(
        create: (context) =>
            ChannelOverviewControllerCubit(NewsChannelOverviewRepository())
              ..getChannelOverviewData(id),
        child: BlocBuilder<ChannelOverviewControllerCubit,
            ChannelOverviewControllerState>(
          builder: (context, state) {
            if (state is ChannelOverviewControllerLoading) {
              return const OtherCommunicationDisplayShimmer(height: 100);
            } else if (state is ChannelOverviewControllerSuccess) {
              final newsChannel = state.newsChannelOverViewModel;
              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                      ChannelOverViewScreen.routeName,
                      queryParameters: {'id': id});
                },
                child: Text(
                  newsChannel.newsChannelInfoModel.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  @override
  OtherCommunicationPost copyWith({
    String? id,
    String? displayName,
  }) {
    return NewsChannelCommunicationImpl(
      id: id ?? this.id,
      newsChannelName: displayName ?? newsChannelName,
    );
  }
}

//News Communication Model
class NewsCommunicationModel extends OtherCommunicationModel {
  final OtherCommunicationPost _newsPostImpl;

  NewsCommunicationModel({
    required super.otherCommunicationPost,
    required super.communicationId,
    required super.users,
    super.isLastMessageDeleted,
    super.lastMessage,
    required super.communicationUsersAnalytics,
  }) : _newsPostImpl = otherCommunicationPost;

  @override
  OtherCommunicationPost get otherCommunicationPost => _newsPostImpl;

  factory NewsCommunicationModel.fromMap(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final communicationModel =
        CommunicationModel.fromMap(json, currentUserId: currentUserId);

    return NewsCommunicationModel(
      otherCommunicationPost: NewsChannelCommunicationImpl.fromMap(
          json['other_communication_details']),
      communicationId: communicationModel.communicationId,
      users: communicationModel.users,
      isLastMessageDeleted: communicationModel.isLastMessageDeleted,
      lastMessage: communicationModel.lastMessage,
      communicationUsersAnalytics:
          communicationModel.communicationUsersAnalytics,
    );
  }

  @override
  NewsCommunicationModel copyWith({
    OtherCommunicationPost? otherCommunicationPost,
    String? communicationId,
    List<String>? users,
    bool? isLastMessageDeleted,
    ConversationModel? lastMessage,
    List<CommunicationUsersAnalyticsModel>? communicationUsersAnalytics,
  }) {
    return NewsCommunicationModel(
      otherCommunicationPost: otherCommunicationPost ?? _newsPostImpl,
      communicationId: communicationId ?? this.communicationId,
      users: users ?? this.users,
      isLastMessageDeleted: isLastMessageDeleted ?? this.isLastMessageDeleted,
      lastMessage: lastMessage ?? this.lastMessage,
      communicationUsersAnalytics:
          communicationUsersAnalytics ?? this.communicationUsersAnalytics,
    );
  }
}
