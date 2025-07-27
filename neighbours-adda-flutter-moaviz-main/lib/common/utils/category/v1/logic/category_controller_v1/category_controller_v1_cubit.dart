import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_type_v1.dart';
import 'package:snap_local/common/utils/category/v1/repository/category_v1_repository.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'category_controller_v1_state.dart';

class CategoryControllerV1Cubit extends Cubit<CategoryControllerV1State> {
  final CategoryV1Type categoryV1Type;
  CategoryControllerV1Cubit(this.categoryV1Type)
      : super(const CategoryControllerV1State(
            categoriesListModel: CategoryListModel(data: [])));

  CategoryListModel _serverCategoryModel = const CategoryListModel(data: []);

  //Search keyword
  String _searchKeyword = '';

  //Search filter
  List<CategoryModel> searchFilter() {
    //1st load all categories
    List<CategoryModel> searchedCategories = _serverCategoryModel.data;

    //2nd filter categories based on search keyword
    searchedCategories = _serverCategoryModel.data
        .where(
          (category) => category.name
              .toLowerCase()
              .contains(_searchKeyword.toLowerCase()),
        )
        .toList();
    return searchedCategories;
  }

  //search category
  void searchCategory(String query) {
    _searchKeyword = query;
    if (_searchKeyword.isEmpty) {
      _clearSearch();
    } else {
      //loading state
      emit(state.copyWith(dataLoading: true));
      final searchedCategories = searchFilter();
      emit(state.copyWith(
          categoriesListModel: CategoryListModel(data: searchedCategories)));
    }
  }

  //Clear search
  void _clearSearch() {
    emit(state.copyWith(dataLoading: true));
    emit(state.copyWith(categoriesListModel: _serverCategoryModel));
  }

  //Reset search
  void resetSearch() {
    _searchKeyword = '';
    _clearSearch();
  }

  Future<void> fetchCategories({
    String? categoryId,
    bool dataPreSelect = false,
    bool enableAllType = false,
  }) async {
    try {
      if (state.categoriesListModel.data.isEmpty) {
        emit(state.copyWith(dataLoading: true));
        _serverCategoryModel = await CategoryV1Repository()
            .fetchCategory(categoryV1Type.apiEndPoint);

        if (enableAllType) {
          //Insert as the 1st element
          _serverCategoryModel.data
              .insert(0, CategoryModel(id: "", name: tr(LocaleKeys.all)));
        }
      }

      //Emit state to store initial data
      emit(state.copyWith(categoriesListModel: _serverCategoryModel));

      //Pre select the data and emit
      if (dataPreSelect && _serverCategoryModel.data.isNotEmpty) {
        if (categoryId != null) {
          //select the given category type by default
          selectCategory(categoryId);
        } else {
          //select the 1st category type by default
          selectCategory(_serverCategoryModel.data.first.id);
        }
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }

  void selectCategory(String categoryId) {
    if (_serverCategoryModel.data.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));

      categoryV1Type.categorySelectStrategy
          .selectCategory(categoryId, categories: _serverCategoryModel);

      //Check with search filter
      final searchedCategories = searchFilter();

      emit(
        state.copyWith(
          categoriesListModel: CategoryListModel(data: searchedCategories),
          assignCategory: true,
        ),
      );
    }
  }

  //Selected data list of category
  List<CategoryModel> get selectedDataList =>
      _serverCategoryModel.data.where((element) => element.isSelected).toList();

  //clear all selected category
  void clearAllSelectedCategory() {
    emit(state.copyWith(dataLoading: true));
    for (var category in _serverCategoryModel.data) {
      category.isSelected = false;
    }
    emit(state.copyWith(
        categoriesListModel: CategoryListModel(data: _serverCategoryModel.data),
        assignCategory: true));
  }

  //Selected 1st data of category
  CategoryModel? get selectedFirstData {
    for (var category in _serverCategoryModel.data) {
      if (category.isSelected) {
        return category;
      }
    }
    return null;
  }
}
