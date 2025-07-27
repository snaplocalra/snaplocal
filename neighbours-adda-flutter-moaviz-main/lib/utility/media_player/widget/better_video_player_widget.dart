// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/media_player/tools/media_player_controller/media_player_controller_cubit.dart';
import 'package:snap_local/utility/media_player/tools/media_player_volume_controller/media_player_volume_controller_cubit.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BetterVideoPlayerWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final bool autoPlay;
  final bool showControlsOnInitialize;
  final bool showControls;
  final bool muteInitialVolume;
  final bool initialFullScreen;
  const BetterVideoPlayerWidget({
    super.key,
    this.videoFile,
    this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
    this.showControlsOnInitialize = true,
    this.muteInitialVolume = false,
    this.initialFullScreen = false,
  });

  @override
  State<BetterVideoPlayerWidget> createState() =>
      _BetterVideoPlayerWidgetState();
}

class _BetterVideoPlayerWidgetState extends State<BetterVideoPlayerWidget> {
  // late BetterPlayerController _betterPlayerController;
  // late BetterPlayerDataSource _betterPlayerDataSource;
  //
  // //initialize the video player controller
  // Future<void> initializeVideoPlayer() async {
  //   //Initialize the video player controller
  //   BetterPlayerConfiguration betterPlayerConfiguration =
  //       BetterPlayerConfiguration(
  //     fit: BoxFit.contain,
  //     autoPlay: widget.autoPlay,
  //     fullScreenByDefault: true,
  //     looping: false,
  //     autoDispose: true,
  //     autoDetectFullscreenDeviceOrientation: true,
  //     autoDetectFullscreenAspectRatio: true,
  //     controlsConfiguration: BetterPlayerControlsConfiguration(
  //       showControlsOnInitialize: widget.showControlsOnInitialize,
  //       showControls: widget.showControls,
  //     ),
  //     aspectRatio: 1,
  //     overlay: Align(
  //       alignment: Alignment.topLeft,
  //       child: Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: Image.asset(
  //           PNGAssetsImages.snaplocallogo,
  //           height: 40,
  //           width: 40,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     eventListener: (event){
  //       print("<<<<<<<<<<<<<<<<<<<<<<<<<<<Better Play Event>>>>>>>>>>>>>>>>>>>>>>>>>>");
  //       print(event.betterPlayerEventType.index);
  //       print(event.betterPlayerEventType.name);
  //       print(event.parameters);
  //       if(BetterPlayerEventType.hideFullscreen==event.betterPlayerEventType){
  //         Navigator.of(context).pop();
  //       }
  //     },
  //   );
  //
  //   //Initialize the data source
  //   _betterPlayerDataSource = BetterPlayerDataSource(
  //     widget.videoFile != null
  //         ? BetterPlayerDataSourceType.file
  //         : widget.videoUrl != null
  //             ? BetterPlayerDataSourceType.network
  //             : throw ("Playback requires a valid video file or video URL. Please provide at least one of them."),
  //     widget.videoFile?.path ?? widget.videoUrl!,
  //   );
  //
  //   //Initialize the video player controller
  //   _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
  //
  //   //Setup the data source
  //   await _betterPlayerController.setupDataSource(_betterPlayerDataSource);
  //
  //   if (mounted) {
  //     // Enter full screen if the initialFullScreen is true
  //     // if (widget.initialFullScreen) {
  //     //   _betterPlayerController.enterFullScreen();
  //     // }
  //
  //     if (widget.muteInitialVolume) {
  //       //mute the video
  //       _betterPlayerController.setVolume(0);
  //     }
  //
  //     // Assign the media player volume controller status
  //     if (context.read<MediaPlayerVolumeControllerCubit>().state ==
  //         UnMuteMediaPlayerVolume()) {
  //       _betterPlayerController.setVolume(1);
  //     }
  //
  //     //Listen for volume control change
  //     context.read<MediaPlayerVolumeControllerCubit>().stream.listen((state) {
  //       if (state is MuteMediaPlayerVolume) {
  //         _betterPlayerController.setVolume(0);
  //       } else if (state is UnMuteMediaPlayerVolume) {
  //         _betterPlayerController.setVolume(1);
  //       }
  //     });
  //
  //     // _betterPlayerController.controllerEventStream.listen((event) {
  //     //   if (mounted) {
  //     //     //if user mute then assign mute in the MediaPlayerVolumeControllerCubit
  //     //     if (_betterPlayerController.volume == 0) {
  //     //       context
  //     //           .read<MediaPlayerVolumeControllerCubit>()
  //     //           .muteMediaPlayerSound();
  //     //     } else {
  //     //       context
  //     //           .read<MediaPlayerVolumeControllerCubit>()
  //     //           .unMuteMediaPlayerSound();
  //     //     }
  //     //   }
  //     // });
  //   }
  // }
  //
  // @override
  // initState() {
  //   super.initState();
  //   initializeVideoPlayer();
  // }
  //
  // @override
  // void dispose() {
  //   _betterPlayerController.dispose(forceDispose: true);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.videoFile?.path ?? widget.videoUrl!),
      onVisibilityChanged: (visibilityInfo) {
        try {
          if (visibilityInfo.visibleFraction < 1) {
            // Pause the video when it is not visible
            //_betterPlayerController.pause();
          } else {
            // Play the video when it is visible
            //_betterPlayerController.play();
          }
        } catch (e) {
          return;
        }
      },
      child:
          BlocListener<MediaPlayerControllerCubit, MediaPlayerControllerState>(
        listener: (context, mediaPlayerControllerState) async {
          if (mediaPlayerControllerState.stopAllMedia) {
            //await _betterPlayerController.pause();
          }
        },
        //child: BetterPlayer(controller: _betterPlayerController),
        child: SizedBox(),
      ),
    );
  }
}
