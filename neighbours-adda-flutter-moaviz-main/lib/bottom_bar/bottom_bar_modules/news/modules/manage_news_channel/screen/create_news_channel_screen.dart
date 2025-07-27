import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/logic/manage_news_channel/manage_news_channel_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/model/manage_news_channel_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/repository/manage_news_channel_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/screen/manage_post_news.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_channel_details/own_news_channel_cubit.dart';
import 'package:snap_local/common/social_media/create/create_group_or_page/social_media/widgets/upload_cover_image_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_shimmer.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/widgets/bool_enable_option/bool_enable_option.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class CreateNewsChannelScreen extends StatefulWidget {
  final ManageNewsChannelModel? existingManageNewsChannelModel;
  const CreateNewsChannelScreen(
      {super.key, this.existingManageNewsChannelModel});

  static const routeName = 'manage_News';

  @override
  State<CreateNewsChannelScreen> createState() =>
      _CreateNewsChannelScreenState();
}

class _CreateNewsChannelScreenState extends State<CreateNewsChannelScreen> {
  //text controller
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late bool isEditMode = widget.existingManageNewsChannelModel != null;
  final channelNameController = TextEditingController();
  final channelDescriptionController = TextEditingController();
  final newsReporterNameController = TextEditingController();
  final newsLocationTextController = TextEditingController();

  // cubit initialize
  late ManageNewsChannelCubit manageNewsChannelCubit = ManageNewsChannelCubit(
    mediaUploadRepository: context.read<MediaUploadRepository>(),
    manageNewsChannelRepository: ManageNewsChannelRepositoryImpl(),
  );

  late MediaPickCubit mediaPickCubit = MediaPickCubit();
  late RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  late LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  //Tagged location
  late LocationTagControllerCubit locationTagControllerCubit =
      LocationTagControllerCubit();

  //Selected language
  LanguageEnum channelLanguage = LanguageEnum.english;

  //Cover Image
  String? coverImageUrl;

  //common
  List<MediaFileModel> pickedMedia = [];
  bool enableChat = true;

  // data model
  FeedRadiusModel? radiusPreference;
  LocationAddressWithLatLng? channelPreferencePosition;

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

