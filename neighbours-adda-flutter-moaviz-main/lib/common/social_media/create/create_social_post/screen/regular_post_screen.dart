import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/regular_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/repository/manage_general_post_repository.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/caption_box.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/discard_post_dialog.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_pick_media_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_privacy_controller_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/regular_post_header_selector.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/upload_general_post/upload_general_post_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/visibility_controller/visibility_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/regular_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_map_radius_preference_widget.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class RegularPostScreen extends StatefulWidget {
  final PostType regularPostType;
  final PostDetailsControllerCubit? postDetailsControllerCubit;
  const RegularPostScreen({
    super.key,
    required this.regularPostType,
    this.postDetailsControllerCubit,
  });

  static const routeName = 'regular_post';

  @override
  State<RegularPostScreen> createState() => _RegularPostScreenState();
}

class _RegularPostScreenState extends State<RegularPostScreen> {
  bool get isEdit => widget.postDetailsControllerCubit != null;
  RegularPostModel? existingRegularPostDetails;
  LocationAddressWithLatLng? postFeedPosition;
  LocationAddressWithLatLng? taggedLocation;

  List<MediaFileModel> pickedMedia = [];
  List<NetworkMediaModel> serverMedia = [];

  final captionTextController = TextEditingController();
  FeedRadiusModel? radiusPreference;

  //Post permission settings
  PostSharePermission postSharePermission = PostSharePermission.allow;
  PostCommentPermission postCommentPermission = PostCommentPermission.enable;
  PostVisibilityControlEnum postVisibilityPermission =
      PostVisibilityControlEnum.public;

  //ScrollController
  final ScrollController _scrollController = ScrollController();

  //Required Cubits
  late UploadGeneralPostCubit uploadGeneralPostCubit = UploadGeneralPostCubit(
    manageGeneralPostRepository: context.read<ManageGeneralPostRepository>(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );
  MediaPickCubit mediaPickCubit = MediaPickCubit();
  RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());
  final activeButtonCubit = ActiveButtonCubit();
//

  ///Update the data on parent widget
  void updatePostController() {
    existingRegularPostDetails!.caption = captionTextController.text.trim();
    existingRegularPostDetails!.media = serverMedia;
    existingRegularPostDetails!.taggedlocation = taggedLocation;

    widget.postDetailsControllerCubit!
        .postStateUpdate(UpdatePostState((existingRegularPostDetails!)));
  }

  void onPost() {
    if (postFeedPosition == null) {
      ThemeToast.errorToast(tr(LocaleKeys.pleaseselectalocation));
      return;
    } else if (radiusPreference == null) {
      ThemeToast.errorToast(tr(LocaleKeys.pleaseselectapostfeedradius));
      return;
    } else {
      FocusScope.of(context).unfocus();
      //logic to upload post
      final regularDataPostModel = RegularDataPostModel(
        id: existingRegularPostDetails?.id,
        postType: widget.regularPostType,
        visibilityPermission: postVisibilityPermission,
        commentPermission: postCommentPermission,
        sharePermission: postSharePermission,
        caption: captionTextController.text.trim(),
        media: [...serverMedia],
        postLocation: postFeedPosition!,
        taggedLocation: taggedLocation,
        postRadiusPreference: radiusPreference!.socialMediaSearchRadius,
      );

      uploadGeneralPostCubit.manageRegularPost(
        regularDataPostModel: regularDataPostModel,
        pickedMediaList: pickedMedia,
        isEdit: isEdit,
      );
    }
  }

  //Will use only on new post
  bool discardValidate() {
    //If is there any caption or any picked media available then show discard dialog
    return captionTextController.text.isNotEmpty || pickedMedia.isNotEmpty;
  }

