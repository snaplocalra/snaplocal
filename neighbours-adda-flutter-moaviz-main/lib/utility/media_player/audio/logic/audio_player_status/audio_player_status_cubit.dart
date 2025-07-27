import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'audio_player_status_state.dart';

class AudioPlayerStatusCubit extends Cubit<AudioPlayerStatusState> {
  AudioPlayerStatusCubit()
      : super(const AudioPlayerStatusState(AudioPlayerStatus.loading));

  void setReady() {
    emit(const AudioPlayerStatusState(AudioPlayerStatus.ready));
  }

  void setLoading() {
    emit(const AudioPlayerStatusState(AudioPlayerStatus.loading));
  }
}
