// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/home_search_type.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/date_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/filter_data.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class FindLocallyFilter extends StatefulWidget {
  final ExploreCategoryTypeEnum exploreCategoryTypeEnum;
  final void Function(String filterJson) onFilter;
  const FindLocallyFilter({
    super.key,
    required this.onFilter,
    required this.exploreCategoryTypeEnum,
  });

  @override
  State<FindLocallyFilter> createState() => _FindLocallyFilterState();
}

class _FindLocallyFilterState extends State<FindLocallyFilter> {
  //business category cubit
  late CategoryControllerCubit businessCategoryCubit = CategoryControllerCubit(
      BusinessCategory(MultieSubCategorySelectionStrategy()));

  //job category cubit
  final CategoryControllerCubit jobCategoryControllerCubit =
      CategoryControllerCubit(
          JobCategory(MultieSubCategorySelectionStrategy()));

  //buy and sell category cubit
  late CategoryControllerCubit salesCategoryCubit = CategoryControllerCubit(
      BuyAndSellCategory(MultieSubCategorySelectionStrategy()));

  late bool isBusiness =
      widget.exploreCategoryTypeEnum == ExploreCategoryTypeEnum.business;

  late bool isBuyAndSell =
      widget.exploreCategoryTypeEnum == ExploreCategoryTypeEnum.buyAndsell;

  late bool isJobs =
      widget.exploreCategoryTypeEnum == ExploreCategoryTypeEnum.jobs;

  late bool isEvent =
      widget.exploreCategoryTypeEnum == ExploreCategoryTypeEnum.event;

  late bool isLostAndFound =
      widget.exploreCategoryTypeEnum == ExploreCategoryTypeEnum.lostAndFound;

  late bool isSafetyAndAlerts =
      widget.exploreCategoryTypeEnum == ExploreCategoryTypeEnum.safetyAndAlerts;

  final FilterData filterData = FilterData();

  //Filter initialization
  late DataFilterCubit dataFilterCubit = DataFilterCubit(
    [
      //Sort filter
      SortFilter(
        filterName: tr(LocaleKeys.sort),
        sortFilterOptions: [
          if (isBusiness) ...filterData.businessSortFilter,

          if (isBuyAndSell) ...filterData.buySellSortFilter,
          if (isJobs) ...filterData.jobSortFilter,
          if (isEvent) ...filterData.eventSortFilter,

          //add the safety and alerts sort filter
          if (isSafetyAndAlerts || isLostAndFound)
            ...filterData.socialSortFilter,
        ],
      ),

      if (isBusiness)
        //business open close filter in category filter
        ...filterData.businessStatusFilter,

      if (isBuyAndSell) ...[
        //condition type filter
        ...filterData.conditionTypeFilter,
        //sale type filter
        ...filterData.saleTypeFilter,
      ],

      if (isEvent) ...[
        //event active/past filter on category filter
        ...filterData.eventStatusFilter,
      ],

      if (isSafetyAndAlerts || isLostAndFound) ...[
        //Date range filter
        DateRangeFilter(filterName: "Date"),
      ]
    ],
  )..showFilter(true);

  @override
  void initState() {
    super.initState();
    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;
    final searchRadius = widget.exploreCategoryTypeEnum.isMarketPlace
        ? profileSettingsModel.feedRadiusModel.marketPlaceSearchRadius
        : profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;

    //range filter
    final distanceRangeFilter = DistanceRangeFilter(
      filterName: tr(LocaleKeys.distance),
      allowedMaxDistance: searchRadius,
      selectedMaxDistance: searchRadius,
    );

    //Add the distance filter to the data filter
    dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter);

    //category filter
    if (isBusiness) {
      businessCategoryCubit.fetchCategories();
      //listen for the category filter changes
      businessCategoryCubit.stream.listen((state) {
        if (state is CategoryControllerDataLoaded && state.isFirstLoad) {
          dataFilterCubit.insertOrUpdateFilter(
            CategoryFilter(
              filterId: "business_category",
              filterName: "Category",
              jsonKey: "category",
              categoryControllerCubit: businessCategoryCubit,
            ),
          );
        }
      });
    } else if (isJobs) {
      jobCategoryControllerCubit.fetchCategories();
      //listen for the category filter changes
      jobCategoryControllerCubit.stream.listen((state) {
        if (state is CategoryControllerDataLoaded && state.isFirstLoad) {
          dataFilterCubit.insertOrUpdateFilter(
            CategoryFilter(
              filterId: "job_category",
              filterName: "Category",
              jsonKey: "category",
              categoryControllerCubit: jobCategoryControllerCubit,
            ),
          );
        }
      });
    } else if (isBuyAndSell) {
      salesCategoryCubit.fetchCategories();
      //listen for the category filter changes
      salesCategoryCubit.stream.listen((state) {
        if (state is CategoryControllerDataLoaded && state.isFirstLoad) {
          dataFilterCubit.insertOrUpdateFilter(
            CategoryFilter(
              filterId: "sales_category",
              filterName: "Category",
              jsonKey: "category",
              categoryControllerCubit: salesCategoryCubit,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: dataFilterCubit)],
      child: Builder(builder: (context) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: DataFilterMenu(
              onFilterApply: () {
                widget.onFilter
                    .call(context.read<DataFilterCubit>().state.filterJson);
              },
              categoryControllerCubit: isBusiness
                  ? businessCategoryCubit
                  : isJobs
                      ? jobCategoryControllerCubit
                      : isBuyAndSell
                          ? salesCategoryCubit
                          : null,
            ),
          ),
        );
      }),
    );
  }
}
