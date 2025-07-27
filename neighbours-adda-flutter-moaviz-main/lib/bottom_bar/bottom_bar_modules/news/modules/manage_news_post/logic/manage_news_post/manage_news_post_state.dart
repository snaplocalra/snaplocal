part of 'manage_news_post_cubit.dart';

class ManageNewsPostState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;

  // Delete related states
  final bool deleteLoading;
  final bool deleteSuccess;

  const ManageNewsPostState({
    this.isLoading = false,
    this.isRequestSuccess = false,
    this.deleteLoading = false,
    this.deleteSuccess = false,
  });

  @override
  List<Object?> get props =>
      [isLoading, isRequestSuccess, deleteLoading, deleteSuccess];

  ManageNewsPostState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
    bool? deleteLoading,
    bool? deleteSuccess,
  }) {
    return ManageNewsPostState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
      deleteLoading: deleteLoading ?? false,
      deleteSuccess: deleteSuccess ?? false,
    );
  }
}
