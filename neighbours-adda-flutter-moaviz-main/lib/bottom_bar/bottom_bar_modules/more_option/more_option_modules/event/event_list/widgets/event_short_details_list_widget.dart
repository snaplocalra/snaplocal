// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/screen/event_details_screen.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class EventShortDetailsListWidget extends StatelessWidget {
  const EventShortDetailsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final mqSize = MediaQuery.sizeOf(context);
    const borderRadius = Radius.circular(10);
    return BlocBuilder<PostDetailsControllerCubit, PostDetailsControllerState>(
      builder: (context, postDetailsControllerState) {
        final eventPost =
            postDetailsControllerState.socialPostModel as EventPostModel;
        return GestureDetector(
          onTap: () {
            GoRouter.of(context)
                .pushNamed(EventDetailsScreen.routeName, queryParameters: {
              'id': eventPost.id,
            }, extra: {
              'postActionCubit': context.read<PostActionCubit>(),
              'postDetailsControllerCubit':
                  context.read<PostDetailsControllerCubit>(),
            });
          },
          child: AbsorbPointer(
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(borderRadius),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (eventPost.media.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(borderRadius),
                                child: Stack(
                                  children: [
                                    NetworkMediaWidget(
                                      key: ValueKey(eventPost.media.first),
                                      media: eventPost.media.first,
                                      fit: BoxFit.cover,
                                      height: 110,
                                      width: 110,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: AttendingStatus(
                                        attending: eventPost
                                            .eventShortDetails.isAttending,
                                        isClosed: eventPost
                                            .eventShortDetails.isClosed,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventPost.eventShortDetails.title,
                                // 'Hello',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: AddressWithLocationIconWidget(
                                  address: eventPost.taggedlocation!.address,
                                  textColour: ApplicationColours.themeBlueColor,
                                  iconColour: ApplicationColours.themePinkColor,
                                  iconSize: 15,
                                  fontSize: 12,
                                  iconTopPadding: 1,
                                ),
                              ),
                              Visibility(
                                visible: eventPost
                                    .eventShortDetails.description.isNotEmpty,
                                child: Text(
                                  eventPost.eventShortDetails.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  "${FormatDate.formatDateTimeWithTimeOfDayDTMMM(
                                    eventPost.eventShortDetails.startDate,
                                    eventPost.eventShortDetails.startTime,
                                  )} - ${FormatDate.formatDateTimeWithTimeOfDayDTMMM(
                                    eventPost.eventShortDetails.endDate,
                                    eventPost.eventShortDetails.endTime,
                                  )}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              RouteWithDistance(
                                distance: eventPost.eventShortDetails.distance,
                                iconSize: 12,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AttendingStatus extends StatelessWidget {
  final bool attending;
  final bool isClosed;
  const AttendingStatus({
    super.key,
    required this.attending,
    required this.isClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: attending || isClosed,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        color: isClosed
            ? Colors.red
            : attending
                ? Colors.green
                : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            isClosed ? tr(LocaleKeys.closed) : tr(LocaleKeys.attending),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
