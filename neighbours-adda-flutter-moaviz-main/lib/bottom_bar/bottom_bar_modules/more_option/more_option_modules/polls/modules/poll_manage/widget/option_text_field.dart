import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class OptionTextField extends StatefulWidget {
  final String text;
  final String? image;
  final MediaFileModel? fileImage;
  final String hint;
  final void Function(String)? onChanged;
  final void Function(MediaFileModel? image)? onImagePicked;
  final bool isPhotoMode;
  final bool enableOption;
  const OptionTextField({
    super.key,
    required this.text,
    required this.image,
    required this.fileImage,
    required this.hint,
    this.onChanged,
    this.onImagePicked,
    this.isPhotoMode = false,
    this.enableOption = true,
  });

  @override
  State<OptionTextField> createState() => _OptionTextFieldState();
}

class _OptionTextFieldState extends State<OptionTextField> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaPickCubit(),
      child: BlocConsumer<MediaPickCubit, MediaPickState>(
        listener: (context, mediaPickState) {
          if (mediaPickState.mediaPickerModel.pickedFiles.isNotEmpty) {
            widget.onImagePicked
                ?.call(mediaPickState.mediaPickerModel.pickedFiles.first);
          }
        },
        builder: (context, mediaPickState) {
          return ThemeTextFormField(
            enabled: widget.enableOption,
            initialValue: widget.text,
            prefixIcon: widget.isPhotoMode
                ? widget.fileImage != null
                    ? PollOptionFileImage(
                        fileImage: widget.fileImage!,
                        onImageRemoved: () {
                          widget.onImagePicked?.call(null);
                        },
                      )
                    : widget.image != null
                        ? PostOptionNetworkImage(imageUrl: widget.image!)
                        : CircularSvgButton(
                            showLoading: mediaPickState.dataLoading,
                            loadingColor: ApplicationColours.themePinkColor,
                            circleRadius: 18,
                            backgroundColor:
                                const Color.fromRGBO(233, 237, 255, 1),
                            svgImage: SVGAssetsImages.cameraFilled,
                            onTap: () {
                              //close keyboard
                              FocusManager.instance.primaryFocus?.unfocus();

                              context.read<MediaPickCubit>().pickGalleryMedia(
                                    context,
                                    type: FileType.image,
                                  );
                            },
                          )
                : null,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            hint: widget.hint,
            hintStyle: const TextStyle(fontSize: 14),
            style: const TextStyle(fontSize: 14, height: 1.5),
            onChanged: widget.onChanged,
            maxLength: TextFieldInputLength.pollOptionMaxLength,
            validator: (value) =>
                TextFieldValidator.standardValidatorWithMinLength(
              value,
              TextFieldInputLength.pollOptionMinLength,
            ),
          );
        },
      ),
    );
  }
}

class PostOptionNetworkImage extends StatelessWidget {
  const PostOptionNetworkImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          //close keyboard
          FocusManager.instance.primaryFocus?.unfocus();
          showImageViewer(
            context,
            CachedNetworkImageProvider(imageUrl),
            swipeDismissible: true,
            doubleTapZoomable: true,
            backgroundColor: Colors.black,
          );
        },
        child: NetworkImageCircleAvatar(
          radius: 15,
          imageurl: imageUrl,
        ),
      ),
    );
  }
}

class PollOptionFileImage extends StatelessWidget {
  const PollOptionFileImage({
    super.key,
    required this.fileImage,
    required this.onImageRemoved,
  });

  final MediaFileModel fileImage;
  final void Function() onImageRemoved;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () {
              //close keyboard
              FocusManager.instance.primaryFocus?.unfocus();
              showImageViewer(
                context,
                FileImage((fileImage as ImageFileMediaModel).imageFile),
                swipeDismissible: true,
                doubleTapZoomable: true,
                backgroundColor: Colors.black,
              );
            },
            child: FileImageCircleAvatar(
              radius: 20,
              fileImage: (fileImage as ImageFileMediaModel).imageFile,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            //close keyboard
            FocusManager.instance.primaryFocus?.unfocus();
            onImageRemoved.call();
            context.read<MediaPickCubit>().removeMedia(selectedFile: fileImage);
          },
          child: const Icon(
            Icons.cancel,
            color: Colors.red,
            size: 20,
          ),
        ),
      ],
    );
  }
}
