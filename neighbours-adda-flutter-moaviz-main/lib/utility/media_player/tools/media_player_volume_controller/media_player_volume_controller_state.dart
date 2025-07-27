part of 'media_player_volume_controller_cubit.dart';

sealed class MediaPlayerVolumeControllerState extends Equatable {
  const MediaPlayerVolumeControllerState();

  @override
  List<Object> get props => [];
}

final class LoadingMediaPlayerVolume extends MediaPlayerVolumeControllerState {}

final class MuteMediaPlayerVolume extends MediaPlayerVolumeControllerState {}

final class UnMuteMediaPlayerVolume extends MediaPlayerVolumeControllerState {}
