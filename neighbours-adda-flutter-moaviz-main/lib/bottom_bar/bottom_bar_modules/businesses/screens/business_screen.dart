import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_check/business_check_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_list/business_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/repository/business_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/repository/business_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/business_list_builder.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/manage_business_buttons.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
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
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../tutorial_screens/tutorial_logic/logic.dart';

class BusinessScreen extends StatefulWidget {
  final BusinessViewType businessViewType;
  final bool isRootNavigation;
  const BusinessScreen({
    super.key,
    this.businessViewType = BusinessViewType.business,
    this.isRootNavigation = false,
  });

  static const routeName = 'business';
  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  String searchKeyword = "";

  //If the data is empty then stop the pagination call
  bool allowPagination = true;

  late BusinessListCubit businessListCubit =
      BusinessListCubit(context.read<BusinessListRepository>());
  late BusinessCheckCubit businessCheckCubit =
      BusinessCheckCubit(BusinessDetailsRepository());
  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();

  final FilterData filterData = FilterData();
//assign the business category cubit instance
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          BusinessCategory(MultieSubCategorySelectionStrategy()));
  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: filterData.businessSortFilter,
    ),

    if (widget.businessViewType == BusinessViewType.business)
      //business open close filter in category filter
      ...filterData.businessStatusFilter,
  ]);

  void onPagination() {
    fetchBusiness(loadMoreData: true);
  }

  void fetchBusiness({bool loadMoreData = false}) {
    businessListCubit.fetchBusiness(
      loadMoreData: loadMoreData,
      //Filter JSON
      filterJson: dataFilterCubit.state.filterJson,
      searchKeyword: searchKeyword,
      businessViewType: widget.businessViewType,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchBusiness();
    //Fetch business categroy initially
    categoryControllerCubit.fetchCategories();
    //listen for the category filter changes
    categoryControllerCubit.stream.listen((state) {
      if (state is CategoryControllerDataLoaded) {
        dataFilterCubit.insertOrUpdateFilter(
          CategoryFilter(
            filterName: "Category",
            jsonKey: "category",
            categoryControllerCubit: categoryControllerCubit,
          ),
        );
      }
    });
    //Fetch business

    if (widget.businessViewType == BusinessViewType.business) {
      //Check own business details
      businessCheckCubit.checkBusinessDetails();
    }

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

    //Listen for the profile setting changes
    context.read<ProfileSettingsCubit>().stream.listen((state) {
      if (state.isProfileSettingModelAvailable) {
        //Fetch business
        fetchBusiness();

        //Check own business details
        businessCheckCubit.checkBusinessDetails();

        final selectedMarketPlaceRadius =
            state.profileSettingsModel!.feedRadiusModel.marketPlaceSearchRadius;

        //Update the distance filter
        dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter.copyWith(
          allowedMaxDistance: selectedMarketPlaceRadius,
          selectedMaxDistance: selectedMarketPlaceRadius,
        ));
      }
    });
    //handleBusinessTutorial(context);
  }

  void willPopScope() {
    context.read<BottomBarNavigatorCubit>().goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: businessCheckCubit),
        BlocProvider.value(value: businessListCubit),
        BlocProvider.value(value: categoryControllerCubit),
        BlocProvider.value(value: dataOnMapViewControllerCubit),
        BlocProvider.value(value: dataFilterCubit),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              showBackButton: !widget.isRootNavigation,
              titleSpacing: widget.isRootNavigation ? 10 : 0,
              appBarHeight: 60,
              title: PageHeading(
                svgPath: widget.businessViewType.svgPath,
                heading: widget.businessViewType.heading,
                subHeading: widget.businessViewType.description,
              ),
            ),
            body: Column(
              children: [
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SearchWithDataFilterWidget(
                              searchHint: widget.businessViewType ==
                                      BusinessViewType.business
                                  ? tr(LocaleKeys.searchBusiness)
                                  : tr(LocaleKeys.searchOffers),
                              onQuery: (query) {
                                searchKeyword = query;
                                fetchBusiness();
                              },
                            ),
                            const SizedBox(height: 5),
                            //Data filter
                            DataFilterMenu(
                              categoryControllerCubit:
                                  context.read<CategoryControllerCubit>(),
                              onFilterApply: () {
                                fetchBusiness();
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    child: AddressWithLocateMe(
                      key: _addressWithLocateMeKey,
                      is3D: true,
                      iconSize: 15,
                      iconTopPadding: 0,
                      locationType: LocationType.marketPlace,
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
                  child: BusinessListBuilder(
                    businessViewType: widget.businessViewType,
                    onPagination: () => onPagination(),
                    onRefresh: () async => fetchBusiness(),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            floatingActionButton:
                widget.businessViewType == BusinessViewType.business
                    ? Transform.translate(
                        offset: const Offset(10, 0),
                        child: ManageBusinessButton(
                          onBusinessFetch: () {
                            fetchBusiness();
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
