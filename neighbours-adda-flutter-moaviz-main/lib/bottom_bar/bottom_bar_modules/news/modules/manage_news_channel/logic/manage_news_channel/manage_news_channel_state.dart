part of 'manage_news_channel_cubit.dart';

class ManageNewsChannelState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;

  const ManageNewsChannelState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, isRequestSuccess];

  ManageNewsChannelState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return ManageNewsChannelState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
