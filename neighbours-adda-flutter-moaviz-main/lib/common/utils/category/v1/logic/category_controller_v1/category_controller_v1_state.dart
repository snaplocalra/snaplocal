part of 'category_controller_v1_cubit.dart';

class CategoryControllerV1State extends Equatable {
  final bool dataLoading;
  final String? error;
  final bool assignCategory;
  final CategoryListModel categoriesListModel;
  const CategoryControllerV1State({
    this.error,
    this.dataLoading = false,
    this.assignCategory = false,
    required this.categoriesListModel,
  });

  @override
  List<Object?> get props =>
      [categoriesListModel, dataLoading, error, assignCategory];

  CategoryControllerV1State copyWith({
    bool? dataLoading,
    String? error,
    CategoryListModel? categoriesListModel,
    bool? assignCategory,
  }) {
    return CategoryControllerV1State(
      dataLoading: dataLoading ?? false,
      assignCategory: assignCategory ?? false,
      error: error,
      categoriesListModel: categoriesListModel ?? this.categoriesListModel,
    );
  }

  // selected category map
  Map<String, dynamic> get selectedCategoryMap => {
        'category_id_list': categoriesListModel.data
            .where((element) => element.isSelected)
            .map((e) => e.id)
            .join(','),
      };

  // is any category selected
  bool get isAnyCategorySelected =>
      categoriesListModel.data.any((element) => element.isSelected);

  //get the 1st selected category index
  int? get firstSelectedCategoryIndex =>
      categoriesListModel.data.indexWhere((element) => element.isSelected);
}
