import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/media_player/widget/better_video_player_widget.dart';
import 'package:snap_local/utility/storage/cache/logic/cache_cubit.dart';
import 'package:snap_local/utility/storage/cache/manager/media_cache_manager.dart';

class VideoPlayerScreen extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final bool initialFullScreen;

  static const routeName = 'video_player';

  const VideoPlayerScreen({super.key, this.videoFile, this.videoUrl, this.initialFullScreen=false});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  File? _videoFile;
  String? _videoUrl;
  StreamSubscription? _cacheSubscription;

  @override
  void initState() {
    super.initState();
    _videoFile = widget.videoFile;
    _videoUrl = widget.videoUrl;
    _checkCache();
    _listenForCacheUpdates();
  }

  void _listenForCacheUpdates() {
    if (_videoUrl != null) {
      _cacheSubscription =
          context.read<CacheCubit>().stream.listen((cacheState) {
        // If the video we are streaming is no longer in preloadingUrls, it might be downloaded.
        if (!cacheState.preloadingUrls.contains(_videoUrl)) {
          _checkCache();
        }
      });
    }
  }

  Future<void> _checkCache() async {
    if (_videoUrl != null && _videoFile == null) {
      final cachedFile = await MediaCacheManager.instance.getCachedFile(_videoUrl!);
      if (cachedFile != null && mounted) {
        setState(() {
          _videoFile = cachedFile;
          _videoUrl = null; // Prioritize file playback
          _cacheSubscription?.cancel(); // Stop listening once we have the file
        });
      }
    }
  }

  @override
  void dispose() {
    _cacheSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BetterVideoPlayerWidget(
        videoFile: _videoFile,
        videoUrl: _videoUrl,
        initialFullScreen: widget.initialFullScreen,
        autoPlay: true,
      ),
    );
  }
}
