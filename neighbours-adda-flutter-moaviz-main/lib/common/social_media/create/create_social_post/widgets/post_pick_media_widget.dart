// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/create/create_social_post/constant/post_constants.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/add_more_media_widget.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_helper_widgets.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/media_player/video/video_player_screen.dart';

class PostPickMediaWidget extends StatefulWidget {
  final void Function(List<MediaFileModel> logs) onMediaPick;
  final void Function(List<NetworkMediaModel> serverMediaList)
      onServerMediaUpdated;
  final List<NetworkMediaModel> serverMedia;
  const PostPickMediaWidget({
    super.key,
    required this.onMediaPick,
    required this.onServerMediaUpdated,
    required this.serverMedia,
  });

  @override
  State<PostPickMediaWidget> createState() => _PostPickMediaWidgetState();
}

class _PostPickMediaWidgetState extends State<PostPickMediaWidget> {
  @override
  void initState() {
    super.initState();
    //set the allowed media pick count
    context.read<MediaPickCubit>().setAllowedMediaPickCount(
        PostConstants.maxMediaPickLimit - widget.serverMedia.length);
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.amber,
        borderRadius: BorderRadius.circular(15),
      ),
      height: mqSize.height * 0.1,
      child: StatefulBuilder(builder: (context, mediaState) {
        return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              BlocBuilder<MediaPickCubit, MediaPickState>(
                builder: (context, mediaPickState) {
                  int allowedElementCount = PostConstants.maxMediaPickLimit -
                      (widget.serverMedia.length +
                          mediaPickState.mediaPickerModel.pickedFiles.length);

                  final allowMediaPick = allowedElementCount > 0;
                  return Visibility(
                    visible: allowMediaPick,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AddMoreMediaWidget(
                        onTap: mediaPickState.dataLoading
                            ? null
                            : () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (allowMediaPick) {
                                  context
                                      .read<MediaPickCubit>()
                                      .pickGalleryMedia(
                                        context,
                                        type: FileType.media,
                                        allowMultiple: true,
                                        maxMediaPickLimit:
                                            PostConstants.maxMediaPickLimit,
                                      );
                                  return;
                                } else {
                                  ThemeToast.errorToast(
                                    "You can only select up to ${PostConstants.maxMediaPickLimit} images.",
                                  );
                                }
                              },
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.serverMedia.length,
                itemBuilder: (context, index) {
                  final serverMedia = widget.serverMedia[index];

                  return Padding(
                    key: ValueKey(serverMedia.mediaUrl),
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: NetworkMediaViewerWidget(
                        onServerMediaRemove: () {
                          mediaState(() {
                            widget.serverMedia.removeAt(index);
                            widget.onServerMediaUpdated
                                .call(widget.serverMedia);
                          });
                        },
                        networkMedia: widget.serverMedia[index],
                      ),
                    ),
                  );
                },
              ),
              BlocConsumer<MediaPickCubit, MediaPickState>(
                listener: (context, mediaPickState) {
                  if (mediaPickState.error != null) {
                    //show snackbar
                    SnackBar(
                      content: Text(mediaPickState.error!),
                      backgroundColor: Colors.red,
                    );
                    return;
                  }

                  final logs = mediaPickState.mediaPickerModel.pickedFiles;

                  int allowedElementCount = PostConstants.maxMediaPickLimit -
                      (widget.serverMedia.length + logs.length);

                  //set the allowed media pick count
                  context
                      .read<MediaPickCubit>()
                      .setAllowedMediaPickCount(allowedElementCount);

                  //Call back to parent widget
                  widget.onMediaPick.call(logs);
                },
                builder: (context, mediaPickState) {
                  final logs = mediaPickState.mediaPickerModel.pickedFiles;

                  int allowedElementCount = PostConstants.maxMediaPickLimit -
                      (widget.serverMedia.length + logs.length);

                  final allowMediaPick = allowedElementCount > 0;

                  //Use to show loading on the listview, just after the selected image index
                  int nextEmptyIndex = 0;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: logs.length + 1,
                    itemBuilder: (context, index) {
                      final mediaAvailable = index < logs.length;
                      if (mediaAvailable) {
                        //if media available, take the next index as loading index
                        nextEmptyIndex = index + 1;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: mediaAvailable
                              ? GestureDetector(
                                  onTap: () {
                                    final fileMedia = logs[index];

                                    if (fileMedia is ImageFileMediaModel) {
                                      showImageViewer(
                                        context,
                                        FileImage(fileMedia.imageFile),
                                        swipeDismissible: true,
                                        doubleTapZoomable: true,
                                        backgroundColor: Colors.black,
                                      );
                                    } else if (fileMedia
                                        is VideoFileMediaModel) {
                                      // showVideoViewer(
                                      //   context,
                                      //   fileMedia.media,
                                      // );

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog.fullscreen(
                                            child: VideoPlayerScreen(
                                              videoFile: fileMedia.videoFile,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: FileMediaWidget(
                                    fileMedia: logs[index],
                                    onRemove: () {
                                      context
                                          .read<MediaPickCubit>()
                                          .removeMedia(
                                              selectedFile: logs[index]);
                                    },
                                  ),
                                )
                              : mediaPickState.dataLoading &&
                                      (nextEmptyIndex == index)
                                  ? const MeadiLoadingPlaceHolder()
                                  : Visibility(
                                      visible: widget.serverMedia.isEmpty &&
                                          logs.isEmpty,
                                      child: GestureDetector(
                                        onTap: mediaPickState.dataLoading
                                            ? null
                                            : () {
                                                if (allowMediaPick) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  context
                                                      .read<MediaPickCubit>()
                                                      .pickGalleryMedia(
                                                        context,
                                                        type: FileType.media,
                                                        allowMultiple: true,
                                                        maxMediaPickLimit:
                                                            PostConstants
                                                                .maxMediaPickLimit,
                                                      );
                                                } else {
                                                  ThemeToast.errorToast(
                                                    "You can only select up to ${PostConstants.maxMediaPickLimit} images.",
                                                  );
                                                  return;
                                                }
                                              },
                                        child: const EmptyImagePlaceHolder(),
                                      ),
                                    ),
                        ),
                      );
                    },
                  );
                },
              )
            ]);
      }),
    );
  }
}
