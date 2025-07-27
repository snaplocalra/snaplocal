// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_business_cubit.dart';

class ManageBusinessState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;

  //delete
  final bool isDeleteLoading;
  final bool isDeleteSuccess;
  const ManageBusinessState({
    this.isLoading = false,
    this.isRequestSuccess = false,
    this.isDeleteLoading = false,
    this.isDeleteSuccess = false,
  });

  @override
  List<Object> get props =>
      [isLoading, isRequestSuccess, isDeleteLoading, isDeleteSuccess];

  ManageBusinessState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
    bool? isDeleteLoading,
    bool? isDeleteSuccess,
  }) {
    return ManageBusinessState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
      isDeleteLoading: isDeleteLoading ?? false,
      isDeleteSuccess: isDeleteSuccess ?? false,
    );
  }
}
