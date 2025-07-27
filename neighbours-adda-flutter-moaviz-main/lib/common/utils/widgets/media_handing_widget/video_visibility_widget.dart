import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/video_full_view.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'base_video_visibility_widget.dart';
import 'logic/video_player_manager.dart';

bool _isMuted = true;

class VideoVisibilityWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnail;
  final String views;
  final double? width;
  final BoxFit fit;
  final bool fromGrid;
  final void Function()? onVideoViewCount;

  const VideoVisibilityWidget({
    super.key,
    required this.videoUrl,
    required this.thumbnail,
    required this.views,
    this.onVideoViewCount,
    this.width,
    required this.fit,
    this.fromGrid = false,
  });

  @override
  State<VideoVisibilityWidget> createState() => _VideoVisibilityWidgetState();
}

class _VideoVisibilityWidgetState extends State<VideoVisibilityWidget> {
  VideoPlayerController? _controller;
  bool _isVisible = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isInitialized = false;

  // @override
  // void dispose() {
  //   _disposeController();
  //   super.dispose();
  // }
  //
  // void _disposeController() {
  //   if (_controller != null) {
  //     _controller!.pause();  // Pause the video
  //     _controller!.dispose(); // Dispose the video controller
  //     _controller = null;
  //   }
  //   _isLoading = false;
  //   _hasError = false;
  //   _isInitialized = false;
  // }
  //
  // Future<void> _initializeController() async {
  //   // Prevent reinitialization if controller is already initialized
  //   if (_controller != null && _controller!.value.isInitialized) return;
  //
  //   setState(() {
  //     _isLoading = true;
  //     _hasError = false;
  //   });
  //
  //   try {
  //     final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
  //     await controller.initialize();
  //     controller
  //       ..setLooping(true)
  //       ..setVolume(_isMuted ? 0.0 : 1.0);
  //
  //     if (!mounted) return;
  //
  //     setState(() {
  //       _controller = controller;
  //       _isInitialized = true;
  //     });
  //
  //     controller.play(); // Start playing the video
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _hasError = true;
  //       });
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }
  //
  // void _handleVisibility(VisibilityInfo info) {
  //   final visible = info.visibleFraction > 0.8;
  //
  //   if (visible && !_isVisible) {
  //     _isVisible = true;
  //     // Initialize the controller only if it hasn't been initialized yet
  //     if (!_isInitialized) {
  //       _initializeController();
  //     }
  //   } else if (!visible && _isVisible) {
  //     _isVisible = false;
  //     // Dispose of the controller when it goes off-screen
  //     _disposeController();
  //   }
  // }

  bool _isControllerUsable(VideoPlayerController? c) {
    return c != null &&
        c.value.isInitialized &&
        !c.value.hasError &&
        c.value.isPlaying != null;
  }

  Future<void> _initializeController() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final manager = VideoControllerManager();
      final controller = await manager.getController(widget.videoUrl,_isMuted);

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isInitialized = true;
      });

      manager.pauseAllExcept(widget.videoUrl);
      controller.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleVisibility(VisibilityInfo info) async {
    final visible = info.visibleFraction > 0.6;

    if (visible && !_isVisible) {
      _isVisible = true;

      final manager = VideoControllerManager();
      try {
        final controller = await manager.getController(widget.videoUrl, _isMuted);

        if (!mounted) return;

        setState(() {
          _controller = controller;
          _isInitialized = true;
          _hasError = false;
        });

        manager.pauseAllExcept(widget.videoUrl);
        controller.play();
      } catch (e) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      }
    } else if (!visible && _isVisible) {
      _isVisible = false;

      try {
        if (_controller != null && _controller!.value.isInitialized) {
          _controller!.pause();
        }
      } catch (_) {
        // controller might have been disposed
      }
    }
  }

  @override
  void dispose() {
    _controller = null; // prevent reuse after disposal
    VideoControllerManager().disposeController(widget.videoUrl);
    super.dispose();
  }

  void _openFullScreen() {
    if (_controller != null && _controller!.value.isInitialized) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => VideoFullScreenPage(videoUrl: widget.videoUrl),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height * 0.7;

    // return VisibilityDetector(
    //   key: Key(widget.videoUrl),
    //   onVisibilityChanged: _handleVisibility,
    //   child: SizedBox(
    //     width: widget.width ?? double.infinity,
    //     height: height,
    //     child: Stack(
    //       alignment: Alignment.center,
    //       fit: StackFit.expand,
    //       children: [
    //         if (_controller != null && _controller!.value.isInitialized)
    //           VideoPlayer(_controller!)
    //         else if (_hasError)
    //           Center(
    //             child: GestureDetector(
    //               onTap: () {
    //                 setState(() {
    //                   _hasError = false;
    //                 });
    //                 _initializeController();
    //               },
    //               child: const Icon(
    //                 Icons.replay,
    //                 color: Colors.white,
    //                 size: 40,
    //               ),
    //             ),
    //           )
    //         else
    //           CachedNetworkImage(
    //             imageUrl: widget.thumbnail,
    //             fit: widget.fit,
    //             placeholder: (context, url) => Container(
    //               color: Colors.black26,
    //               child: Center(
    //                 child: CircularProgressIndicator(
    //                   color: ApplicationColours.themePinkColor,
    //                 ),
    //               ),
    //             ),
    //             errorWidget: (context, url, error) => Icon(Icons.error),
    //           ),
    //         if (_isLoading)
    //           Container(
    //             color: Colors.black26,
    //             child: Center(
    //               child: CircularProgressIndicator(
    //                 color: ApplicationColours.themePinkColor,
    //               ),
    //             ),
    //           ),
    //         if (_controller != null && _controller!.value.isInitialized) ...[
    //           Positioned(
    //             top: 8,
    //             right: 8,
    //             child: GestureDetector(
    //               onTap: () {
    //                 setState(() {
    //                   _isMuted = !_isMuted;
    //                   _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    //                 });
    //               },
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.black45,
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 padding: const EdgeInsets.all(6),
    //                 child: Icon(
    //                   _isMuted ? Icons.volume_off : Icons.volume_up,
    //                   color: Colors.white,
    //                   size: 20,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Positioned(
    //             bottom: 8,
    //             right: 8,
    //             child: GestureDetector(
    //               onTap: _openFullScreen,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.black45,
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 padding: const EdgeInsets.all(6),
    //                 child: const Icon(
    //                   Icons.fullscreen,
    //                   color: Colors.white,
    //                   size: 20,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ],
    //     ),
    //   ),
    // );
    return BaseVideoVisibilityWidget(
      videoUrl: widget.videoUrl,
      thumbnailUrl: widget.thumbnail,
      views: widget.views,
      onVideoViewCount: widget.onVideoViewCount,
      showControls: true,
      muted: true,
      height: MediaQuery.of(context).size.height * 0.7,
    );
  }
}
