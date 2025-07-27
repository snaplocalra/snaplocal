// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_group_cubit.dart';

class ManageGroupState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  const ManageGroupState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess];

  ManageGroupState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return ManageGroupState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
