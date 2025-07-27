// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/jobs/jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/screen/manage_jobs_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/repository/jobs_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/jobs_list_builder.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
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
import 'package:snap_local/tutorial_screens/tutorial_logic/logic.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class JobsScreen extends StatefulWidget {
  final JobsListType jobsListType;

  const JobsScreen({
    super.key,
    required this.jobsListType,
  });
  static const routeName = 'jobs';

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  final jobsCubit = JobsCubit(JobsRepository());
  final jobsScrollController = ScrollController();
  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();

  //This will use to avoid the initial data fetch after the category selection
  bool initialDataFetched = false;

  //assign the Job category cubit instance
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          JobCategory(MultieSubCategorySelectionStrategy()));

  String searchKeyword = "";

  final FilterData filterData = FilterData();

  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: filterData.jobSortFilter,
    ),
  ]);

  void fetchJobs({JobsListType? jobsListType, bool loadMoreData = false}) {
    jobsCubit.fetchJobs(
      jobsListType: jobsListType ?? widget.jobsListType,
      filterJson: dataFilterCubit.state.filterJson,
      searchKeyword: searchKeyword,
      loadMoreData: loadMoreData,
    );
  }

  @override
  void initState() {
    super.initState();

    //initial Job post data fetch
    jobsCubit.fetchJobs();

    //Load the categories
    categoryControllerCubit.fetchCategories();

    //listen for the category filter changes
    categoryControllerCubit.stream.listen((state) {
      if (state is CategoryControllerDataLoaded && state.isFirstLoad) {
        dataFilterCubit.insertOrUpdateFilter(
          CategoryFilter(
            filterName: "Category",
            jsonKey: "category",
            categoryControllerCubit: categoryControllerCubit,
          ),
        );
      }
    });

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    final marketPlaceSearchRadius =
        profileSettingsModel.feedRadiusModel.marketPlaceSearchRadius;

    //range filter
    final distanceRangeFilter = DistanceRangeFilter(
      filterName: tr(LocaleKeys.distance),
      allowedMaxDistance: marketPlaceSearchRadius,
      selectedMaxDistance: marketPlaceSearchRadius,
    );

    //Add the distance filter to the data filter
    dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Fetch pagination data for Jobs by Neighbours
      jobsScrollController.addListener(() {
        if (jobsScrollController.position.maxScrollExtent ==
            jobsScrollController.offset) {
          fetchJobs(loadMoreData: true);
        }
      });
    });

    //Listening for the profile settings change
    context.read<ProfileSettingsCubit>().stream.listen((state) {
      if (state.isProfileSettingModelAvailable) {
        //Fetch the jobs data after the profile setting is available
        fetchJobs();

        final selectedMarketPlaceRadius =
            state.profileSettingsModel!.feedRadiusModel.marketPlaceSearchRadius;

        //Update the distance filter
        dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter.copyWith(
          allowedMaxDistance: selectedMarketPlaceRadius,
          selectedMaxDistance: selectedMarketPlaceRadius,
        ));
      }
    });
    //handleJobsTutorial(context);
  }

  void openManageJobsScreen(ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.marketPlaceLocation !=
          null) {
        if (mounted) {
          GoRouter.of(context)
              .pushNamed(ManageJobsScreen.routeName)
              .whenComplete(() => fetchJobs(jobsListType: JobsListType.byYou));
        }
      } else {
        showThemeAlertDialog(
          context: context,
          onAcceptPressed: () {
            if (mounted) {
              GoRouter.of(context).pushNamed(
                LocationManageMapScreen.routeName,
                extra: {
                  "locationType": LocationType.marketPlace,
                  "locationManageType": LocationManageType.setting,
                },
              );
            }
          },
          agreeButtonText: "Update Now",
          cancelButtonText: tr(LocaleKeys.cancel),
          title: "You need to update your location to procced.",
        );
      }
    }
  }

  @override
  void dispose() {
    jobsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: jobsCubit),
        BlocProvider.value(value: categoryControllerCubit),
        BlocProvider.value(value: dataOnMapViewControllerCubit),
        BlocProvider.value(value: dataFilterCubit),
      ],
      child: BlocBuilder<LanguageChangeControllerCubit,
          LanguageChangeControllerState>(
        builder: (context, _) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              appBarHeight: 60,
              title: Container(
                color: Colors.white,
                child: PageHeading(
                  svgPath: SVGAssetsImages.jobs,
                  heading: widget.jobsListType.name,
                  subHeading: widget.jobsListType.description,
                ),
              ),
            ),
            body: Column(
              children: [
                //Filter
                BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
                  builder: (context, profileSettingsState) {
                    final marketPlaceLocationAvailable = profileSettingsState
                            .profileSettingsModel!.marketPlaceLocation !=
                        null;
                    return Visibility(
                      visible: marketPlaceLocationAvailable,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchWithDataFilterWidget(
                              searchHint: "Search jobs",
                              onQuery: (query) {
                                searchKeyword = query;
                                fetchJobs();
                              },
                            ),
                            const SizedBox(height: 5),
                            //Data filter
                            DataFilterMenu(
                              categoryControllerCubit:
                                  context.read<CategoryControllerCubit>(),
                              onFilterApply: () {
                                fetchJobs();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: AddressWithLocateMe(
                    key: _addressWithLocateMeKey,
                    is3D: true,
                    iconSize: 15,
                    iconTopPadding: 0,
                    locationType: LocationType.marketPlace,
                    enableLocateMe: true,
                    contentMargin: EdgeInsets.zero,
                    height: 35,
                    decoration: BoxDecoration(
                      color: ApplicationColours.skyColor.withOpacity(1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: null,
                  ),
                ),
                Expanded(
                  child: JobsListBuilder(
                    jobsListType: widget.jobsListType,
                    scrollController: jobsScrollController,
                    onRefresh: () async => fetchJobs(),
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
                        BlocBuilder<JobsCubit, JobsState>(
                          builder: (context, jobsState) {
                            return Visibility(
                              visible: widget.jobsListType ==
                                      JobsListType.byNeighbours &&
                                  jobsState
                                      .jobsDataModel.jobsByYou.data.isNotEmpty,
                              child: ManagePostActionButton(
                                onPressed: () {
                                  GoRouter.of(context).pushNamed(
                                    JobsScreen.routeName,
                                    extra: JobsListType.byYou,
                                  );
                                },
                                text: tr(LocaleKeys.myListing),
                                backgroundColor:
                                    ApplicationColours.themeBlueColor,
                              ),
                            );
                          },
                        ),
                        ManagePostActionButton(
                          onPressed: () {
                            openManageJobsScreen(profileSettingsState);
                          },
                          text: "Post Job",
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
