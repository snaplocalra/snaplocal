// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/logic/sales_post/sales_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/screen/manage_sales_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/repository/sales_post_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/widgets/buy_sell_list_builder.dart';
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

class BuySellScreen extends StatefulWidget {
  final SalesPostListType salesPostListType;
  const BuySellScreen({
    super.key,
    required this.salesPostListType,
  });
  static const routeName = 'buy_sell';

  @override
  State<BuySellScreen> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  // late final isMyListingView =
  //     widget.salesPostListType == SalesPostListType.myListing;

  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  String searchKeyword = "";

  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();

  final salesPostCubit = SalesPostCubit(SalesPostRepository());

  //This will use to avoid the initial data fetch after the category selection
  bool initialDataFetched = false;

  final FilterData filterData = FilterData();

  //assign the Job category cubit instance
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
    BuyAndSellCategory(MultieSubCategorySelectionStrategy()),
  );

  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: filterData.buySellSortFilter,
    ),

    //condition type filter
    ...filterData.conditionTypeFilter,
    //sale type filter
    ...filterData.saleTypeFilter,
  ]);

  //fetch sales post data
  void fetchSalesPost({
    SalesPostListType? salesPostListType,
    bool loadMoreData = false,
  }) {
    print('Fetching sales post on buy sell screen');
    print(dataFilterCubit.state.filterJson);
    salesPostCubit.fetchSalesPost(
      loadMoreData: loadMoreData,
      salesPostListType: salesPostListType ?? widget.salesPostListType,

      //Filter JSON
      filterJson: dataFilterCubit.state.filterJson,
      searchKeyword: searchKeyword,
    );
  }

  @override
  void initState() {
    super.initState();

    //fetch all sales post data
    salesPostCubit.fetchSalesPost();
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

    //Load the categories
    // salesCategoryCubit.fetchFilterSalesCategories();

    //Listening for the profile settings change
    context.read<ProfileSettingsCubit>().stream.listen((state) {
      if (state.isProfileSettingModelAvailable) {
        //fetch sales post
        

        final selectedMarketPlaceRadius =
            state.profileSettingsModel!.feedRadiusModel.marketPlaceSearchRadius;

        //Update the distance filter
        dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter.copyWith(
          allowedMaxDistance: selectedMarketPlaceRadius,
          selectedMaxDistance: selectedMarketPlaceRadius,
        ));

        fetchSalesPost();
      }
    });
    //handleBuySellTutorial(context);
  }

  void openManageSalesPostScreen(ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.marketPlaceLocation !=
          null) {
        if (mounted) {
          GoRouter.of(context)
              .pushNamed(ManageSalesPostScreen.routeName)
              .whenComplete(
                () => fetchSalesPost(
                  salesPostListType: SalesPostListType.myListing,
                ),
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
                    "locationType": LocationType.marketPlace,
                    "locationManageType": LocationManageType.setting,
                  },
                );
              }
            },
            agreeButtonText: tr(LocaleKeys.addNow),
            cancelButtonText: tr(LocaleKeys.cancel),
            title: tr(LocaleKeys.youNeedToAddYourLocationToProceed));
      }
    }
  }

  void willPopScope() {
    GoRouter.of(context).pop();
  }

  void onPagination() {
    fetchSalesPost(loadMoreData: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: salesPostCubit),
        BlocProvider.value(value: categoryControllerCubit),
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
              willPopScope();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: ThemeAppBar(
                backgroundColor: Colors.white,
                showBackButton: true,
                appBarHeight: 60,
                title: Container(
                  color: Colors.white,
                  child: PageHeading(
                    svgPath: SVGAssetsImages.buySellHeader,
                    heading: widget.salesPostListType.name,
                    subHeading:
                        LocaleKeys.discovergreatlocaldealsinyourneighbourhood,
                  ),
                ),
              ),
              body: RefreshIndicator.adaptive(
                onRefresh: () async {
                  fetchSalesPost();
                },
                child: Column(
                  children: [
                    //Filter
                    BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
                      builder: (context, profileSettingsState) {
                        final marketPlaceLocationAvailable =
                            profileSettingsState.profileSettingsModel!
                                    .marketPlaceLocation !=
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
                                  searchHint: tr(LocaleKeys.searchMarketPlace),
                                  onQuery: (query) {
                                    searchKeyword = query;
                                    fetchSalesPost();
                                  },
                                ),
                                const SizedBox(height: 5),
                                //Data filter
                                DataFilterMenu(
                                  categoryControllerCubit:
                                      context.read<CategoryControllerCubit>(),
                                  onFilterApply: () {
                                    fetchSalesPost();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    //Address with map list switch
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
                    ),

                    //Expanded
                    Expanded(
                      child: widget.salesPostListType ==
                              SalesPostListType.marketLocally
                          ?
                          //Classifieds by Neighbours
                          BuySellListBuilder(
                              salesPostListType:
                                  SalesPostListType.marketLocally,
                              onPagination: () => onPagination(),
                              reFreshParentData: () {
                                fetchSalesPost();
                              },
                            )
                          :
                          //Classifieds Posted by you
                          BuySellListBuilder(
                              salesPostListType: SalesPostListType.myListing,
                              isOwnPost: true,
                              onPagination: () => onPagination(),
                              reFreshParentData: () {
                                fetchSalesPost();
                              },
                            ),
                    ),
                  ],
                ),
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
                          BlocBuilder<SalesPostCubit, SalesPostState>(
                            builder: (context, salesPostState) {
                              return Visibility(
                                visible: widget.salesPostListType ==
                                        SalesPostListType.marketLocally &&
                                    salesPostState.salesPostDataModel
                                        .salesPostByYou.data.isNotEmpty,
                                child: ManagePostActionButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                      BuySellScreen.routeName,
                                      extra: SalesPostListType.myListing,
                                    );
                                  },
                                  backgroundColor:
                                      ApplicationColours.themeBlueColor,
                                  text: tr(LocaleKeys.myListing),
                                ),
                              );
                            },
                          ),
                          //Post your sale
                          ManagePostActionButton(
                            onPressed: () {
                              openManageSalesPostScreen(profileSettingsState);
                            },
                            text: tr(LocaleKeys.postSale),
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