      //Edit mode
      if (isEditMode) {
        prefillData(feedRadiusModel: feedRadiusModel);
      } else {
        if (locationModel != null) {
          //Render the location and feed radius
          _renderLocationAndFeedRadius(
            feedRadiusModel: feedRadiusModel.copyWith(
              socialMediaSearchRadius:
                  feedRadiusModel.maxSearchVisibilityRadius,
            ),
            locationModel: locationModel,
          );

          //Set the channel language from the news language change controller
          channelLanguage = context
              .read<NewsLanguageChangeControllerCubit>()
              .state
              .selectedLanguage
              .languageEnum;
        }
      }
    } else {
      throw ("Profile data not available");
    }
  }

  ///This method will use to prefill the data in the edit mode
  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    final existingNewsChannel = widget.existingManageNewsChannelModel!;

    //Channel Name
    channelNameController.text = existingNewsChannel.name;

    //Cover Image
    coverImageUrl = existingNewsChannel.coverImageUrl;

    //Channel Description
    channelDescriptionController.text = existingNewsChannel.description;

    //Contributor Name
    newsReporterNameController.text = existingNewsChannel.reporterName;

    //chat enable
    enableChat = existingNewsChannel.enableChat;

    //Language
    channelLanguage = existingNewsChannel.language;

    //News channel location text controller
    newsLocationTextController.text = existingNewsChannel.location.address;

    //Location and radius
    final modifiedFeedRadiusModel = FeedRadiusModel(
      maxSearchVisibilityRadius: feedRadiusModel.maxSearchVisibilityRadius,
      // socialMediaSearchRadius: existingNewsChannel.preferenceRadius.toDouble(),

      //Set the default radius to the max radius as per client requirement
      socialMediaSearchRadius: feedRadiusModel.maxSearchVisibilityRadius,
    );

    _renderLocationAndFeedRadius(
      feedRadiusModel: modifiedFeedRadiusModel,
      locationModel: existingNewsChannel.location,
    );
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

      //set channel location
      await setChannelLocation(locationModel);
    });
  }

  Future<void> setChannelLocation(LocationAddressWithLatLng location) async {
    newsLocationTextController.text = location.address;

    //emitting location data
    await locationRenderCubit.emitLocation(
      locationAddressWithLatLong: location,
      locationType: LocationType.socialMedia,
    );
  }

  // Clear target location
  void clearChannelLocation() {
    newsLocationTextController.clear();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  void dispose() {
    channelNameController.dispose();
    channelDescriptionController.dispose();
    newsReporterNameController.dispose();
    newsLocationTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: manageNewsChannelCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider.value(value: locationTagControllerCubit),
      ],
      child: BlocConsumer<ManageNewsChannelCubit, ManageNewsChannelState>(
        listener: (context, manageNewsChannelState) {
          if (manageNewsChannelState.isRequestSuccess) {
            if (mounted) {
              try {
                //Update the own news channel details
                context.read<OwnNewsChannelCubit>().fetchOwnNewsChannel();
                //Close the screen
                GoRouter.of(context).pop();
                if (!isEditMode) {
                  //Show success dialog, and there will be a button called start posting news.
                  //If user click on that button, then it will navigate to news post screen.
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog.adaptive(
                      title: Text(tr(LocaleKeys.newsChannelCreated)),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        color: ApplicationColours.themeBlueColor,
                        fontWeight: FontWeight.w500,
                      ),
                      content: Text(
                        tr(LocaleKeys.startPostingYourFirstNewsNow),
                        style: TextStyle(
                          fontSize: 15,
                          color: ApplicationColours.themeBlueColor,
                        ),
                      ),
                      actions: [
                        BlocBuilder<OwnNewsChannelCubit, OwnNewsChannelState>(
                          builder: (context, ownNewsChannelState) {
                            return ThemeElevatedButton(
                              padding: const EdgeInsets.all(10),
                              textFontSize: 12,
                              showLoadingSpinner:
                                  ownNewsChannelState is OwnNewsChannelLoading,
                              onPressed: () {
                                GoRouter.of(context).pop();
                                GoRouter.of(context)
                                    .pushNamed(ManagePostNewsScreen.routeName);
                              },
                              buttonName: tr(LocaleKeys.postNews),
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
                return;
              } catch (e) {
                // Record the error in Firebase Crashlytics
                FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
                return;
              }
            }
          }
        },
        builder: (context, manageNewsChannelState) {
          return PopScope(
            canPop: willPopScope(!manageNewsChannelState.isLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                backgroundColor: Colors.white,
                showBackButton: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(
                        isEditMode
                            ? LocaleKeys.updateYourOwnNewsChannel
                            : LocaleKeys.createYourOwnNewsChannel,
                      ),
                      style: TextStyle(
                        color: ApplicationColours.themeBlueColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      tr(LocaleKeys.becomeANewsReporter),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                appBarHeight: 60,
              ),
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formkey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          //Create Channel Icon
                          SvgPicture.asset(
                            SVGAssetsImages.createChannel,
                            height: 200,
                          ),
                          const SizedBox(height: 10),

                          //Channel Name
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.channelName),
                            child: ThemeTextFormField(
                              controller: channelNameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(fontSize: 14),
                              enabled: !isEditMode,
                              hintStyle: const TextStyle(fontSize: 14),
                              maxLength: TextFieldInputLength.pageNameMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.pageNameMinLength,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Cover Image
                          UploadCoverImageWidget(
                            coverImageUrl: coverImageUrl,
                            onMediaSelected: (selectedMediaList) {
                              pickedMedia = selectedMediaList;
                            },
                          ),
                          const SizedBox(height: 10),

                          //Description
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.channelDescription),
                            child: ThemeTextFormField(
                              controller: channelDescriptionController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 8,
                              minLines: 4,
                              contentPadding: const EdgeInsets.all(10),
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: const TextStyle(fontSize: 14),
                              maxLength:
                                  TextFieldInputLength.pageDescriptionMaxLength,
                              validator: (value) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                value,
                                TextFieldInputLength.pageDescriptionMinLength,
                                isOptional: true,
                              ),
                            ),
                          ),

                          //Language
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.language),
                            showStarMark: true,
                            child: ThemeTextFormFieldDropDown<LanguageEnum>(
                              value: channelLanguage,
                              items: context
                                  .read<NewsLanguageChangeControllerCubit>()
                                  .state
                                  .languagesModel
                                  .languages
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.languageEnum,
                                      child: Text(
                                        e.languageEnum.nativeName,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 12),
                              hintStyle: const TextStyle(fontSize: 12),
                              onChanged: (value) {
                                if (value != null) {
                                  channelLanguage = value;
                                }
                              },
                            ),
                          ),

                          //Contributor Name
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.newsReporterName),
                            child: ThemeTextFormField(
                              controller: newsReporterNameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(fontSize: 14),
                              hintStyle: const TextStyle(fontSize: 14),
                              maxLength: TextFieldInputLength.pageNameMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.pageNameMinLength,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Chat Enable
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: BoolEnableOptionWidget(
                              title: LocaleKeys.chatContact,
                              enable: enableChat,
                              onEnableChanged: (status) {
                                enableChat = status;
                              },
                            ),
                          ),

                          //News Tag location
                          BlocListener<LocationTagControllerCubit,
                              LocationTagControllerState>(
                            listener: (context, locationTagControllerState) {
                              final selectedTaggedLocation =
                                  locationTagControllerState.taggedLocation;
                              if (selectedTaggedLocation != null) {
                                setChannelLocation(selectedTaggedLocation);
                              } else {
                                clearChannelLocation();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetHeading(
                                      title: tr(LocaleKeys.newsLocation)),
                                  const SizedBox(height: 2),
                                  ThemeTextFormField(
                                    controller: newsLocationTextController,
                                    readOnly: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
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
                                    // suffixIcon: GestureDetector(
                                    //   onTap: () {
                                    //     context
                                    //         .read<LocationTagControllerCubit>()
                                    //         .removeLocationTag();
                                    //   },
                                    //   child: const Icon(Icons.cancel, size: 18),
                                    // ),
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      GoRouter.of(context)
                                          .pushNamed<LocationAddressWithLatLng>(
                                        TagLocationScreen.routeName,
                                        extra: locationTagControllerCubit
                                            .state.taggedLocation,
                                      )
                                          .then((location) {
                                        if (location != null &&
                                            context.mounted) {
                                          context
                                              .read<
                                                  LocationTagControllerCubit>()
                                              .addLocationTag(location);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Post Radius Preference
                  BlocListener<LocationServiceControllerCubit,
                      LocationServiceControllerState>(
                    listener: (context, locationServiceState) async {
                      if (locationServiceState is LocationFetched) {
                        setChannelLocation(locationServiceState.location);
                      } else if (locationServiceState is LocationError) {
                        if (locationServiceState.locationPermanentDenied) {
                          await showLocationPermissionPermanentDeniedHandlerDialog(
                              context);
                        }
                      }
                    },
                    child:
                        BlocBuilder<LocationRenderCubit, LocationRenderState>(
                      builder: (context, locationRenderState) {
                        return BlocBuilder<RadiusSliderRenderCubit,
                            RadiusSliderRenderState>(
                          builder: (context, radiusSliderState) {
                            radiusPreference =
                                radiusSliderState.feedRadiusModel;
                            final maxRadius =
                                radiusPreference!.maxSearchVisibilityRadius;
                            final location =
                                locationRenderState.socialMediaLocation;

                            channelPreferencePosition = location;

                            LatLng? postFeedCoOrdinates;

                            if (channelPreferencePosition != null) {
                              postFeedCoOrdinates = LatLng(
                                channelPreferencePosition!.latitude,
                                channelPreferencePosition!.longitude,
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: postFeedCoOrdinates == null
                                  ? const MapAndFeedRadiusWidgetShimmer()
                                  : MapAndFeedRadiusWidget(
                                      disableRadiusSlider: true,
                                      headingText: Text(
                                        tr(LocaleKeys.channelRadiusPreference),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      // circleRadius: circleRadius,
                                      maxRadius: maxRadius,
                                      zoom: 15,
                                      userSelectedRadius: radiusPreference!
                                          .socialMediaSearchRadius,
                                      currentSelectedLatLng:
                                          postFeedCoOrdinates,
                                      onLocateMe: () {
                                        context
                                            .read<
                                                LocationServiceControllerCubit>()
                                            .locationFetchByDeviceGPS();
                                      },
                                      onRadiusChanged: (value) {
                                        context
                                            .read<RadiusSliderRenderCubit>()
                                            .emitRadius(
                                                radiusPreference!.copyWith(
                                              socialMediaSearchRadius: value,
                                            ));
                                      },
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //Post Button
                  BlocBuilder<LocationServiceControllerCubit,
                      LocationServiceControllerState>(
                    builder: (context, locationServiceState) {
                      return ThemeElevatedButton(
                        buttonName: tr(
                          isEditMode
                              ? LocaleKeys.updateChannel
                              : LocaleKeys.createChannel,
                        ),
                        showLoadingSpinner: manageNewsChannelState.isLoading,
                        disableButton:
                            locationServiceState == LoadingLocation(),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (channelPreferencePosition == null) {
                            ThemeToast.errorToast(
                                tr(LocaleKeys.pleaseselectalocation));
                            return;
                          } else if (radiusPreference == null) {
                            ThemeToast.errorToast(
                                tr(LocaleKeys.pleaseSelectANewsRadius));
                            return;
                          } else if (pickedMedia.isEmpty &&
                              coverImageUrl == null) {
                            ThemeToast.errorToast(
                                tr(LocaleKeys.pleaseSelectCoverImage));
                            return;
                          } else {
                            if (formkey.currentState!.validate()) {
                              final newsChannelData = ManageNewsChannelModel(
                                id: widget.existingManageNewsChannelModel?.id,
                                name: channelNameController.text.trim(),
                                description:
                                    channelDescriptionController.text.trim(),
                                coverImageUrl: coverImageUrl,
                                reporterName:
                                    newsReporterNameController.text.trim(),
                                enableChat: enableChat,
                                preferenceRadius: radiusPreference!
                                    .socialMediaSearchRadius
                                    .toInt(),
                                location: channelPreferencePosition!,
                                language: channelLanguage,
                              );

                              context
                                  .read<ManageNewsChannelCubit>()
                                  .createOrUpdateNewsChannel(
                                    createNewsChannel: newsChannelData,
                                    pickedMediaList: pickedMedia,
                                    isEdit: isEditMode,
                                  );
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
