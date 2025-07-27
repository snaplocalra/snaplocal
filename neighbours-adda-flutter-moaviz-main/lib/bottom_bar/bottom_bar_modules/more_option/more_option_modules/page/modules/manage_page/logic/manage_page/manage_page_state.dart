// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_page_cubit.dart';

class ManagePageState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;

  //delete
  final bool deleteLoading;
  final bool deleteSuccess;
  //block
  final bool toggleBlockLoading;
  final bool toggleBlockSuccess;
  const ManagePageState({
    this.isLoading = false,
    this.isRequestSuccess = false,
    this.deleteLoading = false,
    this.deleteSuccess = false,
    this.toggleBlockLoading = false,
    this.toggleBlockSuccess = false,
  });

  @override
  List<Object> get props => [
        isLoading,
        isRequestSuccess,
        deleteLoading,
        deleteSuccess,
        toggleBlockLoading,
        toggleBlockSuccess
      ];

  ManagePageState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
    bool? deleteLoading,
    bool? deleteSuccess,
    bool? toggleBlockLoading,
    bool? toggleBlockSuccess,
  }) {
    return ManagePageState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
      deleteLoading: deleteLoading ?? false,
      deleteSuccess: deleteSuccess ?? false,
      toggleBlockLoading: toggleBlockLoading ?? false,
      toggleBlockSuccess: toggleBlockSuccess ?? false,
    );
  }
}
