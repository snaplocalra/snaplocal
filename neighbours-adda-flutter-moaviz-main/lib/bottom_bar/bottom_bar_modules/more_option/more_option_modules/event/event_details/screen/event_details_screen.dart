import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/screen/manage_event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/logic/event_details/event_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/repository/event_post_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/screen/event_attending_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/widget/near_by_events_recommendation.dart';
import 'package:snap_local/common/market_places/widgets/post_owner_details.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/screen/review_ratings_details.dart';
import 'package:snap_local/common/review_module/widget/give_rating_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_save_status_state.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_button.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/network_media_carousels_widget.dart';
import 'package:snap_local/common/utils/widgets/square_border_svg_button.dart';
import 'package:snap_local/common/utils/widgets/svg_elevated_button.dart';
import 'package:snap_local/common/utils/widgets/svg_text_widget.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/extension_functions/string_converter.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';
import 'package:text_scroll/text_scroll.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final PostDetailsControllerCubit? postDetailsControllerCubit;

  static const routeName = 'event_details';

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    this.postDetailsControllerCubit,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final scrollController = ScrollController();

  late EventDetailsCubit eventDetailsCubit =
      EventDetailsCubit(EventDetailsRepository());
  late ReportCubit reportCubit = ReportCubit(ReportRepository());

  ///Update on the short details list widget
  void updateShortDetailsBookMark(bool status) {
    if (widget.postDetailsControllerCubit != null) {
      widget.postDetailsControllerCubit!
          .postStateUpdate(UpdateSaveStatusState(status));
    }
  }

  @override
  void initState() {
    super.initState();

    //Fetch event details
    eventDetailsCubit.fetchEventDetails(widget.eventId);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: eventDetailsCubit),
        BlocProvider.value(value: reportCubit),
      ],
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            leading: const IOSBackButton(),
            actions: [
              BlocBuilder<EventDetailsCubit, EventDetailsState>(
                builder: (context, eventDetailsState) {
                  if (eventDetailsState.isEventPostDetailAvailable) {
                    final eventDetails =
                        eventDetailsState.eventPostDetailsModel!;
                    return Wrap(
                      children: [
                        if (eventDetails.isPostAdmin &&
                            widget.postDetailsControllerCubit != null)
                          CircularSvgButton(
                            svgImage: SVGAssetsImages.edit,
                            iconColor: Colors.white,
                            backgroundColor:
                                ApplicationColours.themeLightPinkColor,
                            onTap: () {
                              GoRouter.of(context)
                                  .pushNamed(
                                    CreateEventScreen.routeName,
                                    extra: widget.postDetailsControllerCubit,
                                  )
                                  .whenComplete(() => eventDetailsCubit
                                      .fetchEventDetails(widget.eventId));
                            },
                          ),
                        if (eventDetails.isSharingAllowed)
                          CircularSvgButton(
                            svgImage: SVGAssetsImages.allowSharing,
                            iconColor: Colors.white,
                            iconSize: 18,
                            backgroundColor:
                                ApplicationColours.themeLightPinkColor,
                            onTap: () {
                              context.read<ShareCubit>().generalShare(
                                    context,
                                    data: widget.eventId,
                                    screenURL: EventDetailsScreen.routeName,
                                    shareSubject:
                                        tr(LocaleKeys.checkoutthisevent),
                                  );
                            },
                          ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(width: 5),
            ],
            backgroundColor: Colors.transparent,
          ),
          body: BlocBuilder<EventDetailsCubit, EventDetailsState>(
            builder: (context, eventDetailsState) {
              if (eventDetailsState.error != null) {
                return ErrorTextWidget(error: eventDetailsState.error!);
              } else if (eventDetailsState.dataLoading ||
                  !eventDetailsState.isEventPostDetailAvailable) {
                return const ThemeSpinner(size: 35);
              } else {
                final eventDetail = eventDetailsState.eventPostDetailsModel!;
                return RefreshIndicator.adaptive(
                  onRefresh: () =>
                      eventDetailsCubit.fetchEventDetails(widget.eventId),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      //Media Carausel
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: NetworkMediaCarouselWidget(
                          media: eventDetail.media,
                        ),
                      ),

                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextScroll(
                                      eventDetail.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      velocity: const Velocity(
                                          pixelsPerSecond: Offset(10, 0)),
                                      delayBefore: const Duration(seconds: 2),
                                      pauseBetween: const Duration(seconds: 2),
                                      fadedBorder: true,
                                      fadedBorderWidth: 0.05,
                                      fadeBorderSide: FadeBorderSide.right,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        eventDetail.ratingsModel.totalReview >
                                            0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          //Navigate to review details screen
                                          GoRouter.of(context)
                                              .pushNamed(
                                            RatingsReviewDetailsScreen
                                                .routeName,
                                            queryParameters: {
                                              'id': eventDetail.id
                                            },
                                            extra: RatingType.event,
                                          )
                                              .whenComplete(() {
                                            if (context.mounted) {
                                              context
                                                  .read<EventDetailsCubit>()
                                                  .fetchEventDetails(
                                                      widget.eventId);
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Color.fromRGBO(
                                                  243, 141, 24, 1),
                                              size: 14,
                                            ),
                                            Text(
                                              "${eventDetail.ratingsModel.totalReview} (${eventDetail.ratingsModel.totalReview} ${eventDetail.ratingsModel.totalReview == 1 ? LocaleKeys.review : LocaleKeys.reviews})",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AddressWithLocationIconWidget(
                                        address:
                                            eventDetail.postLocation.address,
                                        iconSize: 18,
                                        fontSize: 13,
                                        iconTopPadding: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(
                                        width: 15,
                                        thickness: 1.5,
                                        color:
                                            Color.fromRGBO(112, 112, 112, 0.4),
                                      ),
                                    ),
                                    RouteWithDistance(
                                      distance: eventDetail.distance,
                                      iconSize: 14,
                                      fontSize: 12,
                                    ),
                                    const SizedBox(width: 8),
                                    SvgElevatedButton(
                                      onTap: () {
                                        //Launch Google map
                                        UrlLauncher().openMap(
                                          latitude:
                                              eventDetail.postLocation.latitude,
                                          longitude: eventDetail
                                              .postLocation.longitude,
                                        );
                                      },
                                      svgImage: SVGAssetsImages.navigation,
                                      name: LocaleKeys.navigate,
                                      boxHeight: 20,
                                      textSize: 10,
                                      backgroundcolor:
                                          ApplicationColours.themeBlueColor,
                                    ),
                                  ],
                                ),
                              ),
                              SvgTextWidget(
                                svgImage: SVGAssetsImages.calendarStar,
                                prefixText: tr(LocaleKeys.eventType),
                                suffixText: eventDetail.topicName,
                              ),

                              //Start Date
                              SvgTextWidget(
                                svgImage: SVGAssetsImages.calendar,
                                prefixText: tr(LocaleKeys.eventStartDate),
                                suffixText:
                                    FormatDate.eMdy(eventDetail.startDate),
                              ),

                              //Start Time
                              SvgTextWidget(
                                svgImage: SVGAssetsImages.clock,
                                prefixText: tr(LocaleKeys.eventStartTime),
                                suffixText:
                                    FormatDate.ampm(eventDetail.startTime),
                              ),

                              //End Date
                              SvgTextWidget(
                                svgImage: SVGAssetsImages.calendar,
                                prefixText: tr(LocaleKeys.eventEndDate),
                                suffixText:
                                    FormatDate.eMdy(eventDetail.endDate),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //End Time
                                  SvgTextWidget(
                                    svgImage: SVGAssetsImages.clock,
                                    prefixText: tr(LocaleKeys.eventEndTime),
                                    suffixText:
                                        FormatDate.ampm(eventDetail.endTime),
                                  ),

                                  //Event attending count
                                  GestureDetector(
                                    onTap: eventDetail.attendingUserCount > 0
                                        ? () {
                                            GoRouter.of(context).pushNamed(
                                                EventAttendingScreen.routeName,
                                                queryParameters: {
                                                  'event_id': eventDetail.id
                                                });
                                          }
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Color.fromRGBO(226, 233, 255, 1),
                                      ),
                                      child: Text(
                                        "${eventDetail.attendingUserCount.formatNumber()} ${tr(LocaleKeys.attending)}",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Description
                      Visibility(
                        visible: eventDetail.description.isNotEmpty,
                        child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetHeading(title: tr(LocaleKeys.description)),
                              const SizedBox(height: 5),
                              Text(
                                eventDetail.description,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Analytics Overview
                      if (eventDetail.isPostAdmin)
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(10),
                          child: AnalyticsOverviewButton(
                            moduleId: widget.eventId,
                            moduleType: AnalyticsModuleType.event,
                          ),
                        ),

                      Visibility(
                        visible: !eventDetail.isPostAdmin,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Posted by
                              Text(
                                tr(LocaleKeys.postedBy),
                                style: TextStyle(
                                  color: ApplicationColours.themeBlueColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              PostOwnerDetails(
                                id: eventDetail.postOwnerDetails.id,
                                name: eventDetail.postOwnerDetails.name,
                                image: eventDetail.postOwnerDetails.image,
                                address: eventDetail.postOwnerDetails.address,
                                isVerified: eventDetail.postOwnerDetails.isVerified,
                                postCreatedAt: eventDetail.createdAt,
                                isOwner: eventDetail.isPostAdmin,
                              ),
                              //Bottom spacing
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      //Rate Event
                      AnimatedHideWidget(
                        visible: !eventDetail.userHasRated,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: eventDetail.isPostAdmin ? 0 : 4),
                          child: GiveRatingWidget(
                            postId: eventDetail.id,
                            ratingType: RatingType.event,
                            refreshAfterReview: () async {
                              await context
                                  .read<EventDetailsCubit>()
                                  .fetchEventDetails(widget.eventId);
                            },
                          ),
                        ),
                      ),

                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        child: eventDetail.isPostAdmin
                            ? BlocConsumer<PostActionCubit, PostActionState>(
                                listener: (context, postActionState) {
                                  if (postActionState.isDeleteRequestSuccess) {
                                    //Close the screen after delete
                                    GoRouter.of(context).pop();
                                  }
                                },
                                builder: (context, postActionState) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedHideWidget(
                                        visible: !eventDetail.isCancelled,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: SquareBorderSvgButton(
                                            showloading: eventDetailsState
                                                .requestLoading,
                                            svgImage:
                                                SVGAssetsImages.cancelEvent,
                                            text: tr(LocaleKeys.cancelTheEvent),
                                            onTap: postActionState
                                                    .isDeleteRequestLoading
                                                ? null
                                                : () {
                                                    context
                                                        .read<
                                                            EventDetailsCubit>()
                                                        .cancelEvent(
                                                            eventDetail.id);
                                                  },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SquareBorderSvgButton(
                                        showloading: postActionState
                                            .isDeleteRequestLoading,
                                        svgImage: SVGAssetsImages.delete,
                                        text: tr(LocaleKeys.delete),
                                        onTap: eventDetailsState.requestLoading
                                            ? null
                                            : () async {
                                                await showConfirmationDialog(
                                                  context,
                                                  confirmationButtonText:
                                                      tr(LocaleKeys.delete),
                                                  message: tr(LocaleKeys
                                                      .areyousureyouwanttopermanentlyremovethispost),
                                                ).then((allowDelete) {
                                                  if (allowDelete != null &&
                                                      allowDelete &&
                                                      context.mounted) {
                                                    //Api call
                                                    context
                                                        .read<PostActionCubit>()
                                                        .deleteSocialPost(
                                                          postId:
                                                              eventDetail.id,
                                                          postFrom:
                                                              PostFrom.feed,
                                                          postType:
                                                              PostType.event,
                                                        );
                                                  }
                                                });
                                              },
                                      ),
                                    ],
                                  );
                                },
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: !eventDetail.isClosed,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: SquareBorderSvgButton(
                                        showloading:
                                            eventDetailsState.requestLoading,
                                        svgImage:
                                            SVGAssetsImages.attendingEvent,
                                        backgroundColor: eventDetail.isAttending
                                            ? const Color.fromRGBO(
                                                71, 105, 211, 1)
                                            : Colors.grey[50],
                                        foregroundColor: eventDetail.isAttending
                                            ? Colors.white
                                            : ApplicationColours.themeBlueColor,
                                        text: eventDetail.isAttending
                                            ? tr(LocaleKeys.markasNotAttending)
                                            : tr(LocaleKeys.markAsAttending),
                                        onTap: () {
                                          context
                                              .read<EventDetailsCubit>()
                                              .toggleAttending(eventDetail.id);
                                        },
                                      ),
                                    ),
                                  ),
                                  //Report
                                  Visibility(
                                    visible: !eventDetail.isPostAdmin &&
                                        !eventDetail.reportedByUser,
                                    child:
                                        BlocListener<ReportCubit, ReportState>(
                                      listener: (context, reportState) {
                                        if (reportState.requestSuccess) {
                                          //pop screen
                                          GoRouter.of(context).pop();
                                        }
                                      },
                                      child: SquareBorderSvgButton(
                                        svgImage: SVGAssetsImages.report,
                                        text: tr(LocaleKeys.report),
                                        onTap: () {
                                          GoRouter.of(context).pushNamed(
                                            ReportScreen.routeName,
                                            extra: SocialPostReportPayload(
                                              postId: eventDetail.id,
                                              reportType: ReportType.event,
                                              postFrom: PostFrom.feed,
                                              postType: PostType.event,
                                              reportCubit:
                                                  context.read<ReportCubit>(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      //Event location
                      if (eventDetail.taggedlocation != null)
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
                                  title: tr(LocaleKeys.eventLocation),
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: MapWithMarker(
                                  preSelectedLatLng: LatLng(
                                    eventDetail.taggedlocation!.latitude,
                                    eventDetail.taggedlocation!.longitude,
                                  ),
                                  circleRadius: eventDetail.postPreferenceRadius
                                      .toDouble(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // if (!businessModel.hasUserRated)
                      //   //Rate Business
                      //   BlocProvider(
                      //     create: (context) => ManageRatingCubit(
                      //       businessDetailsCubit:
                      //           context.read<BusinessDetailsCubit>(),
                      //       rateBusinessRepository: RateBusinessRepository(),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(top: 4),
                      //       child: RateBusiness(
                      //         businessId: businessDetails.id,
                      //         refreshAfterReview: () async {
                      //           businessDetailsCubit
                      //               .fetchBusinessDetails(widget.businessId);

                      //           //Scroll to the top
                      //           await scrollAnimateTo(
                      //             scrollController: scrollController,
                      //             offset: 0,
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ),

                      //Other Near By Recommendation
                      Visibility(
                        visible: eventDetail.nearByRecommendation.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: NearByEventsRecommendation(
                            nearbyList: eventDetail.nearByRecommendation,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
