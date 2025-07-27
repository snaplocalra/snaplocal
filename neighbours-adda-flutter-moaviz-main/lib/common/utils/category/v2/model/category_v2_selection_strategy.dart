import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

abstract class CategoryV2SelectStrategy {
  void selectSubCategory(
    String categoryId,
    String subCategoryId, {
    required CategoryListModelV2 categories,
    String? otherTypeName,
  });
}

///Dual Subcategory selection strategy, where user can select upto 2 sub categories from all the categories.
///User can select sub category on 1st click, then remove selected sub category on 2nd click.
///If max limit is reached, then if user tries to select more sub categories, then the previously selected sub category will be removed and
///new sub category will be selected.
class DualSubCategorySelectionStrategy
    implements CategoryV2SelectStrategy, OtherTypeSubCategorySelectionStrategy {
  @override
  void selectSubCategory(
    String categoryId,
    String subCategoryId, {
    required CategoryListModelV2 categories,
    String? otherTypeName,
  }) {
    // This method first checks if the selected subcategory is already selected or if the total number of selected subcategories across all categories is less than 2.
    // If either of these conditions is true, it toggles the selected state of the subcategory.
    // Otherwise, it finds the last selected subcategory across all categories, deselects it, and then selects the new subcategory.

    final selectedCategory =
        categories.data.firstWhere((category) => category.id == categoryId);
    final selectedSubCategory = selectedCategory.subCategories
        .firstWhere((subCategory) => subCategory.id == subCategoryId);

    if (selectedSubCategory.isSelected ||
        categories.data
                .expand((category) => category.subCategories)
                .where((subCategory) => subCategory.isSelected)
                .length <
            2) {
      selectedSubCategory.isSelected = !selectedSubCategory.isSelected;
    } else {
      categories.data
          .firstWhere((category) => category.subCategories
              .any((subCategory) => subCategory.isSelected))
          .subCategories
          .lastWhere((subCategory) => subCategory.isSelected)
          .isSelected = false;
      selectedSubCategory.isSelected = true;
    }

    if (selectedSubCategory.isOtherType) {
      //Other type categoy handler
      if (otherTypeName != null) {
        selectedSubCategory.name = otherTypeName;
      } else {
        selectedSubCategory.name = SubCategoryModel.otherName;
      }
    }
  }
}

///Multiple Subcategory selection strategy, where user can select multiple sub categories from all the categories.
class MultieSubCategorySelectionStrategy implements CategoryV2SelectStrategy {
  @override
  void selectSubCategory(
    String categoryId,
    String subCategoryId, {
    required CategoryListModelV2 categories,
    String? otherTypeName,
  }) {
    // Find the selected category
    final selectedCategory =
        categories.data.firstWhere((category) => category.id == categoryId);

    // Find the selected subcategory from the selected category
    final selectedSubCategory = selectedCategory.subCategories
        .firstWhere((subCategory) => subCategory.id == subCategoryId);

    // Toggle the selected state of the subcategory
    selectedSubCategory.isSelected = !selectedSubCategory.isSelected;
  }
}

///Single Subcategory selection strategy, where user can select only one sub category from all the categories.
class SingleSubCategorySelectionStrategy
    implements CategoryV2SelectStrategy, OtherTypeSubCategorySelectionStrategy {
  @override
  void selectSubCategory(
    String categoryId,
    String subCategoryId, {
    required CategoryListModelV2 categories,
    String? otherTypeName,
  }) {
    //remove all the selected sub categories from all the categories
    for (var category in categories.data) {
      for (var subCategory in category.subCategories) {
        subCategory.isSelected = false;
      }
    }

    // Find the selected category
    final selectedCategory =
        categories.data.firstWhere((category) => category.id == categoryId);

    // Find the selected subcategory from the selected category
    final selectedSubCategory = selectedCategory.subCategories
        .firstWhere((subCategory) => subCategory.id == subCategoryId);

    // Select the user selected subcategory
    selectedSubCategory.isSelected = true;

    if (selectedSubCategory.isOtherType) {
      //Other type categoy handler
      if (otherTypeName != null) {
        selectedSubCategory.name = otherTypeName;
      } else {
        selectedSubCategory.name = SubCategoryModel.otherName;
      }
    }
  }
}

//Other type sub category selection strategy
class OtherTypeSubCategorySelectionStrategy {}
