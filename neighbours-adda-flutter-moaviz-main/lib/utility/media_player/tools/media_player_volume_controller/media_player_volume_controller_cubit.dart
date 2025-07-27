import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volume_controller/volume_controller.dart';

part 'media_player_volume_controller_state.dart';

class MediaPlayerVolumeControllerCubit
    extends Cubit<MediaPlayerVolumeControllerState> {
  MediaPlayerVolumeControllerCubit() : super(MuteMediaPlayerVolume()) {
    listenForVolumeControlChange();
  }

  bool initialized = false;

  //Listen for Volume control change
  void listenForVolumeControlChange() {
    VolumeController.instance.addListener((volume) {
      if (volume == 0 && initialized) {
        muteMediaPlayerSound();
      } else if (initialized) {
        unMuteMediaPlayerSound();
      }

      //Set the initialized to true
      initialized = true;
    });
  }

  void muteMediaPlayerSound() {
    emit(LoadingMediaPlayerVolume());
    emit(MuteMediaPlayerVolume());
  }

  void unMuteMediaPlayerSound() {
    emit(LoadingMediaPlayerVolume());
    emit(UnMuteMediaPlayerVolume());
  }
}
