part of 'snaplocal_achievements_cubit.dart';

sealed class SnaplocalAchievementsState extends Equatable {
  const SnaplocalAchievementsState();

  @override
  List<Object> get props => [];
}

final class SnaplocalAchievementsInitial extends SnaplocalAchievementsState {}

final class SnaplocalAchievementsLoading extends SnaplocalAchievementsState {}

final class SnaplocalAchievementsLoaded extends SnaplocalAchievementsState {
  final AchievementsModel achievementsModel;

  const SnaplocalAchievementsLoaded(this.achievementsModel);

  @override
  List<Object> get props => [achievementsModel];
}

final class SnaplocalAchievementsError extends SnaplocalAchievementsState {
  final String message;

  const SnaplocalAchievementsError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
