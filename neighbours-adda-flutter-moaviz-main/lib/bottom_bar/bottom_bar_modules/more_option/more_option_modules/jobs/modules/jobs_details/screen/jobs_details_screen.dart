import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/logic/jobs_details/jobs_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/repository/jobs_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/widget/job_additional_details_card_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/widget/job_description_point.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/widget/near_by_jobs_recommendation.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/screen/manage_jobs_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_card_widget.dart';
import 'package:snap_local/common/market_places/interested_people_list/screen/interested_people_list_screen.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';
import 'package:snap_local/common/market_places/owner_activity_details/screen/owner_acitvity_details_screen.dart';
import 'package:snap_local/common/market_places/send_message_to_neighbours.dart';
import 'package:snap_local/common/market_places/widgets/post_owner_details.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_button.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/model/scam_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/job_communication_post.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/models/post_action_type_enum.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/delete_dialog.dart';
import 'package:snap_local/common/utils/widgets/square_border_svg_button.dart';
import 'package:snap_local/utility/common/read_more/widget/read_more_text.dart';
import 'package:snap_local/utility/common/widgets/custom_tool_tip.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;
  final String? jobTitle;
  final bool openEditScreen;
  final JobShortViewControllerCubit? jobShortViewControllerCubit;
  static const routeName = 'job_details';

  const JobDetailsScreen({
    super.key,
    required this.jobId,
    this.jobTitle,
    required this.openEditScreen,
    this.jobShortViewControllerCubit,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late JobDetailsCubit jobDetailsCubit =
      JobDetailsCubit(JobsDetailsRepository());
  late ReportCubit reportCubit = ReportCubit(ReportRepository());

  late PostActionCubit postActionCubit =
      widget.jobShortViewControllerCubit?.state.postActionCubit ??
          PostActionCubit(PostActionRepository());

  bool allowAutoEditScreenOpen = false;
  late String appBarTitle;

  ///Update on the short details list widget
  void updateShortDetailsBookMark(bool status) {
    if (widget.jobShortViewControllerCubit != null) {
      widget.jobShortViewControllerCubit!.updatePostSaveStatus(status);
    }
  }

  @override
  void initState() {
    super.initState();
    appBarTitle = widget.jobTitle ?? "";
    allowAutoEditScreenOpen = widget.openEditScreen;
    //Fetch Job details
    jobDetailsCubit.fetchJobDetails(jobId: widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    // final mqSize = MediaQuery.sizeOf(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: jobDetailsCubit),
        BlocProvider.value(value: reportCubit),
        BlocProvider.value(value: postActionCubit),
      ],
      child: BlocConsumer<JobDetailsCubit, JobDetailsState>(
        listener: (context, jobDetailsState) {
          if (jobDetailsState.isJobDetailAvailable) {
            appBarTitle = jobDetailsState.jobDetailModel!.companyName;

            if (allowAutoEditScreenOpen) {
              GoRouter.of(context)
                  .pushNamed(
                ManageJobsScreen.routeName,
                extra: jobDetailsState.jobDetailModel,
              )
                  .then((allowRefreshData) {
                //once edit screen opened, false the condition
                allowAutoEditScreenOpen = false;

                if (allowRefreshData != null &&
                    allowRefreshData == true &&
                    context.mounted) {
                  context
                      .read<JobDetailsCubit>()
                      .fetchJobDetails(jobId: widget.jobId);
                }
              });
            }
          }
        },
        builder: (context, jobDetailsState) {
          final jobDetails = jobDetailsState.jobDetailModel;
          return Scaffold(
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                (jobDetailsState.isJobDetailAvailable)
                    ? Row(
                        children: [
                          //Book mark
                          BlocConsumer<PostActionCubit, PostActionState>(
                            listener: (context, postActionState) {
                              if (postActionState.isRequestFailed) {
                                //Reverse the status
                                context
                                    .read<JobDetailsCubit>()
                                    .updatePostSaveStatus(!jobDetails!.isSaved);
                                updateShortDetailsBookMark(!jobDetails.isSaved);
                              }
                            },
                            builder: (context, postActionState) {
                              return CircularSvgButton(
                                svgImage: jobDetails!.isSaved
                                    ? SVGAssetsImages.saved
                                    : SVGAssetsImages.unSaved,
                                iconColor: Colors.white,
                                backgroundColor:
                                    ApplicationColours.themeLightPinkColor,
                                onTap: postActionState.isSaveRequestLoading
                                    ? null
                                    : () {
                                        context
                                            .read<PostActionCubit>()
                                            .saveUnsavePost(
                                              postId: jobDetails.id,
                                              postActionType:
                                                  PostActionType.job,
                                            );
                                        context
                                            .read<JobDetailsCubit>()
                                            .updatePostSaveStatus(
                                                !jobDetails.isSaved);

                                        updateShortDetailsBookMark(
                                            !jobDetails.isSaved);
                                      },
                              );
                            },
                          ),
                          //Only post admin can edit the post details
                          if (jobDetails!.isPostAdmin)
                            CircularSvgButton(
                              svgImage: SVGAssetsImages.edit,
                              iconColor: Colors.white,
                              backgroundColor:
                                  ApplicationColours.themeLightPinkColor,
                              onTap: () {
                                GoRouter.of(context)
                                    .pushNamed(
                                      ManageJobsScreen.routeName,
                                      extra: jobDetails,
                                    )
                                    .whenComplete(
                                      () => context
                                          .read<JobDetailsCubit>()
                                          .fetchJobDetails(jobId: widget.jobId),
                                    );
                              },
                            ),
                          if (!jobDetails.isPostAdmin)
                            BlocListener<ReportCubit, ReportState>(
                              listener: (context, reportState) {
                                if (reportState.requestSuccess) {
                                  //refresh the job details
                                  // context
                                  //     .read<JobDetailsCubit>()
                                  //     .fetchJobDetails(jobId: widget.jobId);

                                  //pop the screen
                                  GoRouter.of(context).pop();
                                }
                              },
                              child: CustomToolTip(
                                message: jobDetails.reportedByUser
                                    ? tr(LocaleKeys.youalreadyreportedthispost)
                                    : tr(LocaleKeys.reportThisPost),
                                triggerMode: jobDetails.reportedByUser
                                    ? TooltipTriggerMode.tap
                                    : TooltipTriggerMode.longPress,
                                child: CircularSvgButton(
                                  svgImage: SVGAssetsImages.report,
                                  iconColor: Colors.white,
                                  iconSize: 18,
                                  backgroundColor: jobDetails.reportedByUser
                                      ? Colors.grey
                                      : ApplicationColours.themeLightPinkColor,
                                  onTap: jobDetails.reportedByUser
                                      ? null
                                      : () {
                                          GoRouter.of(context).pushNamed(
                                            ReportScreen.routeName,
                                            extra: JobsReportPayload(
                                              jobId: jobDetails.id,
                                              reportCubit:
                                                  context.read<ReportCubit>(),
                                            ),
                                          );
                                        },
                                ),
                              ),
                            ),

                          CircularSvgButton(
                            svgImage: SVGAssetsImages.allowSharing,
                            iconColor: Colors.white,
                            iconSize: 18,
                            backgroundColor:
                                ApplicationColours.themeLightPinkColor,
                            onTap: () {
                              context.read<ShareCubit>().generalShare(
                                    context,
                                    data: jobDetails.id,
                                    screenURL: JobDetailsScreen.routeName,
                                    shareSubject:
                                        tr(LocaleKeys.checkOutThisJob),
                                  );
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            body: (jobDetailsState.error != null)
                ? ErrorTextWidget(error: jobDetailsState.error!)
                : (jobDetailsState.dataLoading ||
                        !jobDetailsState.isJobDetailAvailable)
                    ? const ThemeSpinner(size: 35)
                    : RefreshIndicator.adaptive(
                        onRefresh: () => context
                            .read<JobDetailsCubit>()
                            .fetchJobDetails(jobId: widget.jobId),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            // Job card
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(bottom: 4),
                              child: JobCardWidget(
                                jobImage: jobDetails!.media.isNotEmpty
                                    ? jobDetails.media.first.mediaUrl
                                    : null,
                                imageRadius: 35,
                                companyName: jobDetails.companyName,
                                companyNameFontSize: 16,
                                jobDesignation: jobDetails.jobDesignation,
                                jobDesignationFontSize: 20,
                              ),
                            ),

                            // Additional job details
                            Container(
                              color: Colors.white,
                              child: JobAdditionalDetailsCardWidget(
                                minWorkExperience: jobDetails.minWorkExperience,
                                maxWorkExperience: jobDetails.maxWorkExperience,
                                minSalary: jobDetails.minSalary,
                                maxSalary: jobDetails.maxSalary,
                                workLocation: jobDetails.workLocation,
                                skills: jobDetails.skills,
                                distance: jobDetails.distance,
                                createdAt: jobDetails.createdAt,
                                suffixWidget: jobDetails.isPostAdmin
                                    ? GestureDetector(
                                        onTap: jobDetails
                                                    .interestedPeopleCount >
                                                0
                                            ? () {
                                                GoRouter.of(context).pushNamed(
                                                  InterestedPeopleListScreen
                                                      .routeName,
                                                  queryParameters: {
                                                    'id': jobDetails.id,
                                                  },
                                                  extra: MarketPlaceType.job,
                                                );
                                              }
                                            : null,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color.fromRGBO(
                                                226, 233, 255, 1),
                                          ),
                                          child: Text(
                                            "${jobDetails.interestedPeopleCount.formatNumber()} ${tr(LocaleKeys.interested)}",
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),

                            // Jobs description
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LocaleKeys.jobDescription),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  ReadMoreText(
                                    jobDetails.jobDescription,
                                    readLessLine: 5,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(35, 32, 31, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Job type
                                  JobDescriptionPointWidget(
                                    svgImage: SVGAssetsImages.jobType,
                                    title: "${tr(LocaleKeys.jobType)} :",
                                    value: jobDetails.jobType.displayValue,
                                  ),

                                  //work type
                                  JobDescriptionPointWidget(
                                    svgImage: SVGAssetsImages.workType,
                                    title: "${tr(LocaleKeys.workType)} :",
                                    value: jobDetails.workType.displayValue,
                                  ),

                                  //job industry
                                  JobDescriptionPointWidget(
                                    svgImage: SVGAssetsImages.industry,
                                    title: "${tr(LocaleKeys.jobIndustry)} :",
                                    value: jobDetails.category.subCategory.name,
                                  ),

                                  //job qualification
                                  if (jobDetails.jobQualification.isNotEmpty)
                                    JobDescriptionPointWidget(
                                      svgImage: SVGAssetsImages.qualification,
                                      title:
                                          "${tr(LocaleKeys.jobQualification)} :",
                                      value: jobDetails.jobQualification,
                                    ),

                                  //Number of positions
                                  if (jobDetails.numberOfPositions > 0)
                                    JobDescriptionPointWidget(
                                      svgImage: SVGAssetsImages.jobPosition,
                                      title: tr(LocaleKeys.numberOfPositions),
                                      value: jobDetails.numberOfPositions
                                          .toString(),
                                    ),
                                ],
                              ),
                            ),

                            //Analytics Overview
                            if (jobDetails.isPostAdmin)
                              Container(
                                color: Colors.white,
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.all(10),
                                child: AnalyticsOverviewButton(
                                  moduleId: widget.jobId,
                                  moduleType: AnalyticsModuleType.job,
                                ),
                              ),

                            // Sender Details
                            Visibility(
                              visible: !jobDetails.isPostAdmin &&
                                  jobDetails.enableChat,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: SendMessageToNeighbours(
                                  scamType: ScamType.job,
                                  receiverUserId:
                                      jobDetails.postOwnerDetails.id,
                                  otherCommunicationModelImpl:
                                      JobCommunicationPost(
                                    id: jobDetails.id,
                                    jobDesignation: jobDetails.jobDesignation,
                                  ),
                                ),
                              ),
                            ),

                            // Sender Details
                            Visibility(
                              visible: !jobDetails.isPostAdmin &&
                                  jobDetails.enableChat,
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Posted by
                                    Text(
                                      tr(LocaleKeys.postedBy),
                                      style: TextStyle(
                                        color:
                                            ApplicationColours.themeBlueColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    PostOwnerDetails(
                                        id: jobDetails.postOwnerDetails.id,
                                        name: jobDetails.postOwnerDetails.name,
                                        image: jobDetails.postOwnerDetails.image,
                                        address: jobDetails.postOwnerDetails.address,
                                        isVerified: jobDetails.postOwnerDetails.isVerified,
                                        postCreatedAt: jobDetails.createdAt,
                                        isOwner: jobDetails.isPostAdmin,
                                        ratingType: RatingType.job,
                                        ratingTypeId: jobDetails.id,
                                        ratingsModel: jobDetails
                                            .postOwnerDetails.ratingsModel,
                                        onProfileTap: () {
                                          GoRouter.of(context).pushNamed(
                                            OwnerActivityDetailsScreen
                                                .routeName,
                                            queryParameters: {
                                              "post_id": jobDetails.id,
                                              "app_bar_title":
                                                  jobDetails.jobDesignation,
                                            },
                                            extra: OwnerActivityType.job,
                                          );
                                        }),
                                    // Bottom spacing
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),

                            //Post action
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              child: jobDetails.isPostAdmin
                                  ? BlocConsumer<PostActionCubit,
                                      PostActionState>(
                                      listener: (context, postActionState) {
                                        if (postActionState
                                            .isDeleteRequestSuccess) {
                                          //Close the screen after delete
                                          GoRouter.of(context).pop();
                                        }
                                      },
                                      builder: (context, postActionState) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: SquareBorderSvgButton(
                                                showloading: jobDetailsState
                                                    .requestLoading,
                                                svgImage: SVGAssetsImages
                                                    .positionClosed,
                                                backgroundColor:
                                                    jobDetails.isPositionClosed
                                                        ? const Color.fromRGBO(
                                                            71, 105, 211, 1)
                                                        : Colors.grey[50],
                                                foregroundColor:
                                                    jobDetails.isPositionClosed
                                                        ? Colors.white
                                                        : ApplicationColours
                                                            .themeBlueColor,
                                                text: jobDetails
                                                        .isPositionClosed
                                                    ? tr(LocaleKeys
                                                        .markAsAvailable)
                                                    : tr(LocaleKeys
                                                        .markAsPositionFilled),
                                                onTap: postActionState
                                                        .isDeleteRequestLoading
                                                    ? null
                                                    : () {
                                                        HapticFeedback
                                                            .heavyImpact();
                                                        //Close position api call
                                                        context
                                                            .read<
                                                                JobDetailsCubit>()
                                                            .closePosition(
                                                              jobId:
                                                                  widget.jobId,
                                                            );
                                                      },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Builder(builder: (context) {
                                              return SquareBorderSvgButton(
                                                showloading: postActionState
                                                    .isDeleteRequestLoading,
                                                svgImage:
                                                    SVGAssetsImages.delete,
                                                text: tr(LocaleKeys.delete),
                                                onTap:
                                                    jobDetailsState
                                                            .requestLoading
                                                        ? null
                                                        : () async {
                                                            HapticFeedback
                                                                .heavyImpact();

                                                            await showDeleteAlertDialog(
                                                              context,
                                                              description: tr(
                                                                  LocaleKeys
                                                                      .areyousureyouwanttopermanentlyremovethispost),
                                                            ).then(
                                                              (allowDelete) {
                                                                if (allowDelete &&
                                                                    context
                                                                        .mounted) {
                                                                  //Delete post api call
                                                                  context
                                                                      .read<
                                                                          PostActionCubit>()
                                                                      .deleteMarketPlacePost(
                                                                        postId:
                                                                            jobDetails.id,
                                                                        marketPlaceType:
                                                                            MarketPlaceType.job,
                                                                      );
                                                                }
                                                              },
                                                            );
                                                          },
                                              );
                                            }),
                                          ],
                                        );
                                      },
                                    )
                                  :
                                  //Other user action
                                  Visibility(
                                      visible: !jobDetails.isPositionClosed,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: SquareBorderSvgButton(
                                              showloading: jobDetailsState
                                                  .requestLoading,
                                              svgImage: SVGAssetsImages
                                                  .applicationSubmitted,
                                              text: jobDetails.isInterested
                                                  ? tr(LocaleKeys
                                                      .clickToRemoveInterest)
                                                  : tr(LocaleKeys
                                                      .clickToShowInterest),
                                              backgroundColor:
                                                  jobDetails.isInterested
                                                      ? const Color.fromRGBO(
                                                          71, 105, 211, 1)
                                                      : Colors.grey[50],
                                              foregroundColor:
                                                  jobDetails.isInterested
                                                      ? Colors.white
                                                      : ApplicationColours
                                                          .themeBlueColor,
                                              onTap: () {
                                                context
                                                    .read<JobDetailsCubit>()
                                                    .applyJob(
                                                        jobId: widget.jobId);
                                              },
                                            ),
                                          ),
                                          Positioned(
                                              top: 5,
                                              left: 70,
                                              right: 0,
                                              child: Icon(Icons.star,
                                                  color: jobDetails.isInterested
                                                      ? Colors.yellow
                                                      : ApplicationColours
                                                          .themeBlueColor,
                                                  size: 20))
                                        ],
                                      ),
                                    ),
                            ),

                            //Job location
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: WidgetHeading(
                                      title: tr(LocaleKeys.jobLocation),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: MapWithMarker(
                                      preSelectedLatLng: LatLng(
                                        jobDetails.workLocation.latitude,
                                        jobDetails.workLocation.longitude,
                                      ),
                                      circleRadius: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Other Near By Recommendation
                            Visibility(
                              visible:
                                  jobDetails.nearByRecommendation.isNotEmpty,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: NearByJobsRecommendation(
                                  nearbyList: jobDetails.nearByRecommendation,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
