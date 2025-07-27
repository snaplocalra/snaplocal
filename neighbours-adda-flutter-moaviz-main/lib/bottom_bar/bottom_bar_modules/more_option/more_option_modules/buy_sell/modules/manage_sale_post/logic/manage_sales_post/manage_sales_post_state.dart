// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_sales_post_cubit.dart';

class ManageSalesPostState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  const ManageSalesPostState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess];

  ManageSalesPostState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return ManageSalesPostState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
