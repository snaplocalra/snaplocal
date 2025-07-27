import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/logic/event_attending/event_attending_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/repository/event_attending_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/widget/event_attending_details.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class EventAttendingScreen extends StatefulWidget {
  final String eventId;

  static const routeName = 'event_attending';

  const EventAttendingScreen({super.key, required this.eventId});

  @override
  State<EventAttendingScreen> createState() => _EventAttendingScreenState();
}

class _EventAttendingScreenState extends State<EventAttendingScreen> {
  final scrollController = ScrollController();

  late EventAttendingCubit eventAttendingCubit =
      EventAttendingCubit(EventAttendingRepository())
        ..fetchAttendingList(eventId: widget.eventId);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        eventAttendingCubit.fetchAttendingList(
            eventId: widget.eventId, loadMoreData: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: eventAttendingCubit)],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          leading: const IOSBackButton(),
          title: Text(
            tr(LocaleKeys.eventAttending),
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            BlocBuilder<EventAttendingCubit, EventAttendingState>(
              builder: (context, eventAttendingState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: SearchTextField(
                    dataLoading: eventAttendingState.isSearchLoading,
                    hint: LocaleKeys.search,
                    onQuery: (query) {
                      if (query.isNotEmpty) {
                        //Search attendings
                        context
                            .read<EventAttendingCubit>()
                            .setSearchQuery(query);
                      } else {
                        context.read<EventAttendingCubit>().clearSearchQuery();
                      }

                      //Fetch attending list to search
                      context.read<EventAttendingCubit>().fetchAttendingList(
                          eventId: widget.eventId, showSearchLoading: true);
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<EventAttendingCubit, EventAttendingState>(
                builder: (context, eventAttendingState) {
                  final eventAttendingData =
                      eventAttendingState.eventAttendingList;
                  return BlocBuilder<EventAttendingCubit, EventAttendingState>(
                    builder: (context, eventAttendingState) {
                      if (eventAttendingState.error != null) {
                        return ErrorTextWidget(
                            error: eventAttendingState.error!);
                      } else if (eventAttendingData == null ||
                          eventAttendingState.dataLoading) {
                        return const CircleCardShimmerListBuilder(
                          padding: EdgeInsets.symmetric(vertical: 15),
                        );
                      } else {
                        final logs = eventAttendingData.data;
                        if (logs.isEmpty) {
                          return const ErrorTextWidget(error: "No user found");
                        } else {
                          return RefreshIndicator.adaptive(
                            onRefresh: () => context
                                .read<EventAttendingCubit>()
                                .fetchAttendingList(eventId: widget.eventId),
                            child: ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: logs.length + 1,
                              itemBuilder: (BuildContext context, index) {
                                if (index < logs.length) {
                                  final eventAttendingDetails = logs[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    child: Column(
                                      children: [
                                        EventAttendingDetails(
                                          eventAttendingModel:
                                              eventAttendingDetails,
                                        ),
                                        const SizedBox(height: 10),
                                        const ThemeDivider(
                                          thickness: 1,
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  if (eventAttendingData
                                      .paginationModel.isLastPage) {
                                    return const SizedBox.shrink();
                                  } else {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: ThemeSpinner(size: 30),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
