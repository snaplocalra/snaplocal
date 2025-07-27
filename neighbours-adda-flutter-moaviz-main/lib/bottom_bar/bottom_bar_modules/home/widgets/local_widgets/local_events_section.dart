import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_events/local_events_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_events/local_events_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_event_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/screen/event_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/screens/event_screen.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class LocalEventsSection extends StatefulWidget {
  const LocalEventsSection({super.key});

  @override
  State<LocalEventsSection> createState() => _LocalEventsSectionState();
}

class _LocalEventsSectionState extends State<LocalEventsSection> {
  @override
  void initState() {
    super.initState();
    // Fetch local events when widget initializes
    context.read<LocalEventsCubit>().fetchLocalEvents();
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ShimmerWidget(
            width: 100,
            height: 100,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 160,
                  height: 16,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 120,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 140,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 180,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(
      BuildContext context, LocalEventModel event, bool isLast) {
    final cubit = context.read<LocalEventsCubit>();
    return GestureDetector(
      onTap: (){
         GoRouter.of(context)
                .pushNamed(EventDetailsScreen.routeName, queryParameters: {
              'id': event.id,
            }, extra: {
              'postActionCubit': context.read<PostActionCubit>(),
              'postDetailsControllerCubit':
                  context.read<PostDetailsControllerCubit>(),
            });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: event.media.isNotEmpty
                  ? Image.network(
                      event.media.first.mediaPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.red,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.event,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventDetails.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.pink,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.taggedLocation.address,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF1A237E)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cubit.getFormattedEventDateTime(event),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalEventsCubit, LocalEventsState>(
      builder: (context, state) {
        // Don't show anything if loading, has error, or no events
        if (state.dataLoading || state.error != null || state.events.isEmpty) {
          return const SizedBox.shrink();
        }

        final events = state.events.take(3).toList();
        if (events.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Local Events Near You',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SeeAllButton(onTap: () {
                    GoRouter.of(context).pushNamed(
                      EventScreen.routeName,
                      extra: EventPostListType.localEvents,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: List.generate(
                      events.length,
                      (index) => _buildEventItem(
                        context,
                        events[index],
                        index == events.length - 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
