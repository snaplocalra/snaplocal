import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

//Category filter strategy
class CategoryFilterStrategy implements DataFilterStrategy {
  CategoryFilterStrategy();

  @override
  DataFilter applyFilter(DataFilter existingFilter) {
    CategoryFilter categoryFilter = existingFilter as CategoryFilter;

    //if any of the sub categories is selected, then make the filter selected
    //if none of the sub categories is selected, then make the filter unselected
    categoryFilter = categoryFilter.copyWith(
      isSelected: ((categoryFilter.categoryControllerCubit.state)
              as CategoryControllerDataLoaded)
          .categories.data
          .any((category) => category.subCategories
              .any((subCategory) => subCategory.isSelected)),
    );

    return categoryFilter;
  }
}
