// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/logic/event_category/event_category_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/repository/manage_event_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/screen/manage_event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/logic/event_list/event_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/widgets/event_list_builder.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/general_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/filter_data.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/search_box_with_data_filter.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../../../../tutorial_screens/tutorial_logic/logic.dart';

class EventScreen extends StatefulWidget {
  final EventPostListType eventPostListType;
  const EventScreen({
    super.key,
    required this.eventPostListType,
  });
  static const routeName = 'event_list';

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();

  late EventCategoryCubit eventCategoryCubit =
      EventCategoryCubit(ManageEventRepository());

  //This will use to avoid the initial data fetch after the category selection
  bool initialDataFetched = false;

  //use for bottom bar hide
  DateTime? previousEventTime;
  double previousScrollOffset = 0;

  String searchKeyword = "";

  final FilterData filterData = FilterData();

  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: filterData.eventSortFilter,
    ),

    //event active/past filter on category filter
    ...filterData.eventStatusFilter,
  ]);

  //fetch event post data
  void fetchEvents({bool loadMoreData = false}) {
    if (mounted) {
      context.read<EventListCubit>().fetchEvents(
            loadMoreData: loadMoreData,
            eventPostListType: widget.eventPostListType,
            searchKeyword: searchKeyword,
            filterJson: dataFilterCubit.state.filterJson,
          );
    }
  }

  @override
  void initState() {
    super.initState();

    //fetch all event post data
    context.read<EventListCubit>().fetchEvents();

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    final socialMediaSearchRadius =
        profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;

    //range filter
    final distanceRangeFilter = DistanceRangeFilter(
      filterName: tr(LocaleKeys.distance),
      allowedMaxDistance: socialMediaSearchRadius,
      selectedMaxDistance: socialMediaSearchRadius,
    );

    //Add the distance filter to the data filter
    dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter);

    //Listening for the profile settings change
    context.read<ProfileSettingsCubit>().stream.listen((state) {
      if (state.isProfileSettingModelAvailable) {
        fetchEvents();

        final selectedSocialMediaRadius =
            state.profileSettingsModel!.feedRadiusModel.socialMediaSearchRadius;

        //Update the distance filter
        dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter.copyWith(
          allowedMaxDistance: selectedSocialMediaRadius,
          selectedMaxDistance: selectedSocialMediaRadius,
        ));
      }
    });

    //fetch event category list
    eventCategoryCubit.fetchEventCategorysForFilter();

    //listen to event category and add the filter
    eventCategoryCubit.stream.listen((state) {
      if (state.eventTopics.data.isNotEmpty && !initialDataFetched) {
        //Add the category filter
        dataFilterCubit.insertOrUpdateFilter(
          GeneralFilter(
            filterName: tr(LocaleKeys.eventCategory),
            categories: state.eventTopics.data,
            jsonKey: "event_category_id",
          ),
        );
      }
    });
    //handleEventsTutorial(context);
  }

  void openMyEventsPostScreen(ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.socialMediaLocation !=
          null) {
        if (mounted) {
          GoRouter.of(context)
              .pushNamed(CreateEventScreen.routeName)
              .whenComplete(
                () => context.read<EventListCubit>().fetchEvents(
                    eventPostListType: EventPostListType.myEvents,
                    disableLoading: true),
              );
        }
      } else {
        showThemeAlertDialog(
          context: context,
          onAcceptPressed: () {
            if (mounted) {
              GoRouter.of(context).pushNamed(
                LocationManageMapScreen.routeName,
                extra: {
                  "locationType": LocationType.socialMedia,
                  "locationManageType": LocationManageType.setting,
                },
              );
            }
          },
          agreeButtonText: tr(LocaleKeys.addNow),
          cancelButtonText: tr(LocaleKeys.cancel),
          title: tr(LocaleKeys.youNeedToAddYourLocationToProceed),
        );
      }
    }
  }

  void willPopScope(bool allowPop) {
    if (allowPop) {
      GoRouter.of(context).pop();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: dataOnMapViewControllerCubit),
        BlocProvider.value(value: dataFilterCubit),
      ],
      child: BlocBuilder<LanguageChangeControllerCubit,
          LanguageChangeControllerState>(
        builder: (context, _) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) {
                return;
              }

              willPopScope(true);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: ThemeAppBar(
                backgroundColor: Colors.white,
                appBarHeight: 60,
                enableBackButtonBackground: false,
                title: Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  child: PageHeading(
                    svgPath: SVGAssetsImages.eventHeader,
                    heading: widget.eventPostListType.name,
                    subHeading: LocaleKeys.eventModuleDescription,
                  ),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Filter
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchWithDataFilterWidget(
                          searchHint: tr(LocaleKeys.searchEvents),
                          onQuery: (query) {
                            searchKeyword = query;
                            fetchEvents();
                          },
                        ),
                        const SizedBox(height: 5),
                        //Data filter
                        DataFilterMenu(
                          onFilterApply: () {
                            fetchEvents();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      child: AddressWithLocateMe(
                        key: _addressWithLocateMeKey,
                        is3D: true,
                        iconSize: 15,
                        iconTopPadding: 0,
                        locationType: LocationType.socialMedia,
                        contentMargin: EdgeInsets.zero,
                        height: 35,
                        decoration: BoxDecoration(
                          color: ApplicationColours.skyColor.withOpacity(1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: null,
                      ),
                    ),
                  ),

                  Expanded(
                    child: widget.eventPostListType ==
                            EventPostListType.localEvents
                        ?
                        //Classifieds by Neighbours
                        EventListBuilder(
                            onRefresh: () async => fetchEvents(),
                            onPagination: () => fetchEvents(loadMoreData: true),
                            eventPostListType: EventPostListType.localEvents,
                          )
                        :
                        //Classifieds Posted by you
                        EventListBuilder(
                            onRefresh: () async => fetchEvents(),
                            onPagination: () => fetchEvents(loadMoreData: true),
                            eventPostListType: EventPostListType.myEvents,
                            isOwnPost: true,
                          ),
                  ),
                ],
              ),
              floatingActionButton:
                  BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
                builder: (context, profileSettingsState) {
                  if (profileSettingsState.isProfileSettingModelAvailable) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<EventListCubit, EventListState>(
                            builder: (context, eventListState) {
                              return Visibility(
                                visible: widget.eventPostListType ==
                                        EventPostListType.localEvents &&
                                    eventListState.eventPostDataModel.myEvents
                                        .data.isNotEmpty,
                                child: ManagePostActionButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                      EventScreen.routeName,
                                      extra: EventPostListType.myEvents,
                                    );
                                  },
                                  text: tr(LocaleKeys.myEvents),
                                  backgroundColor:
                                      ApplicationColours.themeBlueColor,
                                ),
                              );
                            },
                          ),

                          //Create Event
                          ManagePostActionButton(
                            onPressed: () {
                              openMyEventsPostScreen(profileSettingsState);
                            },
                            text: tr(LocaleKeys.createEvent),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
