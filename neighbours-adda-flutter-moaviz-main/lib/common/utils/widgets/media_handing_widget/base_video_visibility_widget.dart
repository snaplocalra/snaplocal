import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/video_full_view.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../../../social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import '../../../../utility/storage/cache/manager/media_cache_manager.dart';
import 'logic/video_player_manager.dart';

class BaseVideoVisibilityWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final String views;
  final bool muted;
  final double height;
  final bool showControls;
  final void Function()? onVideoViewCount;

  const BaseVideoVisibilityWidget({
    super.key,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.views,
    required this.onVideoViewCount,
    this.muted = true,
    this.height = 300,
    this.showControls = true,
  });

  @override
  State<BaseVideoVisibilityWidget> createState() => _BaseVideoVisibilityWidgetState();
}

class _BaseVideoVisibilityWidgetState extends State<BaseVideoVisibilityWidget> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isVisible = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isMuted = true;
  bool _hasReportedView = false;
  String views = "0";
  File? _cachedVideoFile;
  bool _isCachedVideoUsable = false;

  @override
  void initState() {
    super.initState();
    views = widget.views;
    _isMuted = VideoMuteManager().isMuted;
    VideoMuteManager().addListener(_handleGlobalMuteChange);
    WidgetsBinding.instance.addObserver(this);
    
    // Preload video when widget is created
    _preloadVideo();
  }

  Future<void> _preloadVideo() async {
    try {
      print('🎥 [VIDEO] Preloading video: ${widget.videoUrl.substring(0, 50)}...');
      // Check if video is already cached
      _cachedVideoFile = await MediaCacheManager.instance.getCachedFile(widget.videoUrl);
      
      if (_cachedVideoFile == null) {
        print('🎥 [VIDEO] No cached file found, starting download...');
        // Start downloading in background
        MediaCacheManager.instance.downloadAndCache(
          widget.videoUrl,
          thumbnailUrl: widget.thumbnailUrl,
        ).then((file) async {
          if (mounted && file != null) {
            final isUsable = await _validateCachedVideo(file);
            print('🎥 [VIDEO] Download completed, video usable: $isUsable');
            setState(() {
              _cachedVideoFile = file;
              _isCachedVideoUsable = isUsable;
            });
          }
        }).catchError((e) {
          print('🎥 [VIDEO] Error caching video: $e');
        });
      } else {
        print('🎥 [VIDEO] Found cached file, validating...');
        final isUsable = await _validateCachedVideo(_cachedVideoFile!);
        print('🎥 [VIDEO] Using cached file, usable: $isUsable');
        setState(() {
          _isCachedVideoUsable = isUsable;
        });
      }
    } catch (e) {
      print('🎥 [VIDEO] Error preloading video: $e');
    }
  }

  Future<bool> _validateCachedVideo(File videoFile) async {
    try {
      // Check if file exists and has sufficient size
      if (!await videoFile.exists()) {
        print('🎥 [VALIDATE] Video file does not exist');
        return false;
      }

      final fileSize = await videoFile.length();
      const minCacheSize = 1024 * 1024; // 1MB minimum
      
      if (fileSize < minCacheSize) {
        print('🎥 [VALIDATE] Video file too small: ${fileSize} bytes');
        return false;
      }

      // Try to create a video controller to validate the file is playable
      try {
        final testController = VideoPlayerController.file(videoFile);
        await testController.initialize();
        final duration = testController.value.duration;
        await testController.dispose();
        
        // Check if video has reasonable duration (at least 1 second)
        if (duration.inMilliseconds < 1000) {
          print('🎥 [VALIDATE] Video duration too short: ${duration.inMilliseconds}ms');
          return false;
        }
        
        print('🎥 [VALIDATE] Video file is valid - Size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB, Duration: ${duration.inSeconds}s');
        return true;
      } catch (e) {
        print('🎥 [VALIDATE] Video file validation failed: $e');
        return false;
      }
    } catch (e) {
      print('🎥 [VALIDATE] Error validating video file: $e');
      return false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.removeListener(_videoProgressListener);
    VideoControllerManager().disposeController(widget.videoUrl);
    VideoMuteManager().removeListener(_handleGlobalMuteChange);
    _controller = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isUsableController(_controller)) return;

    if (state == AppLifecycleState.paused) {
      _controller?.pause();
    } else if (state == AppLifecycleState.resumed && _isVisible) {
      _controller?.play();
    }
  }

  Future<void> _initializeController() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      VideoPlayerController controller;
      
      // Use cached file only if it's usable, otherwise use network
      if (_cachedVideoFile != null && _isCachedVideoUsable) {
        print('🎥 [CONTROLLER] Using validated cached file for video controller');
        controller = VideoPlayerController.file(_cachedVideoFile!);
      } else {
        print('🎥 [CONTROLLER] Using network URL for video controller (cache not ready or unusable)');
        controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      }

      print('🎥 [CONTROLLER] Initializing video controller...');
      await controller.initialize();
      controller.setVolume(_isMuted ? 0.0 : 1.0);

      if (!mounted) return;

      print('🎥 [CONTROLLER] Video controller initialized successfully');
      setState(() {
        _controller = controller;
        _hasError = false;
        _hasReportedView = false;
      });

      _controller?.addListener(_videoProgressListener);

      VideoControllerManager().pauseAllExcept(widget.videoUrl);
      controller.play();
      print('🎥 [CONTROLLER] Started playing video');
    } catch (e) {
      print('🎥 [CONTROLLER] Error initializing video controller: $e');
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _videoProgressListener() {
    if (!_hasReportedView && _controller != null && _controller!.value.isInitialized) {
      final position = _controller!.value.position;
      if (position.inSeconds >= 3) {
        _hasReportedView = true;
        setState(() {});
        if (widget.onVideoViewCount != null) {
          widget.onVideoViewCount!();
        }
      }
    }
  }

  void _handleVisibility(VisibilityInfo info) async {
    final visible = info.visibleFraction > 0.6;

    if (visible && !_isVisible) {
      print('🎥 [VISIBILITY] Video became visible, initializing...');
      _isVisible = true;

      if (!_isUsableController(_controller)) {
        await _initializeController();
      } else {
        print('🎥 [VISIBILITY] Reusing existing controller');
        VideoControllerManager().pauseAllExcept(widget.videoUrl);
        _controller?.play();
      }
    } else if (!visible && _isVisible) {
      print('🎥 [VISIBILITY] Video became invisible, pausing...');
      _isVisible = false;
      try {
        _controller?.pause();
      } catch (_) {}
    }
  }

  bool _isUsableController(VideoPlayerController? c) {
    return c != null &&
        c.value.isInitialized &&
        !c.value.hasError &&
        c.value.isPlaying != null;
  }

  void _handleGlobalMuteChange(bool mute) {
    if (mounted) {
      setState(() {
        _isMuted = mute;
        _controller?.setVolume(_isMuted ? 0.0 : 1.0);
      });
    }
  }

  void _toggleMute() {
    // If currently muted, unmute all
    if (_isMuted) {
      VideoMuteManager().toggleMuteAll(false);
    } else {
      // If already unmuted, just mute this one
      setState(() {
        _isMuted = true;
        _controller?.setVolume(0.0);
      });
    }
  }

  void _openFullScreen() {
    if (_isUsableController(_controller)) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => VideoFullScreenPage(videoUrl: widget.videoUrl),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final usable = _isUsableController(_controller);

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: _handleVisibility,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (usable)
              VideoPlayer(_controller!)
            else
              CachedNetworkImage(
                imageUrl: widget.thumbnailUrl,
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => const Icon(Icons.error),
              ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            // Show cache status indicator only when video is actually cached and usable
            if (_cachedVideoFile != null && _isCachedVideoUsable && !_isLoading)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.offline_bolt,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'CACHED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Show network indicator when using network or cache is not ready
            if ((!_isCachedVideoUsable || _cachedVideoFile == null) && usable)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_download,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'NETWORK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Show downloading indicator when cache is in progress
            if (_cachedVideoFile == null && _isLoading)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LOADING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (usable && widget.showControls) ...[
              Positioned(
                top: 10,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.remove_red_eye, color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        views,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _toggleMute,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _openFullScreen,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
