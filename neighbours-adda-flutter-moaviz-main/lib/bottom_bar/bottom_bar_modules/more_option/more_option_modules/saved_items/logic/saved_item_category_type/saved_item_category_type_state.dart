part of 'saved_item_category_type_cubit.dart';

class SavedItemCategoryTypeState extends Equatable {
  final bool dataLoading;
  final String? error;
  final SavedItemTypeListModel savedItemTypeListModel;
  const SavedItemCategoryTypeState({
    this.dataLoading = false,
    this.error,
    required this.savedItemTypeListModel,
  });

  @override
  List<Object?> get props => [savedItemTypeListModel, dataLoading, error];

  SavedItemCategoryTypeState copyWith({
    bool? dataLoading,
    String? error,
    SavedItemTypeListModel? savedItemTypeListModel,
  }) {
    return SavedItemCategoryTypeState(
      dataLoading: dataLoading ?? false,
      error: error,
      savedItemTypeListModel:
          savedItemTypeListModel ?? this.savedItemTypeListModel,
    );
  }
}
