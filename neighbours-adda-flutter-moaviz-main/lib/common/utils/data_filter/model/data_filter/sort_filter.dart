import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SortFilter extends DataFilter {
  final List<SortFilterOption> sortFilterOptions;
  final SortFilterOption? selectedSortFilterOption;

  SortFilter({
    super.id = "1",
    required this.sortFilterOptions,
    this.selectedSortFilterOption,
    required super.filterName,
    super.isSelected = false,
    super.filterValue,
  });

  //clear filter
  @override
  SortFilter clearFilter() {
    return SortFilter(
      id: id,
      sortFilterOptions:
          sortFilterOptions.map((e) => e.copyWith(isSelected: false)).toList(),
      selectedSortFilterOption: null,
      filterName: filterName,
      filterValue: null,
      isSelected: false,
    );
  }

  //toMap
  @override
  Map<String, dynamic> toMap() {
    return {'sort_by': selectedSortFilterOption?.sortType.jsonValue};
  }

  SortFilter copyWith({
    bool? isSelected,
    List<SortFilterOption>? sortFilterOptions,
    SortFilterOption? selectedSortFilterOption,
    String? filterName,
    String? filterValue,
  }) {
    return SortFilter(
      id: id,
      isSelected: isSelected ?? this.isSelected,
      sortFilterOptions: sortFilterOptions ?? this.sortFilterOptions,
      selectedSortFilterOption:
          selectedSortFilterOption ?? this.selectedSortFilterOption,
      filterName: filterName ?? this.filterName,
      filterValue: filterValue ?? this.filterValue,
    );
  }

  @override
  DataFilter setFilter(DataFilterStrategy strategy) {
    return strategy.applyFilter(this);
  }
}

class SortFilterOption {
  final SortFilterType sortType;
  bool isSelected;

  SortFilterOption({required this.sortType, this.isSelected = false});

  SortFilterOption copyWith({
    SortFilterType? sortType,
    bool? isSelected,
  }) {
    return SortFilterOption(
      sortType: sortType ?? this.sortType,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

enum SortFilterType {
  relevance(jsonValue: "relevance", displayValue: "Relevance"),
  rating(jsonValue: "rating", displayValue: "Rating"),
  nearToFar(jsonValue: "near_to_far", displayValue: "Near to Far"),
  farToNear(jsonValue: "far_to_near", displayValue: "Far to Near"),
  mostFollowers(jsonValue: "most_followers", displayValue: "Most Followers"),
  mostMembers(jsonValue: "most_members", displayValue: "Most Members"),
  recentlyCreated(
      jsonValue: "recently_created", displayValue: "Recently Created"),
  alphabetical(jsonValue: "alphabetical", displayValue: "Alphabetical"),
  oldestCreated(jsonValue: "oldest_created", displayValue: "Oldest Created"),
  recentlyJoined(jsonValue: "recently_joined", displayValue: "Recently Joined"),
  oldestJoined(jsonValue: "oldest_joined", displayValue: "Oldest Joined"),
  latest(jsonValue: "latest", displayValue: "Latest"),
  voted(jsonValue: "voted", displayValue: "Voted"),
  distance(jsonValue: "distance", displayValue: "Distance"),
  oldest(jsonValue: "oldest", displayValue: "Oldest"),
  endDate(jsonValue: "end_date", displayValue: LocaleKeys.endDate),
  onlyCoupons(jsonValue: "only_coupons", displayValue: "Only Coupons"),
  date(jsonValue: "date", displayValue: "Date"),
  rsvpTime(jsonValue: "rsvp_time", displayValue: "RSVP Time"),
  highToLow(jsonValue: "high_to_low", displayValue: "High to Low"),
  lowToHigh(jsonValue: "low_to_high", displayValue: "Low to High"),
  newMessages(jsonValue: "new_messages", displayValue: "New Messages"),
  oldMessages(jsonValue: "old_messages", displayValue: "Old Messages"),
  unread(jsonValue: "unread", displayValue: "Unread"),
  today(jsonValue: "today", displayValue: "Today"),
  thisWeek(jsonValue: "this_week", displayValue: "This Week"),
  thisMonth(jsonValue: "this_month", displayValue: "This Month");

  final String jsonValue;
  final String displayValue;

  const SortFilterType({required this.jsonValue, required this.displayValue});

  factory SortFilterType.fromJson(String jsonValue) {
    return SortFilterType.values.firstWhere(
      (element) => element.jsonValue == jsonValue,
      orElse: () => throw Exception("Invalid json value"),
    );
  }
}
