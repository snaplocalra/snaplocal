part of 'saved_item_cubit.dart';

class SavedItemState extends Equatable {
  final bool dataLoading;
  final String? error;
  final SavedItemModel? savedItemModel;
  const SavedItemState({
    this.dataLoading = false,
    this.error,
    this.savedItemModel,
  });

  @override
  List<Object?> get props => [dataLoading, error, savedItemModel];

  bool get savedItemModelAvailable => savedItemModel != null;

  bool get isSavedItemDataEmpty =>
      savedItemModel != null &&
      (savedItemModel!.postsList.isEmpty &&
          savedItemModel!.jobsShortDetailsList.isEmpty &&
          savedItemModel!.salesPostShortDetailsList.isEmpty);

  SavedItemState copyWith({
    bool? dataLoading,
    String? error,
    SavedItemModel? savedItemModel,
  }) {
    return SavedItemState(
      dataLoading: dataLoading ?? false,
      error: error,
      savedItemModel: savedItemModel ?? this.savedItemModel,
    );
  }
}
