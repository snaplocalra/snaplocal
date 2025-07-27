// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/widgets/dotted_border_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class UploadCoverImageWidget extends StatelessWidget {
  final void Function(List<MediaFileModel> selectedMediaList) onMediaSelected;
  final String? coverImageUrl;

  const UploadCoverImageWidget({
    super.key,
    required this.onMediaSelected,
    this.coverImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return SizedBox(
      height: mqSize.height * 0.2,
      child: DottedBorderWidget(
        radius: const Radius.circular(20),
        child: BlocBuilder<MediaPickCubit, MediaPickState>(
          builder: (context, mediaPickState) {
            if (mediaPickState.dataLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeSpinner(size: 40),
                    Text(
                      tr(LocaleKeys.loadingImage),
                      style: const TextStyle(
                        color: Color.fromRGBO(104, 107, 116, 0.5),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final logs = mediaPickState.mediaPickerModel.pickedFiles;
              //Call back to parent widget
              onMediaSelected.call(logs);
              if (logs.isNotEmpty) {
                final coverImage = logs.first as ImageFileMediaModel;
                return Stack(children: [
                  GestureDetector(
                    onTap: () {
                      showImageViewer(
                        context,
                        FileImage(coverImage.imageFile),
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                        backgroundColor: Colors.black,
                      );
                    },
                    child: Image.file(
                      coverImage.imageFile,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        context
                            .read<MediaPickCubit>()
                            .removeMedia(selectedFile: coverImage);
                      },
                      child: Icon(
                        Icons.cancel_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ]);
              } else {
                return GestureDetector(
                  onTap: () {
                    context
                        .read<MediaPickCubit>()
                        .pickGalleryMedia(context, type: FileType.image);
                  },
                  child: AbsorbPointer(
                    child: coverImageUrl != null
                        ? CachedNetworkImage(
                            cacheKey: coverImageUrl!,
                            imageUrl: coverImageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  color: Color.fromRGBO(
                                    175,
                                    173,
                                    173,
                                    1,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tr(LocaleKeys.uploadCoverPic),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(
                                      175,
                                      173,
                                      173,
                                      1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
