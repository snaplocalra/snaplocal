import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/home_search_type.dart';

class ExploreTypeListModel extends Equatable {
  final List<ExploreType> data;

  const ExploreTypeListModel({required this.data});

  @override
  List<Object?> get props => [data];

  ExploreType? get selectedData {
    for (var homeSearchType in data) {
      if (homeSearchType.isSelected) {
        return homeSearchType;
      }
    }
    return null;
  }
}

class ExploreType {
  final ExploreCategoryTypeEnum homeSearchCategoryTypeEnum;
  bool isSelected;

  ExploreType({
    required this.homeSearchCategoryTypeEnum,
    this.isSelected = false,
  });
}
