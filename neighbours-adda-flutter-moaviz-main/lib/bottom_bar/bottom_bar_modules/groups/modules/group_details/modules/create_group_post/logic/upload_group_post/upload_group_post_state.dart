// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'upload_group_post_cubit.dart';

class UploadGroupPostState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  const UploadGroupPostState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess];

  UploadGroupPostState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return UploadGroupPostState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
