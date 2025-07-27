// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/business_communication_post.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/job_communication_post.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/news_channel_communication_post.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/page_communication.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/sales_communication_post.dart';

abstract class OtherCommunicationModel extends CommunicationModel {
  final OtherCommunicationPost otherCommunicationPost;
  OtherCommunicationModel({
    required this.otherCommunicationPost,
    required super.communicationId,
    required super.users,
    super.isLastMessageDeleted,
    super.lastMessage,
    required super.communicationUsersAnalytics,
  });

  // Factory method to create a other communication model map by type
  factory OtherCommunicationModel.fromMap(Map<String, dynamic> json,
      {String? currentUserId}) {
    final otherCommunicationType = OtherCommunicationType.fromString(
        json['other_communication_details']['other_communication_type']);
    switch (otherCommunicationType) {
      case OtherCommunicationType.salesPost:
        return SalesPostCommunicationModel.fromMap(json);
      case OtherCommunicationType.job:
        return JobCommunicationModel.fromMap(json);
      case OtherCommunicationType.business:
        return BusinessPostCommunicationModel.fromMap(json);
      case OtherCommunicationType.page:
        return PageCommunicationModel.fromMap(json);
      case OtherCommunicationType.newsChannel:
        return NewsCommunicationModel.fromMap(json);
      default:
        throw Exception("Unknown post type: $otherCommunicationType");
    }
  }

  //toMap
  @override
  Map<String, dynamic> toMap() {
    final dataMap = <String, dynamic>{
      ...super.toMap(),
      'other_communication_details': otherCommunicationPost.toMap(),
    };

    return dataMap;
  }

  //copy with method
  OtherCommunicationModel copyWith({
    String? communicationId,
    List<String>? users,
    bool? isLastMessageDeleted,
    ConversationModel? lastMessage,
    List<CommunicationUsersAnalyticsModel>? communicationUsersAnalytics,
    OtherCommunicationPost? otherCommunicationPost,
  });
}

//This class is used to create both sales post and job communication
abstract class OtherCommunicationPost
    implements OtherCommunicationWidgetRender {
  final String id;
  final OtherCommunicationType otherCommunicationType;
  final String displayName;

  OtherCommunicationPost({
    required this.otherCommunicationType,
    required this.id,
    required this.displayName,
  });

  //toMap
  Map<String, dynamic> toMap();

  ///create communication model based on the communication post
  //create a new communication model and add OtherCommunicationPost with List<CommunicationUsersAnalyticsModel>, Communication id and required List<String> users
  OtherCommunicationModel createCommunication({
    required String communicationId,
    required List<String> users,
    required List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics,
  });

  factory OtherCommunicationPost.createTypeWise({
    required String id,
    required String displayName,
    required OtherCommunicationType otherCommunicationType,
  }) {
    switch (otherCommunicationType) {
      case OtherCommunicationType.salesPost:
        return SalesCommunicationPost(id: id, itemName: displayName);
      case OtherCommunicationType.job:
        return JobCommunicationPost(id: id, jobDesignation: displayName);
      case OtherCommunicationType.business:
        return BusinessCommunicationPost(id: id, businessName: displayName);
      case OtherCommunicationType.page:
        return PageCommunicationImpl(
            id: id, pageName: displayName, pageAdminId: '');
      case OtherCommunicationType.newsChannel:
        return NewsChannelCommunicationImpl(
            id: id, newsChannelName: displayName);
      default:
        throw Exception("Unknown post type: $otherCommunicationType");
    }
  }

//copy with method
  OtherCommunicationPost copyWith({String? id, String? displayName});
}

abstract class OtherCommunicationWidgetRender {
  ///build details
  Widget buildDetails(BuildContext context);

  ///build contact details
  Widget buildContactDetails(BuildContext context, Widget placeHolder);
}

enum OtherCommunicationType {
  salesPost("sales_post"),
  business("business"),
  job("job"),
  newsChannel("news_channel"),
  page("page");

  final String value;
  const OtherCommunicationType(this.value);

  static OtherCommunicationType fromString(String type) {
    switch (type) {
      case 'sales_post':
        return salesPost;
      case 'job':
        return job;
      case 'business':
        return business;
      case 'page':
        return page;
      case 'news_channel':
        return newsChannel;
      default:
        throw Exception("Unknown other communication type: $type");
    }
  }
}
