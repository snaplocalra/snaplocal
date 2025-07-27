part of 'check_news_post_limit_cubit.dart';

sealed class CheckNewsPostLimitState extends Equatable {
  const CheckNewsPostLimitState();

  @override
  List<Object> get props => [];
}

final class CheckNewsPostLimitInitial extends CheckNewsPostLimitState {}

final class CheckNewsPostLimitLoading extends CheckNewsPostLimitState {}

final class CheckNewsPostLimitLoaded extends CheckNewsPostLimitState {
  final CheckNewsPostLimitModel checkNewsPostLimitModel;

  const CheckNewsPostLimitLoaded(this.checkNewsPostLimitModel);

  @override
  List<Object> get props => [checkNewsPostLimitModel];
}

final class CheckNewsPostLimitFailure extends CheckNewsPostLimitState {
  final String errorMessage;

  const CheckNewsPostLimitFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
