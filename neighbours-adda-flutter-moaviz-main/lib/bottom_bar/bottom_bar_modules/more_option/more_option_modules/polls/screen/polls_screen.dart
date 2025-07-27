import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/logic/content_filter_tab/content_filter_tab_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/model/content_filter_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/widget/content_filter_tab_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/polls_list/polls_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/screens/manage_poll_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/widgets/polls_list_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/widgets/polls_shimmer.dart';
import 'package:snap_local/common/social_media/create/create_social_post/helper/social_post_helper.dart';
import 'package:snap_local/common/utils/category/v1/logic/category_controller_v1/category_controller_v1_cubit.dart';
import 'package:snap_local/common/utils/category/v1/model/category_type_v1.dart';
import 'package:snap_local/common/utils/category/v1/model/category_v1_selection_strategy.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/search_box_with_data_filter.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/tutorial_screens/tutorial_logic/logic.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PollsScreen extends StatefulWidget {
  final PollsListType pollsListType;
  const PollsScreen({
    super.key,
    required this.pollsListType,
  });

  static const routeName = 'polls';

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen>
    with TickerProviderStateMixin {
  final pollListController = ScrollController();

  final pollViewFilterCubit = ContentFilterTabCubit(
    PollsContentFilterModel(),
  )..selectViewFilter(0);

  //assign the Poll category cubit instance
  late CategoryControllerV1Cubit pollCategoryCubit = CategoryControllerV1Cubit(
      PollCategoryTypeV1(MultieCategorySelectionStrategy()))
    ..fetchCategories();

  String get filterJson {
    final Map<String, dynamic> filterMap = {
      'type':
          pollViewFilterCubit.state.selectedViewFilter.viewFilterType.jsonValue,
    };

    //Add the data filter json in the filter map
    filterMap.addAll(dataFilterCubit.state.filterMap);

    //Add the category filter
    filterMap.addAll(pollCategoryCubit.state.selectedCategoryMap);

    return jsonEncode(filterMap);
  }

  //use for bottom bar hide
  DateTime? previousEventTime;
  double previousScrollOffset = 0;

  String searchKeyword = "";

  //Filter initialization
  DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: [
        SortFilterOption(sortType: SortFilterType.oldest),
        SortFilterOption(sortType: SortFilterType.latest),
        SortFilterOption(sortType: SortFilterType.voted),
      ],
    ),
  ]);

  void fetchPolls({
    bool loadMoreData = false,
    bool allowDataFetch = true,
  }) {
    //Fetch the polls
    context.read<PollsListCubit>().fetchPolls(
          loadMoreData: loadMoreData,
          allowDataFetch: allowDataFetch,
          pollsListType: widget.pollsListType,
          searchKeyword: searchKeyword,
          filterJson: filterJson,
        );
  }

  @override
  void initState() {
    super.initState();

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    final maxPollVisibilityRadius =
        profileSettingsModel.feedRadiusModel.maxPollVisibilityRadius;

    //range filter
    final distanceRangeFilter = DistanceRangeFilter(
      filterName: tr(LocaleKeys.distance),
      allowedMaxDistance: maxPollVisibilityRadius,
      selectedMaxDistance: maxPollVisibilityRadius,
    );

    //Add the distance filter to the data filter
    dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter);

    //Fetch initial data
    if (widget.pollsListType == PollsListType.yourPolls) {
      context.read<PollsListCubit>().fetchPolls(
            pollsListType: PollsListType.yourPolls,
            filterJson: filterJson,
          );
    } else {
      //Fetch both type data
      context.read<PollsListCubit>().fetchPolls(filterJson: filterJson);
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        //poll list scroll listener
        pollListController.addListener(() {
          if (pollListController.position.maxScrollExtent ==
              pollListController.offset) {
            fetchPolls(loadMoreData: true);
          }
        });
      },
    );

    //listen to view filter change
    pollViewFilterCubit.stream.listen((pollViewFilterState) {
      if (pollViewFilterState.allowFetchData) {
        fetchPolls();
      }
    });
    //handlePollsTutorial(context);
  }

  @override
  void dispose() {
    pollListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: dataFilterCubit),
        BlocProvider.value(value: pollViewFilterCubit),
        BlocProvider.value(value: pollCategoryCubit),
      ],
      child: Scaffold(
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            fetchPolls();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: pollListController,
            slivers: [
              //App bar
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: const IOSBackButton(enableBackground: false),
                titleSpacing: GoRouter.of(context).canPop() ? 0 : 10,
                title: Text(
                  tr(LocaleKeys.polls),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
                floating: true,
                snap: true,
                toolbarHeight: 50,
              ),

              //page heading
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: PageHeading(
                    svgPath: SVGAssetsImages.polls,
                    heading: widget.pollsListType.name,
                    subHeading: widget.pollsListType.description,
                  ),
                ),
              ),

              //search box and data filter
              SliverToBoxAdapter(
                child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
                  builder: (context, profileSettingsState) {
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchWithDataFilterWidget(
                            searchHint: tr(LocaleKeys.searchPolls),
                            onQuery: (query) {
                              searchKeyword = query;
                              fetchPolls();
                            },
                          ),
                          const SizedBox(height: 5),
                          //Data filter
                          DataFilterMenu(onFilterApply: () {
                            fetchPolls();
                          }),
                          const SizedBox(height: 5),
                          //Location Widget
                          AddressWithLocateMe(
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
                        ],
                      ),
                    );
                  },
                ),
              ),

              //poll data view filter
              SliverToBoxAdapter(
                child: ContentFilterTabWidget(
                  onCategorySelected: () {
                    fetchPolls();
                  },
                ),
              ),

              //poll list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: BlocBuilder<PollsListCubit, PollsListState>(
                    builder: (context, pollsListState) {
                      final showDataLoading =
                          widget.pollsListType == PollsListType.onGoing
                              ? pollsListState.isOngoingPollsDataLoading
                              : pollsListState.isYourPollsDataLoading;

                      if (pollsListState.error != null) {
                        return ErrorTextWidget(error: pollsListState.error!);
                      } else if (showDataLoading) {
                        return Container(
                          color: Colors.white,
                          child: const PollShimmerListBuilder(),
                        );
                      } else {
                        final pollsListModel =
                            widget.pollsListType == PollsListType.onGoing
                                ? pollsListState.pollsTypeListModel.onGoingPolls
                                : pollsListState.pollsTypeListModel.yourPolls;
                        return PollsListWidget(
                          pollsListType: widget.pollsListType,
                          pollsListModel: pollsListModel,
                          onPaginationDataFetch: () {
                            fetchPolls(loadMoreData: true);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<PollsListCubit, PollsListState>(
                builder: (context, pollsListState) {
                  return Visibility(
                    visible: widget.pollsListType == PollsListType.onGoing &&
                        pollsListState
                            .pollsTypeListModel.yourPolls.data.isNotEmpty,
                    child: ManagePostActionButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          PollsScreen.routeName,
                          extra: PollsListType.yourPolls,
                        );
                      },
                      backgroundColor: ApplicationColours.themeBlueColor,
                      text: "My Polls",
                    ),
                  );
                },
              ),
              ManagePostActionButton(
                onPressed: () async {
                  await SocialPostHelper()
                      .openSocialPostCreateScreen(
                        context,
                        screenName: ManagePollScreen.routeName,
                      )
                      .whenComplete(
                        () => context.read<PollsListCubit>().fetchPolls(
                              pollsListType: PollsListType.yourPolls,
                              disableLoading: true,
                              filterJson: filterJson,
                            ),
                      );
                },
                text: tr(LocaleKeys.createPoll),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
