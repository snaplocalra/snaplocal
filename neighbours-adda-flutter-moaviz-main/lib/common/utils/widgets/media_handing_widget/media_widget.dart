import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/video_visibility_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/media_player/video/video_thumbnail_holder.dart';

class NetworkMediaWidget extends StatelessWidget {
  final NetworkMediaModel media;
  final double? height;
  final double? videoheight;
  final double? width;
  final BoxFit fit;
  final bool fromGrid;
  final bool isFirst;
  final void Function()? onVideoViewCount;
  const NetworkMediaWidget({
    super.key,
    required this.media,
    this.onVideoViewCount,
    this.height,
    this.width,
    this.videoheight,
    this.fit = BoxFit.cover,
    this.fromGrid=false,
    this.isFirst=true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: media is NetworkImageMediaModel
          ? CachedNetworkImage(
              key: ValueKey(media.mediaUrl),
              imageUrl: media.mediaUrl,
              fit: fit,
              height: height,
              width: width,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : media is NetworkVideoMediaModel
              ?
        isFirst
    ? VideoVisibilityWidget(
      videoUrl: media.mediaUrl,
      thumbnail: media.thumbnail,
      views: media.views,
      onVideoViewCount: onVideoViewCount,
      // height: videoheight,
      width: width,
      fit: fit,
        fromGrid: fromGrid,
    ):Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
      children: [
        CachedNetworkImage(
              key: ValueKey(media.mediaUrl),
              imageUrl: media.thumbnail,
              fit: fit,
              height: height,
              width: width,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
        Icon(Icons.play_arrow_outlined,color: Colors.white,size: 30,)
      ],
    )

      // VideoThumbnailHolder(
      //             key: ValueKey(media.mediaUrl),
      //             networkVideo: media as NetworkVideoMediaModel,
      //             fit: fit,
      //             height: videoheight,
      //             width: width,
      //           )
              : throw ("Unsupported media type"),
    );
  }
}

class NetworkMediaWidgetV2 extends StatelessWidget {
  final NetworkMediaModel media;
  final double? height;
  final double? videoheight;
  final double? width;
  final BoxFit fit;
  const NetworkMediaWidgetV2({
    super.key,
    required this.media,
    this.height,
    this.width,
    this.videoheight,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: media is NetworkImageMediaModel
          ? CachedNetworkImage(
              key: ValueKey(media.mediaUrl),
              imageUrl: media.mediaUrl,
              fit: fit,
              height: height,
              width: width,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : media is NetworkVideoMediaModel
              ?

              VideoVisibilityWidget(
                  videoUrl: media.mediaUrl,
                  thumbnail: media.thumbnail,
                  views: media.views,
                  // height: videoheight,
                  width: width,
                  fit: fit,
                )
              // VideoThumbnailHolder(
              //     key: ValueKey(media.mediaUrl),
              //     networkVideo: media as NetworkVideoMediaModel,
              //     fit: fit,
              //     height: videoheight,
              //     width: width,
              //   )
              : throw ("Unsupported media type"),
    );
  }
}
