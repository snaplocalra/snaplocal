// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'upload_general_post_cubit.dart';

class UploadGeneralPostState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  const UploadGeneralPostState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess];

  UploadGeneralPostState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return UploadGeneralPostState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
