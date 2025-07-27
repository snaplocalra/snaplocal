// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'upload_page_post_cubit.dart';

class UploadPagePostState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  const UploadPagePostState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess];

  UploadPagePostState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return UploadPagePostState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
