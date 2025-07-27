part of 'profile_level_cubit.dart';

sealed class ProfileLevelState extends Equatable {
  const ProfileLevelState();

  @override
  List<Object> get props => [];
}

final class ProfileLevelInitial extends ProfileLevelState {}

final class ProfileLevelLoading extends ProfileLevelState {}

final class ProfileLevelLoaded extends ProfileLevelState {
  final ProfileLevelModel profileLevel;

  const ProfileLevelLoaded(this.profileLevel);

  @override
  List<Object> get props => [profileLevel];
}

final class ProfileLevelError extends ProfileLevelState {
  final String message;

  const ProfileLevelError(this.message);

  @override
  List<Object> get props => [message];
}
