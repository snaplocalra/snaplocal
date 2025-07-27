part of 'channel_overview_controller_cubit.dart';

sealed class ChannelOverviewControllerState extends Equatable {
  const ChannelOverviewControllerState();

  @override
  List<Object> get props => [];
}

final class ChannelOverviewControllerInitial
    extends ChannelOverviewControllerState {}

//Loading state
final class ChannelOverviewControllerLoading
    extends ChannelOverviewControllerState {}

//Success state
final class ChannelOverviewControllerSuccess
    extends ChannelOverviewControllerState {
  final NewsChannelOverViewModel newsChannelOverViewModel;

  const ChannelOverviewControllerSuccess(
      {required this.newsChannelOverViewModel});

  @override
  List<Object> get props => [newsChannelOverViewModel];
}

//Error state
final class ChannelOverviewControllerError
    extends ChannelOverviewControllerState {
  final String errorMessage;

  const ChannelOverviewControllerError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
