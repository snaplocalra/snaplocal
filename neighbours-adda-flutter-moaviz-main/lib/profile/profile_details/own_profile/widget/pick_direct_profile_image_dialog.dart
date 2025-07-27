import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PickDirectProfileImageDialog extends StatelessWidget {
  final bool isCoverPic;
  const PickDirectProfileImageDialog({
    super.key,
    required this.isCoverPic,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => MediaPickCubit()
        ..pickGalleryMedia(
          context,
          type: FileType.image,
        ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
            height: size.height * 0.6,
            child: BlocConsumer<MediaPickCubit, MediaPickState>(
              listener: (context, mediaPickState) {
                if (mediaPickState.mediaPickCancelled) {
                  //close the dialog
                  if (context.mounted && Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
              },
              builder: (context, mediaPickState) {
                MediaFileModel? pickedImage;
                if (mediaPickState.mediaPickerModel.pickedFiles.isNotEmpty) {
                  pickedImage =
                      mediaPickState.mediaPickerModel.pickedFiles.first;
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: mediaPickState.dataLoading || pickedImage == null
                      ? const ThemeSpinner(size: 40)
                      : Column(
                          children: [
                            //Check the image preview
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Preview Image",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            Expanded(
                              child: isCoverPic
                                  ? Image.file(
                                      (pickedImage as ImageFileMediaModel)
                                          .imageFile,
                                      fit: BoxFit.scaleDown,
                                    )
                                  : OctagonWidget(
                                      shapeSize: 200,
                                      child: Image.file(
                                        (pickedImage as ImageFileMediaModel)
                                            .imageFile,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),

                            //Upload button
                            BlocConsumer<ManageProfileDetailsBloc,
                                ManageProfileDetailsState>(
                              listener: (context, manageProfileDetailsState) {
                                if (manageProfileDetailsState
                                        .isRequestSuccess &&
                                    Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              builder: (context, manageProfileDetailsState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: ThemeElevatedButton(
                                    buttonName: tr(LocaleKeys.upload),
                                    showLoadingSpinner:
                                        manageProfileDetailsState
                                            .isRequestLoading,
                                    onPressed: () {
                                      if (isCoverPic) {
                                        context
                                            .read<ManageProfileDetailsBloc>()
                                            .add(
                                                UpdateCoverImage(pickedImage!));
                                      } else {
                                        context
                                            .read<ManageProfileDetailsBloc>()
                                            .add(UpdateProfileImage(
                                                pickedImage!));
                                      }
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                );
              },
            )),
      ),
    );
  }
}
