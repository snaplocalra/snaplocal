part of 'share_the_post_cubit.dart';

class ShareThePostState extends Equatable {
  final bool isRequestProcessing;
  final bool isRequestSuccess;
  const ShareThePostState({
    this.isRequestProcessing = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isRequestProcessing, isRequestSuccess];

  ShareThePostState copyWith({
    bool? isRequestProcessing,
    bool? isRequestSuccess,
  }) {
    return ShareThePostState(
      isRequestProcessing: isRequestProcessing ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
