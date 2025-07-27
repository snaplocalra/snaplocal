import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'media_player_controller_state.dart';

class MediaPlayerControllerCubit extends Cubit<MediaPlayerControllerState> {
  MediaPlayerControllerCubit() : super(const MediaPlayerControllerState());

  void stopAllMedia({
    playMediaAfterAllStop = false,
    Key? playerKey,
  }) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(
      stopAllMedia: true,
      playMediaAfterAllStop: playMediaAfterAllStop,
      playerKey: playerKey,
    ));
  }
}
