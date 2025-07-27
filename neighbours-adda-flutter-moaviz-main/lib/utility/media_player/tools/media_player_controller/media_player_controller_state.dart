// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'media_player_controller_cubit.dart';

class MediaPlayerControllerState extends Equatable {
  final bool isLoading;
  final bool stopAllMedia;
  final bool playMediaAfterAllStop;
  final Key? playerKey;

  const MediaPlayerControllerState({
    this.isLoading = false,
    this.stopAllMedia = false,
    this.playMediaAfterAllStop = false,
    this.playerKey,
  });

  @override
  List<Object?> get props => [
        isLoading,
        stopAllMedia,
        playMediaAfterAllStop,
        playerKey,
      ];

  MediaPlayerControllerState copyWith({
    bool? isLoading,
    bool? stopAllMedia,
    bool? playMediaAfterAllStop,
    Key? playerKey,
  }) {
    return MediaPlayerControllerState(
      isLoading: isLoading ?? false,
      stopAllMedia: stopAllMedia ?? false,
      playMediaAfterAllStop: playMediaAfterAllStop ?? false,
      playerKey: playerKey,
    );
  }
}
