import 'package:designer/utility/theme_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/create/create_social_post/constant/post_constants.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_helper_widgets.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class MultiMediaSelectionWidget extends StatefulWidget {
  final void Function(List<MediaFileModel> selectedMediaList) onMediaSelected;
  final void Function(List<NetworkMediaModel> serverMediaList)
      onServerMediaUpdated;
  final List<NetworkMediaModel> serverMedia;
  final FileType fileType;

  const MultiMediaSelectionWidget({
    super.key,
    required this.onMediaSelected,
    required this.onServerMediaUpdated,
    this.serverMedia = const [],
    required this.fileType,
  });

  @override
  State<MultiMediaSelectionWidget> createState() =>
      _MultiMediaSelectionWidgetState();
}

class _MultiMediaSelectionWidgetState extends State<MultiMediaSelectionWidget> {
  @override
  void initState() {
    super.initState();
    //set the allowed media pick count
    context.read<MediaPickCubit>().setAllowedMediaPickCount(
        PostConstants.maxMediaPickLimit - widget.serverMedia.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: StatefulBuilder(builder: (context, mediaState) {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.serverMedia.length,
                  itemBuilder: (context, index) {
                    final serverMedia = widget.serverMedia[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: NetworkMediaViewerWidget(
                          onServerMediaRemove: () {
                            mediaState(() {
                              widget.serverMedia.removeAt(index);
                            });
                            widget.onServerMediaUpdated
                                .call(widget.serverMedia);
                          },
                          networkMedia: serverMedia,
                        ),
                      ),
                    );
                  },
                ),
                BlocConsumer<MediaPickCubit, MediaPickState>(
                  listener: (context, mediaPickState) {
                    final logs = mediaPickState.mediaPickerModel.pickedFiles;

                    int allowedElementCount = PostConstants.maxMediaPickLimit -
                        (widget.serverMedia.length + logs.length);

                    //set the allowed media pick count
                    context
                        .read<MediaPickCubit>()
                        .setAllowedMediaPickCount(allowedElementCount);

                    //Call back to parent widget
                    widget.onMediaSelected.call(logs);
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
                      itemCount: logs.length + allowedElementCount,
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
                                ? FileMediaWidget(
                                    fileMedia: logs[index],
                                    onRemove: () {
                                      context
                                          .read<MediaPickCubit>()
                                          .removeMedia(
                                              selectedFile: logs[index]);
                                    },
                                  )
                                : mediaPickState.dataLoading &&
                                        (nextEmptyIndex == index)
                                    ? const MeadiLoadingPlaceHolder()
                                    : GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          if (allowMediaPick) {
                                            context
                                                .read<MediaPickCubit>()
                                                .pickGalleryMedia(
                                                  context,
                                                  type: widget.fileType,
                                                  allowMultiple: true,
                                                  maxMediaPickLimit:
                                                      PostConstants
                                                          .maxMediaPickLimit,
                                                );
                                          } else {
                                            ThemeToast.errorToast(
                                              "You can only select up to ${PostConstants.maxMediaPickLimit} images.",
                                            );
                                          }
                                          return;
                                        },
                                        child: const EmptyImagePlaceHolder(),
                                      ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            );
          }),
        ),
      ],
    );
  }
}
