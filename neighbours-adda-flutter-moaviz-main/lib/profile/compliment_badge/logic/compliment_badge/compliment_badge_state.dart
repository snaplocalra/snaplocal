part of 'compliment_badge_cubit.dart';

sealed class ComplimentBadgeState extends Equatable {
  const ComplimentBadgeState();

  @override
  List<Object> get props => [];
}

final class ComplimentBadgeInitial extends ComplimentBadgeState {}

final class ComplimentBadgeLoading extends ComplimentBadgeState {}

final class ComplimentBadgeLoaded extends ComplimentBadgeState {
  final List<ComplimentBadgeModel> complimentBadges;

  const ComplimentBadgeLoaded(this.complimentBadges);

  @override
  List<Object> get props => [complimentBadges];
}

final class ComplimentBadgeError extends ComplimentBadgeState {
  final String message;

  const ComplimentBadgeError(this.message);

  @override
  List<Object> get props => [message];
}
