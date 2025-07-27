// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/create/create_social_post/constant/post_constants.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/media_pick_type_enum.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_comment_controller_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_share_controller_widget.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class CaptionBoxWidget extends StatelessWidget {
  final Widget? watermark;
  final bool allowTagLocation;
  final String hintText;
  final void Function()? onChanged;
  final void Function()? onTap;
  final TextEditingController captionTextController;
  final EdgeInsetsGeometry? margin;
  final bool allowMediaPick;
  final ScrollController? scrollController;
  final void Function(PostCommentPermission postCommentPermission)?
      onPostCommentPermissionSelection;
  final void Function(PostSharePermission postShare)?
      onPostSharePermissionSelection;
  final String? Function(String?)? validator;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final FileType gallaryFileType;

  const CaptionBoxWidget({
    super.key,
    this.watermark,
    this.allowTagLocation = true,
    required this.hintText,
    this.onChanged,
    this.onTap,
    required this.captionTextController,
    this.onPostCommentPermissionSelection,
    this.onPostSharePermissionSelection,
    this.margin,
    this.allowMediaPick = true,
    this.scrollController,
    this.validator,
    required this.maxLength,
    this.maxLines = 20,
    this.minLines = 5,
    this.enabled = true,
    this.gallaryFileType = FileType.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          if (watermark != null)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1,
                child: watermark!,
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                enabled: enabled,
                controller: captionTextController,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.0,
                ),
                textInputAction: TextInputAction.newline,
                minLines: minLines,
                maxLines: maxLines,
                maxLength: maxLength,
                onTap: onTap,
                onChanged: (value) {
                  if (onChanged != null) {
                    onChanged!.call();
                  }
                },
                validator: validator,
                decoration: InputDecoration(
                  hintText: tr(hintText),
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(104, 107, 116, 0.6),
                    fontSize: 15,
                  ),
                ),
              ),
              Visibility(
                visible: allowTagLocation,
                child: BlocBuilder<LocationTagControllerCubit,
                    LocationTagControllerState>(
                  builder: (context, locationTagControllerState) {
                    final taggedLocation =
                        locationTagControllerState.taggedLocation;
                    final taggedAddress = taggedLocation?.address;
                    if (taggedAddress != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  GoRouter.of(context)
                                      .pushNamed<LocationAddressWithLatLng>(
                                          TagLocationScreen.routeName,
                                          extra: taggedLocation)
                                      .then((location) {
                                    if (location != null && context.mounted) {
                                      context
                                          .read<LocationTagControllerCubit>()
                                          .addLocationTag(location);
                                    }
                                  });
                                },
                                child: AbsorbPointer(
                                  child: AddressWithLocationIconWidget(
                                    address: taggedAddress,
                                    iconSize: 16,
                                    iconTopPadding: 1,
                                    iconColour:
                                        ApplicationColours.themeLightPinkColor,
                                    textColour:
                                        ApplicationColours.themeBlueColor,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<LocationTagControllerCubit>()
                                    .removeLocationTag();
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 18,
                                color: ApplicationColours.themeBlueColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    if (onPostSharePermissionSelection != null)
                      PostShareControlWidget(
                        onPostSharePermissionSelection:
                            onPostSharePermissionSelection!,
                      ),
                    const SizedBox(width: 5),
                    if (onPostCommentPermissionSelection != null)
                      PostCommentControlWidget(
                        onPostCommentPermissionSelection:
                            onPostCommentPermissionSelection!,
                      ),
                    const Spacer(),
                    Visibility(
                      visible: allowTagLocation,
                      child: BlocBuilder<LocationTagControllerCubit,
                          LocationTagControllerState>(
                        builder: (context, locationTagControllerState) {
                          final taggedLocation =
                              locationTagControllerState.taggedLocation;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                GoRouter.of(context)
                                    .pushNamed<LocationAddressWithLatLng>(
                                        TagLocationScreen.routeName,
                                        extra: taggedLocation)
                                    .then((location) {
                                  if (location != null && context.mounted) {
                                    context
                                        .read<LocationTagControllerCubit>()
                                        .addLocationTag(location);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    const Color.fromRGBO(241, 244, 254, 1),
                                child: SvgPicture.asset(
                                  SVGAssetsImages.blueMapIcon,
                                  height: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: allowMediaPick,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: BlocBuilder<MediaPickCubit, MediaPickState>(
                          builder: (context, mediaPickState) {
                            return PopupMenuButton<MediaPickType>(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: MediaPickType.camera,
                                  enabled: !mediaPickState.dataLoading,
                                  height: 30,
                                  child: Text(
                                    tr(LocaleKeys.camera),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: MediaPickType.gallery,
                                  height: 30,
                                  enabled: !mediaPickState.dataLoading,
                                  child: Text(
                                    tr(LocaleKeys.gallery),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                final allowedMediaPickCountValue = context
                                    .read<MediaPickCubit>()
                                    .allowedMediaPickCountValue;

                                final allowMediaPick =
                                    allowedMediaPickCountValue > 0;

                                FocusManager.instance.primaryFocus?.unfocus();
                                if (allowMediaPick) {
                                  if (value == MediaPickType.camera) {
                                    context
                                        .read<MediaPickCubit>()
                                        .clickImage(context);
                                  } else {
                                    context
                                        .read<MediaPickCubit>()
                                        .pickGalleryMedia(
                                          context,
                                          type: gallaryFileType,
                                          allowMultiple: true,
                                          maxMediaPickLimit:
                                              PostConstants.maxMediaPickLimit,
                                        );
                                  }
                                } else {
                                  ThemeToast.errorToast(
                                    "You can only select up to ${PostConstants.maxMediaPickLimit} images.",
                                  );
                                  return;
                                }
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    const Color.fromRGBO(241, 244, 254, 1),
                                child: SvgPicture.asset(
                                    SVGAssetsImages.postNewCamera,
                                    height: 14),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
