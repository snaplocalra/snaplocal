import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_helper_widgets.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class SingleMediaPickerWidget extends StatelessWidget {
  const SingleMediaPickerWidget({
    super.key,
    required this.serverMedia,
    required this.onMediaPicked,
    required this.onServerMediaRemove,
  });

  final NetworkMediaModel? serverMedia;
  final void Function(MediaFileModel? media) onMediaPicked;
  final void Function() onServerMediaRemove;

  @override
  Widget build(BuildContext context) {
    NetworkMediaModel? serverMedia = this.serverMedia;

    return BlocBuilder<MediaPickCubit, MediaPickState>(
      builder: (context, mediaPickState) {
        final logs = mediaPickState.mediaPickerModel.pickedFiles;
        //Assign the first file to the pickedMedia
        onMediaPicked.call(logs.firstOrNull);
        return Expanded(
          child: mediaPickState.dataLoading
              ? const MeadiLoadingPlaceHolder()
              : logs.isEmpty || serverMedia != null
                  ? GestureDetector(
                      onTap: () {
                        context.read<MediaPickCubit>().pickGalleryMedia(
                              context,
                              type: FileType.image,
                              allowMultiple: true,
                              maxMediaPickLimit: 1,
                            );
                      },
                      child: serverMedia != null
                          ? NetworkMediaViewerWidget(
                              onServerMediaRemove: () {
                                onServerMediaRemove.call();
                                //Refresh the state
                                context.read<MediaPickCubit>().clearMedia();
                              },
                              networkMedia: serverMedia,
                            )
                          : const EmptyImagePlaceHolder(),
                    )
                  : FileMediaWidget(
                      fileMedia: logs[0],
                      onRemove: () {
                        context
                            .read<MediaPickCubit>()
                            .removeMedia(selectedFile: logs[0]);
                      },
                    ),
        );
      },
    );
  }
}
