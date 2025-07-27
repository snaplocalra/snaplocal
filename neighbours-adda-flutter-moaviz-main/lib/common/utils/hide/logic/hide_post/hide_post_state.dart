part of 'hide_post_cubit.dart';

class HidePostState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;

  const HidePostState({
    this.requestLoading = false,
    this.requestSuccess = false,
  });

  @override
  List<Object> get props => [requestLoading, requestSuccess];

  HidePostState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
  }) {
    return HidePostState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
    );
  }
}
