import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_preselection_strategy.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/category/v2/repository/category_repository.dart';

part 'category_controller_state.dart';

class CategoryControllerCubit extends Cubit<CategoryControllerState> {
  final CategoryType categoryType;
  CategoryControllerCubit(this.categoryType)
      : super(CategoryControllerInitial());

  late CategoryV2SelectStrategy categorySelectStrategy =
      categoryType.categorySelectStrategy;

  CategoryListModelV2 _serverCategories = const CategoryListModelV2(data: []);

  //Search keyword
  String _searchKeyword = '';

  //Search filter
  List<CategoryModelV2> searchFilter() {
    //1st load all categories
    List<CategoryModelV2> searchedCategories = _serverCategories.data;

    //2nd filter categories based on search keyword
    searchedCategories = _serverCategories.data
        .map((category) => category.copyWith(
            subCategories: category.subCategories
                .where((subCategory) => subCategory.name
                    .toLowerCase()
                    .contains(_searchKeyword.toLowerCase()))
                .toList()))
        .toList();
    return searchedCategories;
  }

  ///fetch categories v2
  Future<void> fetchCategories({
    CategoryV2PreselectionStrategy? preselectionStrategy,
  }) async {
    try {
      ///Check if data is already loaded, then return to avoid fetch data again
      if (state is CategoryControllerDataLoaded) {
        return;
      }
      emit(CategoryControllerDataLoading());
      print('Fetch Categories: ${categoryType.apiEndPoint}');
      _serverCategories =
          await CategoryRepository().fetchCategories(categoryType.apiEndPoint);

      //Add other type
      _serverCategories.addOtherTypeSubCategory();

      //Assign pre selected categories
      if (preselectionStrategy != null) {
        _serverCategories =
            _serverCategories.assignPreSelectedCategories(preselectionStrategy);
      }

      //Check for the pre selected categories
      emit(CategoryControllerDataLoaded(
        categories: _serverCategories,
        isFirstLoad: true,
      ));
    } catch (e) {
      emit(CategoryControllerDataError(e.toString()));
    }
  }

  ///Select sub category on 1st click, then remove selected sub category on 2nd click.

  ///User can select upto 2 sub categories, from all the categories.
  void selectSubCategory(
    String categoryId,
    String subCategoryId, {
    String? otherTypeName,
  }) {
    final currentState = state;
    if (currentState is CategoryControllerDataLoaded) {
      emit(CategoryControllerDataLoading());
      categorySelectStrategy.selectSubCategory(
        categoryId,
        subCategoryId,
        categories: _serverCategories,
        otherTypeName: otherTypeName,
      );

      //check for search filter categories
      final searchFilterCategories = searchFilter();
      emit(CategoryControllerDataLoaded(
        categories: CategoryListModelV2(data: searchFilterCategories),
      ));
    }
  }

  ///Search sub category
  void searchSubCategory(String query) {
    _searchKeyword = query;
    final currentState = state;
    if (_searchKeyword.isEmpty) {
      clearSearch();
    } else if (currentState is CategoryControllerDataLoaded) {
      emit(CategoryControllerDataLoading());
      final searchedCategories = searchFilter();
      emit(CategoryControllerDataLoaded(
        categories: CategoryListModelV2(data: searchedCategories),
      ));
    }
  }

  ///Clear all selection
  ///Clear all the selected sub categories
  void clearAllSelection() {
    final currentState = state;
    if (currentState is CategoryControllerDataLoaded) {
      emit(CategoryControllerDataLoading());

      //Clear all selection
      _serverCategories.clearAllSelection();

      emit(CategoryControllerDataLoaded(categories: _serverCategories));
    }
  }

  //Clear search
  void clearSearch() {
    if (state is CategoryControllerDataLoaded) {
      _searchKeyword = '';
      emit(CategoryControllerDataLoading());
      emit(CategoryControllerDataLoaded(categories: _serverCategories));
    }
  }

  //category map
  Map<String, dynamic> get categoryMap =>
      {"category": _serverCategories.selectedDataMap};
}
