import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snap_local/utility/media_player/widget/better_video_player_widget.dart';

class VideoPlayerScreen extends StatelessWidget {
  final File? videoFile;
  final String? videoUrl;
  final bool initialFullScreen;

  static const routeName = 'video_player';

  const VideoPlayerScreen({super.key, this.videoFile, this.videoUrl, this.initialFullScreen=false});

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
        videoFile: videoFile,
        videoUrl: videoUrl,
        initialFullScreen: initialFullScreen,
        autoPlay: true,
      ),
    );
  }
}
