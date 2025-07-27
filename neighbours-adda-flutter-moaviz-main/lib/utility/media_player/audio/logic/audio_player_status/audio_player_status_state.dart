part of 'audio_player_status_cubit.dart';

enum AudioPlayerStatus { loading, ready }

class AudioPlayerStatusState extends Equatable {
  final AudioPlayerStatus status;

  const AudioPlayerStatusState(this.status);

  @override
  List<Object?> get props => [status];
}
