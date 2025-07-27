import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_status_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/item_condition_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sell_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_status_enum.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/general_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class FilterData {
  //Sort filter

  //business sort filter
  List<SortFilterOption> businessSortFilter = [
    SortFilterOption(sortType: SortFilterType.relevance),
    SortFilterOption(sortType: SortFilterType.rating),
    SortFilterOption(sortType: SortFilterType.nearToFar),
    SortFilterOption(sortType: SortFilterType.farToNear),
  ];

  //buy sell sort filter
  List<SortFilterOption> buySellSortFilter = [
    SortFilterOption(sortType: SortFilterType.lowToHigh),
    SortFilterOption(sortType: SortFilterType.highToLow),
    SortFilterOption(sortType: SortFilterType.nearToFar),
    SortFilterOption(sortType: SortFilterType.farToNear),
  ];

  //job sort filter
  List<SortFilterOption> jobSortFilter = [
    SortFilterOption(sortType: SortFilterType.latest),
    SortFilterOption(sortType: SortFilterType.distance),
    SortFilterOption(sortType: SortFilterType.relevance),
  ];

  //event sort filter
  List<SortFilterOption> eventSortFilter = [
    SortFilterOption(sortType: SortFilterType.relevance),
    SortFilterOption(sortType: SortFilterType.date),
    SortFilterOption(sortType: SortFilterType.distance),
  ];

  //category wise social sort filter
  List<SortFilterOption> socialSortFilter = [
    SortFilterOption(sortType: SortFilterType.latest),
    SortFilterOption(sortType: SortFilterType.oldest),
    SortFilterOption(sortType: SortFilterType.nearToFar),
    SortFilterOption(sortType: SortFilterType.farToNear),
  ];

  //page search sort filter
  List<SortFilterOption> pageSearchSortFilter = [
    SortFilterOption(sortType: SortFilterType.relevance),
    SortFilterOption(sortType: SortFilterType.mostFollowers),
    SortFilterOption(sortType: SortFilterType.recentlyCreated),
    SortFilterOption(sortType: SortFilterType.alphabetical),
    SortFilterOption(sortType: SortFilterType.oldestCreated),
  ];

  //group search sort filter
  List<SortFilterOption> groupSearchSortFilter = [
    SortFilterOption(sortType: SortFilterType.relevance),
    SortFilterOption(sortType: SortFilterType.mostMembers),
    SortFilterOption(sortType: SortFilterType.recentlyCreated),
    SortFilterOption(sortType: SortFilterType.alphabetical),
    SortFilterOption(sortType: SortFilterType.oldestCreated),
  ];

  //group type filter
  List<GeneralFilter> groupTypeFilter = [
    GeneralFilter(
      filterName: tr(LocaleKeys.groupType),
      jsonKey: "group_type",
      categories: [
        CategoryModel.allType(),
        CategoryModel(
          id: "public",
          name: tr(LocaleKeys.public),
        ),
        CategoryModel(
          id: "private",
          name: tr(LocaleKeys.private),
        ),
      ],
    ),
  ];

  //BUSINESS
  // business status filter
  List<GeneralFilter> businessStatusFilter = [
    GeneralFilter(
      filterName: tr(LocaleKeys.status),
      jsonKey: "business_status",
      categories: [
        CategoryModel.allType(),
        CategoryModel(
          id: BusinessStatus.open.jsonValue,
          name: BusinessStatus.open.displayValue,
        ),
        CategoryModel(
          id: BusinessStatus.closed.jsonValue,
          name: BusinessStatus.closed.displayValue,
        ),
      ],
    ),
  ];

  //BUY SELL
  // condition type filter
  List<GeneralFilter> conditionTypeFilter = [
    GeneralFilter(
      filterName: tr(LocaleKeys.condition),
      jsonKey: "condition_type",
      categories: [
        ItemCondition.all,
        ItemCondition.brandNew,
        ItemCondition.likeNew,
        ItemCondition.used,
        ItemCondition.fair,
      ]
          .map((e) => CategoryModel(
                id: e.json,
                name: e.displayName,
              ))
          .toList(),
    ),
  ];

  // sale type filter
  List<GeneralFilter> saleTypeFilter = [
    GeneralFilter(
      filterName: tr(LocaleKeys.saleType),
      jsonKey: "sale_type",
      categories: [
        CategoryModel.allType(),
        ...<SellType>[SellType.sell, SellType.free].map(
          (e) => CategoryModel(
            id: e.json,
            name: e.displayName,
          ),
        )
      ],
    ),
  ];

  //EVENT
  // event status filter
  List<GeneralFilter> eventStatusFilter = [
    GeneralFilter(
      filterName: tr(LocaleKeys.eventStatus),
      jsonKey: "event_status",
      categories: [
        CategoryModel.allType(),
        CategoryModel(
          id: EventStatus.upcoming.jsonValue,
          name: EventStatus.upcoming.displayValue,
        ),
        CategoryModel(
          id: EventStatus.ongoing.jsonValue,
          name: EventStatus.ongoing.displayValue,
        ),
        CategoryModel(
          id: EventStatus.past.jsonValue,
          name: EventStatus.past.displayValue,
        ),
      ],
    ),
  ];
}
