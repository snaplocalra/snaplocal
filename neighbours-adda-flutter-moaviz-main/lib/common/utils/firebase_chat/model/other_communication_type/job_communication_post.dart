//Job post
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/logic/jobs_details/jobs_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/repository/jobs_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/screen/jobs_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_card_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_post_details_bg.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/other_communication_details_display.dart';

class JobCommunicationPost extends OtherCommunicationPost {
  final String jobDesignation;

  JobCommunicationPost({
    required super.id,
    required this.jobDesignation,
  }) : super(
          otherCommunicationType: OtherCommunicationType.job,
          displayName: jobDesignation,
        );

  @override
  String get displayName => jobDesignation;

  factory JobCommunicationPost.fromMap(Map<String, dynamic> json) =>
      JobCommunicationPost(
        id: json["id"],
        jobDesignation: json["job_designation"],
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'other_communication_type': otherCommunicationType.value,
      'job_designation': jobDesignation,
    };
  }

  @override
  JobCommunicationModel createCommunication({
    required String communicationId,
    required List<String> users,
    required List<CommunicationUsersAnalyticsModel> communicationUsersAnalytics,
  }) {
    return JobCommunicationModel(
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
        create: (context) => JobDetailsCubit(JobsDetailsRepository())
          ..fetchJobDetails(jobId: id),
        child: BlocBuilder<JobDetailsCubit, JobDetailsState>(
          builder: (context, state) {
            if (state.error != null) {
              return const SizedBox.shrink();
            } else if (state.dataLoading) {
              return const OtherCommunicationDisplayShimmer(height: 60);
            } else {
              final jobDetails = state.jobDetailModel;
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        JobDetailsScreen.routeName,
                        queryParameters: {
                          'id': jobDetails.id,
                          'job_title': jobDetails.jobDesignation,
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: JobCardWidget(
                        jobImage: jobDetails!.media.isNotEmpty
                            ? jobDetails.media.first.mediaUrl
                            : null,
                        jobDesignation: jobDetails.jobDesignation,
                        companyName: jobDetails.companyName,
                      ),
                    ),
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
  JobCommunicationPost copyWith({
    String? id,
    OtherCommunicationType? otherCommunicationType,
    String? displayName,
  }) {
    return JobCommunicationPost(
      id: id ?? this.id,
      jobDesignation: displayName ?? jobDesignation,
    );
  }
}

class JobCommunicationModel extends OtherCommunicationModel {
  final OtherCommunicationPost _jobPostImpl;

  JobCommunicationModel({
    required super.otherCommunicationPost,
    required super.communicationId,
    required super.users,
    super.isLastMessageDeleted,
    super.lastMessage,
    required super.communicationUsersAnalytics,
  }) : _jobPostImpl = otherCommunicationPost;

  @override
  OtherCommunicationPost get otherCommunicationPost => _jobPostImpl;

  factory JobCommunicationModel.fromMap(
    Map<String, dynamic> map, {
    String? currentUserId,
  }) {
    final communicationModel =
        CommunicationModel.fromMap(map, currentUserId: currentUserId);

    return JobCommunicationModel(
      otherCommunicationPost:
          JobCommunicationPost.fromMap(map['other_communication_details']),
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
  JobCommunicationModel copyWith({
    OtherCommunicationPost? otherCommunicationPost,
    String? communicationId,
    List<String>? users,
    bool? isLastMessageDeleted,
    ConversationModel? lastMessage,
    List<CommunicationUsersAnalyticsModel>? communicationUsersAnalytics,
  }) {
    return JobCommunicationModel(
      otherCommunicationPost: otherCommunicationPost ?? _jobPostImpl,
      communicationId: communicationId ?? this.communicationId,
      users: users ?? this.users,
      isLastMessageDeleted: isLastMessageDeleted ?? this.isLastMessageDeleted,
      lastMessage: lastMessage ?? this.lastMessage,
      communicationUsersAnalytics:
          communicationUsersAnalytics ?? this.communicationUsersAnalytics,
    );
  }
}
