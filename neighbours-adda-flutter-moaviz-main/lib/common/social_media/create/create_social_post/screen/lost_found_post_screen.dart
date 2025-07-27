// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/lost_found_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/repository/manage_general_post_repository.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/caption_box.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/discard_post_dialog.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/lost_found_selector_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_pick_media_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_privacy_controller_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/upload_general_post/upload_general_post_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/visibility_controller/visibility_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/screen_header.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_map_radius_preference_widget.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class LostFoundPostScreen extends StatefulWidget {
  final PostDetailsControllerCubit? postDetailsControllerCubit;
  const LostFoundPostScreen({super.key, this.postDetailsControllerCubit});

  static const routeName = 'lost_found_post';

  @override
  State<LostFoundPostScreen> createState() => _LostFoundPostScreenState();
}

class _LostFoundPostScreenState extends State<LostFoundPostScreen> {
  bool get isEdit => widget.postDetailsControllerCubit != null;
  LostFoundPostModel? existingLostFoundPostDetails;
  LocationAddressWithLatLng? postFeedPosition;
  LocationAddressWithLatLng? taggedLocation;

  final titleTextController = TextEditingController();
  final incidentLocationTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  List<MediaFileModel> pickedMedia = [];
  List<NetworkMediaModel> serverMedia = [];
  FeedRadiusModel? radiusPreference;

  //Lost Found type
  LostFoundType lostFoundType = LostFoundType.lost;

  //ScrollController
  final ScrollController _scrollController = ScrollController();

  //Required Cubits
  late UploadGeneralPostCubit uploadRegularPostCubit = UploadGeneralPostCubit(
    manageGeneralPostRepository: context.read<ManageGeneralPostRepository>(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );

  //Post permission settings
  PostSharePermission postSharePermission = PostSharePermission.allow;
  PostCommentPermission postCommentPermission = PostCommentPermission.enable;
  PostVisibilityControlEnum postVisibilityPermission =
      PostVisibilityControlEnum.public;

  MediaPickCubit mediaPickCubit = MediaPickCubit();
  RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());
  final activeButtonCubit = ActiveButtonCubit();
//

  ///Update the data on parent widget
  void updatePostController() {
    existingLostFoundPostDetails!.title = titleTextController.text.trim();
    existingLostFoundPostDetails!.description =
        descriptionTextController.text.trim();
    existingLostFoundPostDetails!.lostFoundType = lostFoundType;
    existingLostFoundPostDetails!.media = serverMedia;
    existingLostFoundPostDetails!.taggedlocation = taggedLocation;

    //update the post details controller state
    widget.postDetailsControllerCubit!
        .postStateUpdate(UpdatePostState(existingLostFoundPostDetails!));
  }

  void onPost() {
    if (taggedLocation == null) {
      ThemeToast.errorToast("Please select the incident location");
      return;
    } else if (postFeedPosition == null) {
      ThemeToast.errorToast(tr(LocaleKeys.pleaseselectalocation));
      return;
    } else if (radiusPreference == null) {
      ThemeToast.errorToast(tr(LocaleKeys.pleaseselectapostfeedradius));
      return;
    } else {
      FocusScope.of(context).unfocus();
      //logic to upload post
      final lostFoundDataPostModel = LostFoundDataPostModel(
        id: existingLostFoundPostDetails?.id,
        postType: PostType.lostFound,
        lostFoundType: lostFoundType,
        visibilityPermission: postVisibilityPermission,
        commentPermission: postCommentPermission,
        sharePermission: postSharePermission,
        title: titleTextController.text.trim(),
        description: descriptionTextController.text.trim(),
        postRadiusPreference: radiusPreference!.socialMediaSearchRadius,
        postLocation: postFeedPosition!,
        incidentLocation: taggedLocation,
        media: [...serverMedia],
      );

      uploadRegularPostCubit.manageLostFoundPost(
        lostFoundDataPostModel: lostFoundDataPostModel,
        pickedMediaList: pickedMedia,
        isEdit: isEdit,
      );
    }
  }

