// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:snap_local/utility/constant/assets_sounds.dart';

// part 'reaction_audio_effect_controller_state.dart';

// class ReactionAudioEffectControllerCubit
//     extends Cubit<ReactionAudioEffectControllerState> {
//   // final AudioPlayer audioPlayer;
//   ReactionAudioEffectControllerCubit(this.audioPlayer)
//       : super(const ReactionAudioEffectControllerState());

//   Future<void> _initReactionEffectPlayer() async {
//     await audioPlayer.setAsset(AssetsSounds.facebookLikeSoundEffect);
//     await audioPlayer.setVolume(1);
//   }

//   Future<void> playReactionSound() async {
//     await _initReactionEffectPlayer();
//     await audioPlayer.play();
//   }

//   @override
//   Future<void> close() async {
//     await audioPlayer.dispose();
//     return super.close();
//   }
// }
