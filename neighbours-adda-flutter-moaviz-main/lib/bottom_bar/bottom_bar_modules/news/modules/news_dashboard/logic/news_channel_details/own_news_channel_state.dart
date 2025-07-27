part of 'own_news_channel_cubit.dart';

class OwnNewsChannelState extends Equatable {
  const OwnNewsChannelState();
  @override
  List<Object> get props => [];
}

//Initial state of the own news channel
class OwnNewsChannelInitial extends OwnNewsChannelState {}

//State when the news channel is loading
class OwnNewsChannelLoading extends OwnNewsChannelState {}

//State when the news channel is loaded successfully
class OwnNewsChannelLoaded extends OwnNewsChannelState {
  final ManageNewsChannelModel? ownNewsChannel;
  const OwnNewsChannelLoaded({required this.ownNewsChannel});
  @override
  List<Object> get props => [if (ownNewsChannel != null) ownNewsChannel!];
}

//State when the news channel loading is failed
class OwnNewsChannelLoadFailed extends OwnNewsChannelState {
  final String errorMessage;
  const OwnNewsChannelLoadFailed({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