  //Will use only on new post
  bool discardValidate() {
    //If is there any caption or any picked media available then show discard dialog
    return titleTextController.text.isNotEmpty ||
        descriptionTextController.text.isNotEmpty ||
        pickedMedia.isNotEmpty;
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

  Future<void> setTaggedLocation({
    LocationAddressWithLatLng? selectedTaggedLocation,
  }) async {
    taggedLocation = selectedTaggedLocation;
    if (taggedLocation != null) {
      incidentLocationTextController.text = taggedLocation!.address;
      //emitting location data
      await locationRenderCubit.emitLocation(
        locationAddressWithLatLong: taggedLocation,
        locationType: LocationType.socialMedia,
      );
    } else {
      incidentLocationTextController.clear();
    }
  }

  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    existingLostFoundPostDetails = widget.postDetailsControllerCubit!.state
        .socialPostModel as LostFoundPostModel;

    titleTextController.text = existingLostFoundPostDetails!.title;
    descriptionTextController.text = existingLostFoundPostDetails!.description;

    //Lost found type
    lostFoundType = existingLostFoundPostDetails!.lostFoundType;

    //Post settings
    postSharePermission = existingLostFoundPostDetails!.postSharePermission;
    postVisibilityPermission =
        existingLostFoundPostDetails!.postVisibilityPermission;
    postCommentPermission = existingLostFoundPostDetails!.postCommentPermission;

    //Server Media
    serverMedia = existingLostFoundPostDetails!.media;

    //Tag location
    setTaggedLocation(
      selectedTaggedLocation: existingLostFoundPostDetails!.taggedlocation,
    );

    //emitting radius data
    radiusSliderCubit.emitRadius(feedRadiusModel.copyWith(
      socialMediaSearchRadius:
          existingLostFoundPostDetails!.postPreferenceRadius,
    ));

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
    super.dispose();
    titleTextController.dispose();
    incidentLocationTextController.dispose();
    descriptionTextController.dispose();
  }

  //Enable or disable the post button
  void postButtonValidator() {
    if (isEdit &&
        descriptionTextController.text.trim().isEmpty &&
        existingLostFoundPostDetails!.media.isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else if (!isEdit &&
        descriptionTextController.text.trim().isEmpty &&
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
        BlocProvider.value(value: uploadRegularPostCubit),
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
              GoRouter.of(context).pop(true);
            }
            return;
          }
        },
        builder: (context, uploadGeneralPostState) {
          return BlocListener<LocationTagControllerCubit,
              LocationTagControllerState>(
            listener: (context, locationTagControllerState) {
              setTaggedLocation(
                selectedTaggedLocation:
                    locationTagControllerState.taggedLocation,
              );
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
                    //Screen header
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ScreenHeader(title: tr(LocaleKeys.lostAndFound)),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: ThemeTextFormField(
                        controller: titleTextController,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.0,
                        ),
                        hint: tr(LocaleKeys.title),
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(104, 107, 116, 0.6),
                          fontSize: 15,
                        ),
                        maxLength: TextFieldInputLength.titleMaxLength,
                        validator: (value) =>
                            TextFieldValidator.standardValidatorWithMinLength(
                          value,
                          TextFieldInputLength.titleMinLength,
                        ),
                      ),
                    ),
                    //Lost found selection widget
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: LostFoundSelector(
                        preSelectedType: lostFoundType,
                        onSelection: (lostFoundType) {
                          this.lostFoundType = lostFoundType;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(LocaleKeys.incidentLocation),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ApplicationColours.themeBlueColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          ThemeTextFormField(
                            controller: incidentLocationTextController,
                            readOnly: true,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(fontSize: 14),
                            hint: tr(LocaleKeys.addLocation),
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(104, 107, 116, 0.6),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.location_on_sharp,
                              color: ApplicationColours.themeBlueColor,
                              size: 18,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                context
                                    .read<LocationTagControllerCubit>()
                                    .removeLocationTag();
                              },
                              child: const Icon(Icons.cancel, size: 18),
                            ),
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              GoRouter.of(context)
                                  .pushNamed<LocationAddressWithLatLng>(
                                      TagLocationScreen.routeName,
                                      extra: taggedLocation)
                                  .then((location) {
                                if (location != null) {
                                  context
                                      .read<LocationTagControllerCubit>()
                                      .addLocationTag(location);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    //Caption box
                    CaptionBoxWidget(
                      hintText: tr(LocaleKeys.lostFoundDescription),
                      allowTagLocation: false,
                      allowMediaPick: !isEdit,
                      scrollController: _scrollController,
                      gallaryFileType: FileType.media,
                      margin: const EdgeInsets.all(10),
                      captionTextController: descriptionTextController,
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
                      maxLength: TextFieldInputLength.descriptionMaxLength,
                      validator: (value) =>
                          TextFieldValidator.standardValidatorWithMinLength(
                        value,
                        TextFieldInputLength.descriptionMinLength,
                        isOptional: true,
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

                    //Post Radius Preference
                    PostMapRadiusPreferenceWidget(
                      postType: PostType.lostFound,
                      disableLocateMe: true,
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
                          child: ThemeElevatedButton(
                            buttonName: isEdit
                                ? tr(LocaleKeys.updatePost)
                                : tr(LocaleKeys.post),
                            showLoadingSpinner:
                                uploadGeneralPostState.isLoading,
                            disableButton: !activeButtonState.isEnabled,
                            onPressed: onPost,
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
