// ignore_for_file: use_build_context_synchronously

import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/logic/upload_page_post/upload_page_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/models/manage_page_post_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/repository/manage_page_post_repository.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/caption_box.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/discard_post_dialog.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_pick_media_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/regular_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ManagePagePostScreen extends StatefulWidget {
  final String pageId;
  final PostDetailsControllerCubit? postDetailsControllerCubit;

  const ManagePagePostScreen({
    super.key,
    required this.pageId,
    this.postDetailsControllerCubit,
  });

  static const routeName = 'manage_page_post';

  @override
  State<ManagePagePostScreen> createState() => _ManagePagePostScreenState();
}

class _ManagePagePostScreenState extends State<ManagePagePostScreen> {
  bool get isEdit => widget.postDetailsControllerCubit != null;
  RegularPostModel? existingPagePostDetails;
  LocationAddressWithLatLng? taggedLocation;

  List<MediaFileModel> pickedMedia = [];
  List<NetworkMediaModel> serverMedia = [];

  final captionTextController = TextEditingController();
  final activeButtonCubit = ActiveButtonCubit();

  late UploadPagePostCubit uploadPagePostCubit = UploadPagePostCubit(
    createPagePostRepository: context.read<ManagePagePostRepository>(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );

  //Post permission settings
  PostSharePermission postSharePermission = PostSharePermission.allow;
  PostCommentPermission postCommentPermission = PostCommentPermission.enable;

  ///Update the data on parent widget
  void updatePostController() {
    existingPagePostDetails!.media = serverMedia;
    existingPagePostDetails!.taggedlocation = taggedLocation;
    existingPagePostDetails!.caption = captionTextController.text.trim();

    //update the post details controller state
    widget.postDetailsControllerCubit!
        .postStateUpdate(UpdatePostState(existingPagePostDetails!));
  }

  void prefillData() {
    existingPagePostDetails = widget
        .postDetailsControllerCubit!.state.socialPostModel as RegularPostModel;
    captionTextController.text = existingPagePostDetails!.caption;

    //Server media
    serverMedia = existingPagePostDetails!.media;

    //Tag location
    taggedLocation = existingPagePostDetails!.taggedlocation;

    postSharePermission = existingPagePostDetails!.postSharePermission;
    postCommentPermission = existingPagePostDetails!.postCommentPermission;
    postButtonValidator();
  }

  //Will use only on new post
  bool discardValidate() {
    //If is there any caption or any picked media available then show discard dialog
    return captionTextController.text.isNotEmpty || pickedMedia.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      prefillData();
    }
  }

  @override
  void dispose() {
    captionTextController.dispose();
    super.dispose();
  }

  //Enable or disable the post button
  void postButtonValidator() {
    if (isEdit &&
        captionTextController.text.trim().isEmpty &&
        existingPagePostDetails!.media.isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else if (!isEdit &&
        captionTextController.text.trim().isEmpty &&
        pickedMedia.isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else {
      activeButtonCubit.changeStatus(true);
    }
  }

  Future<void> onPopInvoked(bool allowPop) async {
    //close the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    //If the allowPop and isEdit mode is false then showDiscardDialog allowed to true
    final showDiscardDialog = (allowPop && !isEdit) && discardValidate();
    if (showDiscardDialog && mounted) {
      allowPop = await showDiscardChangesDialog(context);
    }
    if (allowPop && mounted) {
      GoRouter.of(context).pop();
    }
  }

  void postPagePost() {
    FocusScope.of(context).unfocus();
    //logic to upload post
    final uploadPagePostModel = UploadPagePostModel(
      id: existingPagePostDetails?.id,
      postType: PostType.general,
      caption: captionTextController.text.trim(),
      pageId: widget.pageId,
      taggedLocation: taggedLocation,
      commentPermission: postCommentPermission,
      sharePermission: postSharePermission,
      media: [...serverMedia],
    );

    uploadPagePostCubit.managePost(
      uploadPagePostModel: uploadPagePostModel,
      pickedMediaList: pickedMedia,
      isEdit: isEdit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: uploadPagePostCubit),
        BlocProvider(create: (context) => MediaPickCubit()),
        BlocProvider(
          create: (context) =>
              LocationTagControllerCubit(taggedLocation: taggedLocation),
        ),
        BlocProvider(
          create: (context) => PostCommentControlCubit(postCommentPermission),
        ),
        BlocProvider(
          create: (context) => PostShareControlCubit(postSharePermission),
        ),
      ],
      child: BlocConsumer<UploadPagePostCubit, UploadPagePostState>(
        listener: (context, uploadPagePostState) {
          if (uploadPagePostState.isRequestSuccess) {
            if (isEdit) {
              updatePostController();
            } else {
              if (mounted) {
                //only post create time call the profile details to update the rewards
                context
                    .read<ManageProfileDetailsBloc>()
                    .add(FetchProfileDetails());
              }
            }

            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
            return;
          }
        },
        builder: (context, uploadPagePostState) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) {
                return;
              }
              onPopInvoked(!uploadPagePostState.isLoading);
            },
            child: Scaffold(
              appBar: CreatePostAppBar(
                willPop: () async =>
                    await onPopInvoked(!uploadPagePostState.isLoading),
                actions: [
                  BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                    builder: (context, activeButtonState) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ThemeElevatedButton(
                          showLoadingSpinner: uploadPagePostState.isLoading,
                          disableButton: !activeButtonState.isEnabled,
                          buttonName: isEdit
                              ? tr(LocaleKeys.updatePost)
                              : tr(LocaleKeys.post),
                          textFontSize: 10,
                          padding: EdgeInsets.zero,
                          width: isEdit ? 120 : 80,
                          height: 25,
                          onPressed: postPagePost,
                          suffix: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: SvgPicture.asset(
                              SVGAssetsImages.postIcon,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              height: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          BlocListener<LocationTagControllerCubit,
                              LocationTagControllerState>(
                            listener: (context, locationTagControllerState) {
                              taggedLocation =
                                  locationTagControllerState.taggedLocation;
                            },
                            //What's happening, neighbours
                            child: CaptionBoxWidget(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              allowMediaPick: !isEdit,
                              captionTextController: captionTextController,
                              hintText: LocaleKeys.createANewPost,
                              gallaryFileType: FileType.media,
                              onChanged: () {
                                postButtonValidator();
                              },
                              onPostCommentPermissionSelection:
                                  (PostCommentPermission
                                      postCommentPermission) {
                                this.postCommentPermission =
                                    postCommentPermission;
                              },
                              onPostSharePermissionSelection:
                                  (PostSharePermission postSharePermission) {
                                this.postSharePermission = postSharePermission;
                              },
                              maxLength: TextFieldInputLength
                                  .pagePostDescriptionMaxLength,
                              validator: (value) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                value,
                                TextFieldInputLength
                                    .pagePostDescriptionMinLength,
                                isOptional: true,
                              ),
                            ),
                          ),
                          //Picked images
                          PostPickMediaWidget(
                            serverMedia: [...serverMedia],
                            onMediaPick: (logs) {
                              //Assign the media images with the local variable
                              pickedMedia = logs;
                              postButtonValidator();
                            },
                            onServerMediaUpdated: (serverMediaList) {
                              serverMedia = serverMediaList;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
