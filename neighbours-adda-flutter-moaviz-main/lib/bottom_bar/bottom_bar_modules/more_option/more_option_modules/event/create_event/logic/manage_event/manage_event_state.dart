// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_event_cubit.dart';

class ManageEventState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  final bool isRequestFailed;

  const ManageEventState({
    this.isLoading = false,
    this.isRequestSuccess = false,
    this.isRequestFailed = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess, isRequestFailed];

  ManageEventState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
    bool? isRequestFailed,
  }) {
    return ManageEventState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
      isRequestFailed: isRequestFailed ?? false,
    );
  }
}