  Future<void> _renderLocationAndFeedRadius({
    required FeedRadiusModel feedRadiusModel,
    required LocationAddressWithLatLng locationModel,
  }) async {
    //Wait for the widget tree to render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //tasks after widget tree render

      //emitting feedRadius data
      await radiusSliderCubit.emitRadius(feedRadiusModel);

      //emitting location data
      await locationRenderCubit.emitLocation(
        locationAddressWithLatLong: locationModel,
        locationType: LocationType.socialMedia,
      );
    });
  }

  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    existingRegularPostDetails = widget
        .postDetailsControllerCubit!.state.socialPostModel as RegularPostModel;

    captionTextController.text = existingRegularPostDetails!.caption;

    //Post settings
    postVisibilityPermission =
        existingRegularPostDetails!.postVisibilityPermission;
    postSharePermission = existingRegularPostDetails!.postSharePermission;
    postCommentPermission = existingRegularPostDetails!.postCommentPermission;

    //Tag location
    taggedLocation = existingRegularPostDetails!.taggedlocation;

    //Server media
    serverMedia = existingRegularPostDetails!.media;

    final modifiedLocationModel = LocationAddressWithLatLng(
      address: existingRegularPostDetails!.postLocation.address,
      latitude: existingRegularPostDetails!.postLocation.latitude,
      longitude: existingRegularPostDetails!.postLocation.longitude,
    );
    _renderLocationAndFeedRadius(
      locationModel: modifiedLocationModel,
      feedRadiusModel: feedRadiusModel.copyWith(
        socialMediaSearchRadius:
            existingRegularPostDetails!.postPreferenceRadius,
      ),
    );

    postButtonValidator();
  }

  @override
  void initState() {
    super.initState();

    final profileSettingCubit = context.read<ProfileSettingsCubit>();
    final profileSettingState = profileSettingCubit.state;

    if (profileSettingState.isProfileSettingModelAvailable) {
      final feedRadiusModel =
          profileSettingState.profileSettingsModel!.feedRadiusModel;
      final locationModel =
          profileSettingState.profileSettingsModel!.socialMediaLocation;

      if (isEdit) {
        prefillData(feedRadiusModel: feedRadiusModel);
      } else {
        if (locationModel != null) {
          _renderLocationAndFeedRadius(
            feedRadiusModel: feedRadiusModel.copyWith(
              socialMediaSearchRadius:
                  //70% of feedRadiusModel.maxSearchVisibilityRadius
                  feedRadiusModel.maxSearchVisibilityRadius * 0.7,
            ),
            locationModel: locationModel,
          );
        }
      }
    } else {
      throw ("Profile data not available");
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
        existingRegularPostDetails!.media.isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else if (!isEdit &&
        captionTextController.text.trim().isEmpty &&
        pickedMedia.isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else {
      activeButtonCubit.changeStatus(true);
    }
  }

  Future<void> willPopScope(bool allowPop) async {
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: uploadGeneralPostCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider(
          create: (context) =>
              LocationTagControllerCubit(taggedLocation: taggedLocation),
        ),
        BlocProvider(
          create: (context) =>
              PostVisibilityControlCubit(postVisibilityPermission),
        ),
        BlocProvider(
          create: (context) => PostCommentControlCubit(postCommentPermission),
        ),
        BlocProvider(
          create: (context) => PostShareControlCubit(postSharePermission),
        ),
        BlocProvider(create: (context) => VisibilityControllerCubit()),
      ],
      child: BlocConsumer<UploadGeneralPostCubit, UploadGeneralPostState>(
        listener: (context, uploadGeneralPostState) {
          if (uploadGeneralPostState.isRequestSuccess) {
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
              //Pop with true to run the data refresh list api
              GoRouter.of(context).pop(true);
            }
            return;
          }
        },
        builder: (context, uploadGeneralPostState) {
          return BlocListener<LocationTagControllerCubit,
              LocationTagControllerState>(
            listener: (context, locationTagControllerState) {
              taggedLocation = locationTagControllerState.taggedLocation;
            },
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) {
                  return;
                }
                willPopScope(!uploadGeneralPostState.isLoading);
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: CreatePostAppBar(
                  willPop: () =>
                      willPopScope(!uploadGeneralPostState.isLoading),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PostVisibilityControlWidget(
                        onPostVisibilitySelection: (PostVisibilityControlEnum
                            postVisibilityPermission) {
                          this.postVisibilityPermission =
                              postVisibilityPermission;
                        },
                      ),
                    )
                  ],
                ),
                body: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 10),
                  children: [
                    if (!isEdit)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RegularPostHeaderSelector(
                          regularPostType: widget.regularPostType,
                        ),
                      ),

                    //Caption box
                    BlocBuilder<VisibilityControllerCubit,
                        VisibilityControllerState>(
                      builder: (context, visibilityControllerState) {
                        final watermark =
                            //Restrict the general type to render as watermark
                            widget.regularPostType == PostType.general
                                ? null
                                :
                                //If the controller state is visible then don't show the watermark
                                visibilityControllerState.isVisible
                                    ? null
                                    : RegularPostHeaderWidget(
                                        regularPostType: widget.regularPostType,
                                      );

                        return CaptionBoxWidget(
                          watermark: watermark,
                          allowMediaPick: !isEdit,
                          scrollController: _scrollController,
                          gallaryFileType: FileType.media,
                          margin: const EdgeInsets.all(10),
                          captionTextController: captionTextController,
                          hintText: widget.regularPostType.captionText,
                          onChanged: () {
                            postButtonValidator();
                          },
                          onTap: () {
                            context
                                .read<VisibilityControllerCubit>()
                                .changeVisibility(false);
                          },
                          onPostCommentPermissionSelection:
                              (PostCommentPermission postCommentPermission) {
                            this.postCommentPermission = postCommentPermission;
                          },
                          onPostSharePermissionSelection:
                              (PostSharePermission postSharePermission) {
                            this.postSharePermission = postSharePermission;
                          },
                          maxLength:
                              (widget.regularPostType == PostType.askQuestion ||
                                      widget.regularPostType ==
                                          PostType.askSuggestion)
                                  ? TextFieldInputLength.questionMaxLength
                                  : TextFieldInputLength
                                      .regularPostDescriptionMaxLength,
                          validator: (value) =>
                              TextFieldValidator.standardValidatorWithMinLength(
                            value,
                            TextFieldInputLength
                                .regularPostDescriptionMinLength,
                            isOptional: true,
                          ),
                        );
                      },
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

                    // Post Radius Preference
                    PostMapRadiusPreferenceWidget(
                      postType: widget.regularPostType,
                      locationType: LocationType.socialMedia,
                      onLocationRender: (postFeedPosition, radiusPreference) {
                        this.radiusPreference = radiusPreference;
                        this.postFeedPosition = postFeedPosition;
                      },
                    ),

                    //Post Button
                    BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                      builder: (context, activeButtonState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: SafeArea(
                            child: ThemeElevatedButton(
                              buttonName: isEdit
                                  ? tr(LocaleKeys.updatePost)
                                  : tr(LocaleKeys.post),
                              showLoadingSpinner:
                                  uploadGeneralPostState.isLoading,
                              disableButton: !activeButtonState.isEnabled,
                              onPressed: onPost,
                            ),
                          ),
                        );
                      },
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
