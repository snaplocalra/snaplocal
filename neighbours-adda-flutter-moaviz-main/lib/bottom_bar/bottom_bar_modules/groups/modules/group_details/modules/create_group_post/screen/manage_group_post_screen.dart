// ignore_for_file: use_build_context_synchronously

import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/logic/upload_group_post/upload_group_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/models/manage_group_post_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/repository/manage_group_post_repository.dart';
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
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ManageGroupPostScreen extends StatefulWidget {
  final String groupId;
  final PostDetailsControllerCubit? postDetailsControllerCubit;

  const ManageGroupPostScreen({
    super.key,
    required this.groupId,
    this.postDetailsControllerCubit,
  });

  static const routeName = 'manage_group_post';

  @override
  State<ManageGroupPostScreen> createState() => _ManageGroupPostScreenState();
}

class _ManageGroupPostScreenState extends State<ManageGroupPostScreen> {
  bool get isEdit => widget.postDetailsControllerCubit != null;
  RegularPostModel? existingGroupPostDetails;
  LocationAddressWithLatLng? taggedLocation;

  List<MediaFileModel> pickedMedia = [];
  List<NetworkMediaModel> serverMedia = [];

  final captionTextController = TextEditingController();

  final activeButtonCubit = ActiveButtonCubit();
  late UploadGroupPostCubit uploadGroupPostCubit = UploadGroupPostCubit(
    createGroupPostRepository: context.read<ManageGroupPostRepository>(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );

  //Post permission settings
  PostSharePermission postSharePermission = PostSharePermission.allow;
  PostCommentPermission postCommentPermission = PostCommentPermission.enable;

  ///Update the data on parent widget
  void updatePostController() {
    // widget.postDetailsControllerCubit!
    //     .updateState(existingGroupPostDetails!.copyWith(
    //   caption: captionTextController.text.trim(),
    //   media: [...serverMedia],
    // ));
    existingGroupPostDetails!.caption = captionTextController.text.trim();
    existingGroupPostDetails!.taggedlocation = taggedLocation;
    existingGroupPostDetails!.media = [...serverMedia];
  }

  void prefillData() {
    existingGroupPostDetails = widget
        .postDetailsControllerCubit!.state.socialPostModel as RegularPostModel;
    captionTextController.text = existingGroupPostDetails!.caption;

    //Server media
    serverMedia = existingGroupPostDetails!.media;

    //Tag location
    taggedLocation = existingGroupPostDetails!.taggedlocation;

    postSharePermission = existingGroupPostDetails!.postSharePermission;
    postCommentPermission = existingGroupPostDetails!.postCommentPermission;
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
    super.dispose();
    captionTextController.dispose();
  }

  //Enable or disable the post button
  void postButtonValidator() {
    if (isEdit &&
        captionTextController.text.trim().isEmpty &&
        existingGroupPostDetails!.media.isEmpty) {
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: uploadGroupPostCubit),
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
      child: BlocConsumer<UploadGroupPostCubit, UploadGroupPostState>(
        listener: (context, uploadGroupPostState) {
          if (uploadGroupPostState.isRequestSuccess) {
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
              GoRouter.of(context).pop(true);
            }
            return;
          }
        },
        builder: (context, uploadGroupPostState) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) {
                return;
              }
              onPopInvoked(!uploadGroupPostState.isLoading);
            },
            child: Scaffold(
              appBar: CreatePostAppBar(
                willPop: () async =>
                    await onPopInvoked(!uploadGroupPostState.isLoading),
              ),
              body: SafeArea(
                child: Padding(
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
                                allowMediaPick: !isEdit,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                captionTextController: captionTextController,
                                hintText: LocaleKeys.whatsHappeningNeighbor,
                                gallaryFileType: FileType.media,
                                allowTagLocation: true,
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
                                    .groupPostDescriptionMaxLength,
                                validator: (value) => TextFieldValidator
                                    .standardValidatorWithMinLength(
                                  value,
                                  TextFieldInputLength
                                      .groupPostDescriptionMinLength,
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
                
                      //Post Button
                      SafeArea(
                        child: BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                          builder: (context, activeButtonState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ThemeElevatedButton(
                                buttonName: isEdit
                                    ? tr(LocaleKeys.updatePost)
                                    : tr(LocaleKeys.post),
                                showLoadingSpinner: uploadGroupPostState.isLoading,
                                disableButton: !activeButtonState.isEnabled,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  //logic to upload post
                                  final manageGroupPostModel = ManageGroupPostModel(
                                    id: existingGroupPostDetails?.id,
                                    postType: PostType.general, //default type
                                    caption: captionTextController.text.trim(),
                                    commentPermission: postCommentPermission,
                                    sharePermission: postSharePermission,
                                    taggedLocation: taggedLocation,
                                    groupId: widget.groupId,
                                    media: [...serverMedia],
                                  );
                                        
                                  context.read<UploadGroupPostCubit>().managePost(
                                        uploadGroupPostModel: manageGroupPostModel,
                                        pickedMediaList: pickedMedia,
                                        isEdit: isEdit,
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
