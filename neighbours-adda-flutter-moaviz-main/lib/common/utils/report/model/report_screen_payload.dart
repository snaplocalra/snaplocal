import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';

abstract class ReportScreenPayload {
  final ReportType reportType;
  final ReportCubit reportCubit;
  final String submitApi;

  Map<String, dynamic> payloadMap();

  ReportScreenPayload({
    required this.reportType,
    required this.reportCubit,
    required this.submitApi,
  });
}

const String _generalReportApi = 'v2/common/report_general_post';

String _socialReportApi = 'v2/common/report_social_post';

//Business details report payload
class BusinessDetailsReportPayload implements ReportScreenPayload {
  final String businessId;
  @override
  final ReportCubit reportCubit;

  BusinessDetailsReportPayload({
    required this.businessId,
    required this.reportCubit,
  });

  @override
  final String submitApi = _generalReportApi;

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': businessId,
    };
  }

  @override
  ReportType get reportType => ReportType.business;
}

//Group report payload
class GroupReportPayload implements ReportScreenPayload {
  final String groupId;

  @override
  final ReportCubit reportCubit;

  GroupReportPayload({
    required this.groupId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': groupId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.group;
}

//Sales post report payload
class SalesPostReportPayload implements ReportScreenPayload {
  final String salesPostId;

  @override
  final ReportCubit reportCubit;

  SalesPostReportPayload({
    required this.salesPostId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': salesPostId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.market;
}

//event report payload
class EventReportPayload implements ReportScreenPayload {
  final String eventId;

  @override
  final ReportCubit reportCubit;

  EventReportPayload({
    required this.eventId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': eventId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.event;
}

//Jobs report payload
class JobsReportPayload implements ReportScreenPayload {
  final String jobId;

  @override
  final ReportCubit reportCubit;

  JobsReportPayload({
    required this.jobId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': jobId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.job;
}

//page report payload
class PageReportPayload implements ReportScreenPayload {
  final String pageId;

  @override
  final ReportCubit reportCubit;

  PageReportPayload({
    required this.pageId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': pageId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.page;
}

//owner activity report payload
class OwnerActivityReportPayload implements ReportScreenPayload {
  final String userId;

  @override
  final ReportCubit reportCubit;

  OwnerActivityReportPayload({
    required this.userId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': userId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.neighboursProfile;
}

//chat report payload
class ChatReportPayload implements ReportScreenPayload {
  final String userId;

  @override
  final ReportCubit reportCubit;

  ChatReportPayload({
    required this.userId,
    required this.reportCubit,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': userId,
    };
  }

  @override
  final String submitApi = _generalReportApi;

  @override
  ReportType get reportType => ReportType.chat;
}

//Social report payload
class SocialPostReportPayload implements ReportScreenPayload {
  final String postId;
  final PostFrom postFrom;
  final PostType postType;
  @override
  final ReportType reportType;

  @override
  final ReportCubit reportCubit;

  SocialPostReportPayload({
    required this.postId,
    required this.reportCubit,
    required this.postFrom,
    required this.postType,
    required this.reportType,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': postId,
      'post_from': postFrom.jsonName,
      'post_type': postType.param,
    };
  }

  @override
  final String submitApi = _socialReportApi;
}

//Comment report payload
class CommentReportPayload implements ReportScreenPayload {
  final String parentCommentId;
  final String? childCommentId;
  final PostFrom postFrom;
  final PostType postType;
  final String postId;
  @override
  final ReportType reportType = ReportType.comment;

  @override
  final ReportCubit reportCubit;

  CommentReportPayload({
    required this.parentCommentId,
    required this.childCommentId,
    required this.reportCubit,
    required this.postFrom,
    required this.postType,
    required this.postId,
  });

  @override
  Map<String, dynamic> payloadMap() {
    return {
      'report_type': reportType.jsonName,
      'post_id': postId,
      'post_from': postFrom.jsonName,
      'post_type': postType.param,
      'parent_comment_id': parentCommentId,
      'child_comment_id': childCommentId,
    };
  }

  @override
  final String submitApi = _socialReportApi;
}
