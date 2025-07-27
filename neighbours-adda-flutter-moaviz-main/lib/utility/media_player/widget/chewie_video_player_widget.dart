// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';

// import 'package:chewie/chewie.dart';
// import 'package:designer/widgets/theme_spinner.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:snap_local/utility/media_player/tools/media_player_controller/media_player_controller_cubit.dart';
// import 'package:snap_local/utility/media_player/tools/media_player_volume_controller/media_player_volume_controller_cubit.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class ChewieVideoPlayerWidget extends StatefulWidget {
//   final File? videoFile;
//   final String? videoUrl;
//   final bool autoPlay;
//   final bool showControlsOnInitialize;
//   final bool showControls;
//   final bool muteInitialVolume;
//   const ChewieVideoPlayerWidget({
//     super.key,
//     this.videoFile,
//     this.videoUrl,
//     this.autoPlay = false,
//     this.showControls = true,
//     this.showControlsOnInitialize = true,
//     this.muteInitialVolume = false,
//   });

//   @override
//   State<ChewieVideoPlayerWidget> createState() =>
//       _ChewieVideoPlayerWidgetState();
// }

// class _ChewieVideoPlayerWidgetState extends State<ChewieVideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   ChewieController? _chewieController;

//   void createChewieController() {
//     // Initialize the video player controller
//     // Initialize the Chewie controller with the video player controller
//     _chewieController = ChewieController(
//       videoPlayerController: _controller,
//       autoPlay: widget.autoPlay,
//       placeholder: const Center(child: ThemeSpinner()),
//       autoInitialize: true,
//       allowPlaybackSpeedChanging: false,
//       showOptions: false,
//       showControlsOnInitialize: widget.showControlsOnInitialize,
//       showControls: widget.showControls,
//       aspectRatio: _controller.value.aspectRatio,
//     );

//     setState(() {});
//   }

//   //initialize the video player controller
//   Future<void> initializeVideoPlayer() async {
//     if (widget.videoFile != null) {
//       // Initialize the video player controller with the file
//       _controller = VideoPlayerController.file(widget.videoFile!);
//     } else if (widget.videoUrl != null) {
//       // Initialize the video player controller with the video url
//       _controller =
//           VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
//     } else {
//       throw ("Playback requires a valid video file or video URL. Please provide at least one of them.");
//     }

//     //Initialize the video player controller

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (mounted) {
//         createChewieController();

//         if (widget.muteInitialVolume) {
//           //mute the video
//           _controller.setVolume(0);
//         }

//         // Assign the media player volume controller status
//         if (context.read<MediaPlayerVolumeControllerCubit>().state ==
//             UnMuteMediaPlayerVolume()) {
//           _controller.setVolume(1);
//         }

//         //Listen for volume control change
//         context.read<MediaPlayerVolumeControllerCubit>().stream.listen((state) {
//           if (state is MuteMediaPlayerVolume) {
//             _controller.setVolume(0);
//           } else if (state is UnMuteMediaPlayerVolume) {
//             _controller.setVolume(1);
//           }
//         });

//         _controller.addListener(() {
//           if (mounted) {
//             //if user mute then assign mute in the MediaPlayerVolumeControllerCubit
//             if (_controller.value.volume == 0) {
//               context
//                   .read<MediaPlayerVolumeControllerCubit>()
//                   .muteMediaPlayerSound();
//             } else {
//               context
//                   .read<MediaPlayerVolumeControllerCubit>()
//                   .unMuteMediaPlayerSound();
//             }
//           }
//         });
//       }
//     });
//   }

//   @override
//   initState() {
//     super.initState();
//     initializeVideoPlayer();
//   }

//   @override
//   void dispose() {
//     // Dispose the video player controller and the Chewie controller
//     _controller.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: ValueKey(widget.videoFile?.path ?? widget.videoUrl!),
//       onVisibilityChanged: (visibilityInfo) {
//         try {
//           if (visibilityInfo.visibleFraction < 1) {
//             // Pause the video when it is not visible
//             _chewieController?.pause();
//           } else {
//             // Play the video when it is visible
//             _chewieController?.play();
//           }
//         } catch (e) {
//           return;
//         }
//       },
//       child:
//           BlocListener<MediaPlayerControllerCubit, MediaPlayerControllerState>(
//         listener: (context, mediaPlayerControllerState) async {
//           if (mediaPlayerControllerState.stopAllMedia) {
//             await _chewieController?.pause();
//           }
//         },
//         child: _chewieController != null &&
//                 _chewieController!.videoPlayerController.value.isInitialized
//             ? Chewie(controller: _chewieController!)
//             : const Center(child: ThemeSpinner(size: 20)),
//       ),
//     );
//   }
// }
