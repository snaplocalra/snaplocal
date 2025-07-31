//Show the video thumbnail image with a play icon on top of it
// create statelss widget to show the video thumbnail image

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/video_full_view.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/media_player/video/video_player_screen.dart';
import 'package:snap_local/utility/storage/cache/logic/cache_cubit.dart';
import 'package:snap_local/utility/storage/cache/manager/media_cache_manager.dart';

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
      onTap: () async {
        if (networkVideo != null) {
          // Check if it's currently preloading
          final isPreloading = context
              .read<CacheCubit>()
              .state
              .preloadingUrls
              .contains(networkVideo!.mediaUrl);

          if (isPreloading) {
            // If preloading, wait for it to finish
            print('⏳ [CACHE] Video is preloading, waiting for completion...');
            // This is a simplified wait, a more robust solution might use a Completer
            // or listen to the cubit state changes.
            await Future.delayed(const Duration(seconds: 2)); // Simple wait
          }

          final file = await MediaCacheManager.instance
              .getCachedFile(networkVideo!.mediaUrl);
          if (file != null) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                        videoFile: file,
                      )),
            );
          } else {
            // Not cached, play from URL and start caching in background
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                        videoUrl: networkVideo?.mediaUrl ?? "",
                      )),
            );
            // Start caching in background, don't await
            MediaCacheManager.instance.downloadAndCache(networkVideo!.mediaUrl,
                thumbnailUrl: networkVideo!.thumbnailUrl);
          }
        } else if (videoFile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                      videoFile: videoFile!.videoFile,
                    )),
          );
        }
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
            if (networkVideo != null)
              BlocBuilder<CacheCubit, CacheState>(
                buildWhen: (previous, current) =>
                    previous.preloadingUrls != current.preloadingUrls,
                builder: (context, state) {
                  if (state.preloadingUrls.contains(networkVideo!.mediaUrl)) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}
