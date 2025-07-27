import 'package:collection/collection.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';

abstract class CategoryV2PreselectionStrategy {
  CategoryListModelV2 preselectCategories(List<CategoryModelV2> data);
}

class CategoryV2PreselectionFromListModel
    implements CategoryV2PreselectionStrategy {
  final CategoryListModelV2 preSelectedCategories;

  CategoryV2PreselectionFromListModel(this.preSelectedCategories);

  @override
  CategoryListModelV2 preselectCategories(List<CategoryModelV2> data) {
    final preSelectedMap = {
      for (var category in preSelectedCategories.data)
        category.id: category.subCategories
    };

    return CategoryListModelV2(
      data: data.map((category) {
        final updatedSubCategories = category.subCategories.map((subCategory) {
          final preSelectedSubCategory = preSelectedMap[category.id]
              ?.firstWhereOrNull(
                  (preSelected) => preSelected.id == subCategory.id);

          return preSelectedSubCategory != null
              ? subCategory.copyWith(
                  isSelected: true,
                  name: preSelectedSubCategory.name,
                )
              : subCategory;
        }).toList();

        return category.copyWith(subCategories: updatedSubCategories);
      }).toList(),
    );
  }
}

class CategoryV2PreselectionFromCategoryModelV3
    implements CategoryV2PreselectionStrategy {
  final CategoryModelV3 preSelectedCategory;

  CategoryV2PreselectionFromCategoryModelV3(this.preSelectedCategory);

  @override
  CategoryListModelV2 preselectCategories(List<CategoryModelV2> data) {
    return CategoryListModelV2(
      data: data.map((category) {
        if (category.id == preSelectedCategory.id) {
          return category.copyWith(
            subCategories: category.subCategories.map((subCategory) {
              return subCategory.id == preSelectedCategory.subCategory.id
                  ? subCategory.copyWith(isSelected: true)
                  : subCategory;
            }).toList(),
          );
        }
        return category;
      }).toList(),
    );
  }
}
