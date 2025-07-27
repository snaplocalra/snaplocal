import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/general_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

//General filter strategy
class GeneralFilterStrategy implements DataFilterStrategy {
  final int targetCategoryIndex;

  GeneralFilterStrategy({required this.targetCategoryIndex});

  @override
  DataFilter applyFilter(DataFilter existingFilter) {
    GeneralFilter generalFilter = existingFilter as GeneralFilter;
    for (var i = 0; i < generalFilter.categories.length; i++) {
      // Get the category data from the general filter
      CategoryModel category = generalFilter.categories[i];

      // Check if the index is the same as the category index
      if (i == targetCategoryIndex) {
        // Set the category data to selected
        generalFilter = generalFilter.copyWith(
          filterValue: category.name,
          isSelected: true,
          selectedCategory: category,
        );

        // Set the category to selected
        generalFilter.categories[i] = category.copyWith(isSelected: true);
      } else {
        //update the category
        generalFilter.categories[i] = category.copyWith(isSelected: false);
      }
    }
    return generalFilter;
  }
}
