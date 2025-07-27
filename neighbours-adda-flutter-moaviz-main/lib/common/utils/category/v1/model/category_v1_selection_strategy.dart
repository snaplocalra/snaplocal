import 'package:snap_local/common/utils/category/v1/model/category_model.dart';

abstract class CategoryV1SelectStrategy {
  void selectCategory(
    String categoryId, {
    required CategoryListModel categories,
  });
}

///Multiple category selection strategy, where user can select multiple categories.
class MultieCategorySelectionStrategy implements CategoryV1SelectStrategy {
  @override
  void selectCategory(
    String categoryId, {
    required CategoryListModel categories,
  }) {
    // This method toggles the selected state of the category.
    final selectedCategory =
        categories.data.firstWhere((category) => category.id == categoryId);
    selectedCategory.isSelected = !selectedCategory.isSelected;
  }
}

///Single category selection strategy, where user can select only one category at a time.
class SingleCategorySelectionStrategy implements CategoryV1SelectStrategy {
  @override
  void selectCategory(
    String categoryId, {
    required CategoryListModel categories,
  }) {
    // This method first deselects all categories and then selects the category that the user clicked.
    for (var category in categories.data) {
      category.isSelected = false;
    }
    final selectedCategory =
        categories.data.firstWhere((category) => category.id == categoryId);
    selectedCategory.isSelected = true;
  }
}
