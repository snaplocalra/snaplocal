//Show the video thumbnail image with a play icon on top of it
// create statelss widget to show the video thumbnail image

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/video_full_view.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/media_player/video/video_player_screen.dart';

class VideoThumbnailHolder extends StatelessWidget {
  final NetworkVideoMediaModel? networkVideo;
  final VideoFileMediaModel? videoFile;
  final BoxFit? fit;
  final double? height;
  final double? width;
  const VideoThumbnailHolder({
    super.key,
    this.networkVideo,
    this.videoFile,
    this.fit,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    //If both networkVideo and videoFile are not null throw an error
    if (networkVideo == null && videoFile == null) {
      throw ("Both networkVideo and videoFile cannot be null");
    }

    //If any of the available media is not a video media then throw an error
    else if (networkVideo != null && networkVideo is! NetworkVideoMediaModel) {
      throw ("networkVideo must be of type NetworkVideoMediaModel");
    } else if (videoFile != null && videoFile is! VideoFileMediaModel) {
      throw ("videoFile must be of type VideoFileMediaModel");
    }

    return GestureDetector(
      onTap: () {
        if(networkVideo!=null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoFullScreenPage(videoUrl: networkVideo?.mediaUrl??"" ,)),
          );
        }
        else if(videoFile!=null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocalVideoFullScreenPage(videoFile: videoFile!.videoFile,)),
          );
        }
        // GoRouter.of(context).pushNamed(
        //   VideoPlayerScreen.routeName,
        //   queryParameters: {
        //     'video_url': networkVideo?.mediaUrl,
        //   },
        //   extra: videoFile?.file,
        // );
      },
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //If networkVideo is not null return the CachedNetworkImage widget
            networkVideo != null
                ? Positioned.fill(
                    child: CachedNetworkImage(
                      key: ValueKey(networkVideo!.mediaUrl),
                      imageUrl:
                          (networkVideo as NetworkVideoMediaModel).thumbnailUrl,
                      fit: fit,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                :

                //If videoFile is not null return the Image.file widget
                videoFile != null
                    ? Positioned.fill(
                        child: Image.file(
                          (videoFile as VideoFileMediaModel).thumbnailFile,
                          fit: fit,
                        ),
                      )
                    : const SizedBox.shrink(),
            // Add a play button icon in the center
            const Icon(
              Icons.play_circle_outline,
              size: 50.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
