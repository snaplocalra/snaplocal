import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/widgets/dotted_border_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/media_player/video/video_thumbnail_holder.dart';

class MeadiLoadingPlaceHolder extends StatelessWidget {
  const MeadiLoadingPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorderWidget(
      radius: const Radius.circular(5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ThemeSpinner(size: 20),
            const SizedBox(height: 2),
            Text(
              "${tr(LocaleKeys.loading)}...",
              style: const TextStyle(
                color: Color.fromRGBO(104, 107, 116, 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileMediaWidget extends StatelessWidget {
  const FileMediaWidget({
    super.key,
    required this.onRemove,
    required this.fileMedia,
  });
  final void Function() onRemove;
  final MediaFileModel fileMedia;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: fileMedia is ImageFileMediaModel
                ? GestureDetector(
                    onTap: () {
                      showImageViewer(
                        context,
                        FileImage((fileMedia as ImageFileMediaModel).imageFile),
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                        backgroundColor: Colors.black,
                      );
                    },
                    child: Image.file(
                      (fileMedia as ImageFileMediaModel).imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : fileMedia is VideoFileMediaModel
                    ? VideoThumbnailHolder(
                        videoFile: fileMedia as VideoFileMediaModel,
                        fit: BoxFit.cover,
                      )
                    : throw Exception("Unknown media type"),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onRemove.call();
            },
            child: Icon(
              Icons.cancel_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
    );
  }
}

class NetworkMediaViewerWidget extends StatelessWidget {
  const NetworkMediaViewerWidget({
    super.key,
    required this.onServerMediaRemove,
    required this.networkMedia,
  });
  final void Function() onServerMediaRemove;
  final NetworkMediaModel networkMedia;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: networkMedia is NetworkVideoMediaModel
              ? VideoThumbnailHolder(
                  networkVideo: networkMedia as NetworkVideoMediaModel,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : networkMedia is NetworkImageMediaModel
                  ? GestureDetector(
                      onTap: () {
                        showImageViewer(
                          context,
                          CachedNetworkImageProvider(
                              (networkMedia as NetworkImageMediaModel)
                                  .imageUrl),
                          swipeDismissible: true,
                          doubleTapZoomable: true,
                          backgroundColor: Colors.black,
                        );
                      },
                      child: CachedNetworkImage(
                        cacheKey: networkMedia.mediaUrl,
                        imageUrl: networkMedia.mediaUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : throw Exception("Unknown media type"),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onServerMediaRemove.call();
            },
            child: Icon(
              Icons.cancel_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
    );
  }
}

class EmptyImagePlaceHolder extends StatelessWidget {
  const EmptyImagePlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: DottedBorderWidget(
        radius: const Radius.circular(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FeatherIcons.image,
                color: Color.fromRGBO(175, 173, 173, 1),
                weight: 0.1,
                size: 30,
              ),
              Text(
                tr(LocaleKeys.upload),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color.fromRGBO(175, 173, 173, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
