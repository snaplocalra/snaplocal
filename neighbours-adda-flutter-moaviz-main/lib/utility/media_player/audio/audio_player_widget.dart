// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:snap_local/utility/media_player/audio/logic/audio_player_status/audio_player_status_cubit.dart';
// import 'package:snap_local/utility/media_player/tools/media_player_controller/media_player_controller_cubit.dart';
// import 'package:snap_local/utility/media_player/tools/player_time_formatter.dart';

// class AudioPlayerWidget extends StatefulWidget {
//   final String? audioUrl;
//   final File? audioFile;
//   final Color? iconColor;
//   final Color? textColor;
//   final bool enableBorder;
//   const AudioPlayerWidget({
//     super.key,
//     this.audioUrl,
//     this.audioFile,
//     this.iconColor,
//     this.textColor,
//     this.enableBorder = false,
//   });

//   @override
//   State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   final audioPlayerStatusCubit = AudioPlayerStatusCubit();

//   AudioPlayer audioPlayer = AudioPlayer();
//   bool isPlaying = false;

//   Duration? duration;
//   Duration? position;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       await initializeAudioPlayer();
//     });
//   }

//   void enableAudioPlayer() {
//     audioPlayerStatusCubit.setReady();
//   }

//   Future<void> setPositionDurationVolume() async {
//     duration = audioPlayer.duration;
//     position = audioPlayer.position;
//     await audioPlayer.setVolume(1);
//   }

//   Future<void> initializeAudioPlayer() async {
//     if (widget.audioFile != null) {
//       // Initialize the audio player with the file
//       await audioPlayer.setFilePath(widget.audioFile!.path);
//       await setPositionDurationVolume();
//       enableAudioPlayer();
//     } else if (widget.audioUrl != null) {
//       // Initialize the audio player with the URL
//       await audioPlayer.setUrl(widget.audioUrl!);
//       await setPositionDurationVolume();
//       enableAudioPlayer();
//     } else {
//       throw ("Playback requires a valid audio file or video URL. Please provide at least one of them.");
//     }
//   }

//   void togglePlayPause() {
//     // Toggle the playback of the audio
//     isPlaying = !isPlaying;
//     if (isPlaying) {
//       audioPlayer.play();
//     } else {
//       audioPlayer.pause();
//     }
//   }

//   void seekTo(double seconds) {
//     audioPlayer.seek(Duration(seconds: seconds.toInt()));
//   }

//   ///stop the player if running, then play it from the MediaPlayerControllerCubit listener
//   void stopExistingMediaPlayer() {
//     context
//         .read<MediaPlayerControllerCubit>()
//         .stopAllMedia(playMediaAfterAllStop: true, playerKey: widget.key);
//   }

//   @override
//   void dispose() {
//     // Dispose the audio player when the widget is disposed
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   final loadingWidget = Container(
//     margin: const EdgeInsets.all(8.0),
//     width: 20,
//     height: 20,
//     child: const CircularProgressIndicator(strokeWidth: 2),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MediaPlayerControllerCubit, MediaPlayerControllerState>(
//       listener: (context, mediaPlayerControllerState) async {
//         if (mediaPlayerControllerState.stopAllMedia) {
//           await audioPlayer.pause();
//           if (mediaPlayerControllerState.playMediaAfterAllStop) {
//             if (mediaPlayerControllerState.playerKey == widget.key) {
//               //Then play the current track
//               await audioPlayer.play();
//             }
//           }
//         }
//       },
//       child: BlocProvider.value(
//         value: audioPlayerStatusCubit,
//         child: Center(
//           child: BlocBuilder<AudioPlayerStatusCubit, AudioPlayerStatusState>(
//             builder: (context, audioPlayerStatusState) {
//               if (audioPlayerStatusState.status == AudioPlayerStatus.loading) {
//                 return loadingWidget;
//               } else {
//                 return Container(
//                   decoration: BoxDecoration(
//                     border: widget.enableBorder ? Border.all(width: 0.5) : null,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: widget.enableBorder
//                       ? const EdgeInsets.symmetric(vertical: 10)
//                       : null,
//                   margin: widget.enableBorder
//                       ? const EdgeInsets.symmetric(horizontal: 5)
//                       : null,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       StreamBuilder<Duration>(
//                         stream: audioPlayer.positionStream,
//                         builder: (context, positionSnapshot) {
//                           position = positionSnapshot.data ?? Duration.zero;
//                           return Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               StreamBuilder<PlayerState>(
//                                 stream: audioPlayer.playerStateStream,
//                                 builder: (context, snapshot) {
//                                   final playerState = snapshot.data;
//                                   final processingState =
//                                       playerState?.processingState;
//                                   final playing = playerState?.playing;

//                                   //Check whether the playing is completed or not
//                                   final completed = position!.inSeconds >=
//                                       duration!.inSeconds;

//                                   if (processingState ==
//                                           ProcessingState.loading ||
//                                       processingState ==
//                                           ProcessingState.buffering) {
//                                     return loadingWidget;
//                                   }
//                                   //Replay
//                                   else if (completed) {
//                                     return IconButton(
//                                       icon: const Icon(Icons.replay),
//                                       iconSize: 25,
//                                       onPressed: () async {
//                                         stopExistingMediaPlayer();
//                                         await audioPlayer.seek(Duration.zero);
//                                       },
//                                       color: widget.iconColor,
//                                     );
//                                   }
//                                   //Play
//                                   else if (playing != true) {
//                                     return IconButton(
//                                       icon: const Icon(Icons.play_arrow),
//                                       iconSize: 25,
//                                       onPressed: () async {
//                                         stopExistingMediaPlayer();
//                                       },
//                                       color: widget.iconColor,
//                                     );
//                                   }
//                                   //Pause
//                                   else {
//                                     return IconButton(
//                                       icon: const Icon(Icons.pause),
//                                       iconSize: 25,
//                                       onPressed: audioPlayer.pause,
//                                       color: widget.iconColor,
//                                     );
//                                   }
//                                 },
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Slider(
//                                       value: position!.inSeconds.toDouble(),
//                                       min: 0,
//                                       max: duration!.inSeconds.toDouble(),
//                                       onChanged: (double value) {
//                                         seekTo(value);
//                                       },
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 20),
//                                       child: Text(
//                                         formatPlayerTime(
//                                           audioPlayer.playing
//                                               ? position!
//                                               : duration!,
//                                         ),
//                                         // :${formatPlayerTime(duration!)
//                                         style: TextStyle(
//                                           color: widget.textColor,
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
