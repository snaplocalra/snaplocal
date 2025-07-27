import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_privacy_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/logic/group_privacy/group_privacy_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/logic/manage_group/manage_group_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/models/create_group_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/repository/manage_group_repository.dart';
import 'package:snap_local/common/social_media/create/create_group_or_page/social_media/widgets/upload_cover_image_widget.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_preselection_strategy.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/category/widgets/category_selection_bottom_sheet_v2.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_shimmer.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/widgets/bool_enable_option/bool_enable_option.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/text_drop_down_field_heading.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class CreateOrUpdateGroupDetailsScreen extends StatefulWidget {
  final GroupProfileDetailsModel? existGroupViewData;

  const CreateOrUpdateGroupDetailsScreen({
    super.key,
    this.existGroupViewData,
  });

  static const routeName = 'manage_group';

  @override
  State<CreateOrUpdateGroupDetailsScreen> createState() =>
      _CreateOrUpdateGroupDetailsScreenState();
}

class _CreateOrUpdateGroupDetailsScreenState
    extends State<CreateOrUpdateGroupDetailsScreen> {
  bool isEditMode = false;
  bool showFollower = true;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final createGroupScrollController = ScrollController();
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();
  final categoryController = TextEditingController();
  String? existingCoverImageUrl;
  LocationAddressWithLatLng? groupPreferencePosition;

  //Group privacy type
  CategoryModel? groupPrivacyType;

  // Create group cubit
  late ManageGroupCubit manageGroupCubit = ManageGroupCubit(
    manageGroupRepository: context.read<ManageGroupRepository>(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          GroupCategory(DualSubCategorySelectionStrategy()));

  //Selected categories
  CategoryListModelV2 selectedCategoryModel =
      const CategoryListModelV2(data: []);

  //Group privacy type
  late GroupPrivacyTypeCubit groupPrivacyTypeCubit = GroupPrivacyTypeCubit()
    //Select public by default
    ..selectGroupPrivacy(GroupPrivacyStatus.public.jsonValue);

  //Common
  List<MediaFileModel> pickedMedia = [];
  FeedRadiusModel? radiusPreference;
  late MediaPickCubit mediaPickCubit = MediaPickCubit();
  late RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  late LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());
  //

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  Future<void> _renderLocationAndFeedRadius({
    required FeedRadiusModel feedRadiusModel,
    required LocationAddressWithLatLng locationModel,
  }) async {
    //emitting feedRadius data
    await radiusSliderCubit.emitRadius(feedRadiusModel);

    //emitting location data
    await locationRenderCubit.emitLocation(
      locationAddressWithLatLong: locationModel,
      locationType: LocationType.socialMedia,
    );
  }

  //Set group category
  void setCategory(CategoryListModelV2 selectedCategory) {
    //assign the selected category to the selectedCategoryModel
    selectedCategoryModel = selectedCategory;

    //add the selected sub categories in the category text controller
    categoryController.text = selectedCategoryModel.selectedSubCategoryString();
  }

  ///This method will use to prefill the data in the edit mode
  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    final existingGroupDetails = widget.existGroupViewData!;

    existingCoverImageUrl = existingGroupDetails.coverImage;
    groupNameController.text = existingGroupDetails.name;
    groupDescriptionController.text = existingGroupDetails.description;

    //Fetch group privacy types and select by id
    groupPrivacyTypeCubit
        .selectGroupPrivacy(existingGroupDetails.groupPrivacyType.jsonValue);
    //Follower enable
    showFollower = existingGroupDetails.showFollower;
    //Fetch group privacy types and select by id

    final modifiedFeedRadiusModel = FeedRadiusModel(
      maxSearchVisibilityRadius: feedRadiusModel.maxSearchVisibilityRadius,
      socialMediaSearchRadius:
          existingGroupDetails.groupPreferenceRadius.toDouble(),
    );

    final modifiedLocationModel = LocationAddressWithLatLng(
      address: existingGroupDetails.address,
      latitude: existingGroupDetails.latitude,
      longitude: existingGroupDetails.longitude,
    );
    _renderLocationAndFeedRadius(
      feedRadiusModel: modifiedFeedRadiusModel,
      locationModel: modifiedLocationModel,
    );

    //set Group category
    categoryControllerCubit.fetchCategories(
      preselectionStrategy: CategoryV2PreselectionFromListModel(
        existingGroupDetails.category,
      ),
    );

    //listen to the category controller
    categoryControllerCubit.stream.listen((state) {
      if (state is CategoryControllerDataLoaded) {
        setCategory(state.categories);
      }
    });
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

      //Edit mode
      if (widget.existGroupViewData != null) {
        isEditMode = true;
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
    groupNameController.dispose();
    groupDescriptionController.dispose();
    createGroupScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: manageGroupCubit),
        BlocProvider.value(value: groupPrivacyTypeCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider.value(value: categoryControllerCubit),
      ],
      child: BlocConsumer<ManageGroupCubit, ManageGroupState>(
        listener: (context, manageGroupState) {
          if (manageGroupState.isRequestSuccess) {
            if (mounted) {
              try {
                GoRouter.of(context).pop();
                return;
              } catch (e) {
                // Record the error in Firebase Crashlytics
                FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
                return;
              }
            }
          }
        },
        builder: (context, createGroupState) {
          return PopScope(
            canPop: willPopScope(!createGroupState.isLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                elevation: 2,
                backgroundColor: Colors.white,
                onPop: () async => willPopScope(!createGroupState.isLoading),
                title: Text(
                  tr(
                    isEditMode
                        ? LocaleKeys.updateGroup
                        : LocaleKeys.createNewGroup,
                  ),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: ListView(
                controller: createGroupScrollController,
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
                          //Upload cover pic
                          UploadCoverImageWidget(
                            coverImageUrl: existingCoverImageUrl,
                            onMediaSelected: (selectedMediaList) {
                              pickedMedia = selectedMediaList;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.groupName),
                            child: ThemeTextFormField(
                              controller: groupNameController,
                              textInputAction: TextInputAction.next,
                              inputFormatters: const [
                                // FilteringTextInputFormatter.deny(RegExp('[ ]')),
                              ],
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(fontSize: 14),
                              hintStyle: const TextStyle(fontSize: 14),
                              maxLength:
                                  TextFieldInputLength.groupNameMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.groupNameMinLength,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.description),
                            showOptional: true,
                            child: ThemeTextFormField(
                              controller: groupDescriptionController,
                              textInputAction: TextInputAction.newline,
                              minLines: 5,
                              maxLines: 10,
                              contentPadding: const EdgeInsets.all(10),
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: const TextStyle(fontSize: 14),
                              maxLength: TextFieldInputLength
                                  .groupDescriptionMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.groupDescriptionMinLength,
                                isOptional: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          //Select group privacy type
                          BlocBuilder<GroupPrivacyTypeCubit,
                              GroupPrivacyTypeState>(
                            builder: (context, groupPrivacyTypeState) {
                              final logs = groupPrivacyTypeState
                                  .groupPrivacyTypesListModel.data;

                              groupPrivacyType = groupPrivacyTypeState
                                  .groupPrivacyTypesListModel.selectedFirstData;

                              return TextDropdownFieldWithHeading(
                                textFieldHeading: tr(LocaleKeys.groupType),
                                textFieldDropDownField:
                                    ThemeTextFormFieldDropDown<CategoryModel>(
                                  hint: groupPrivacyTypeState.dataLoading
                                      ? "Loading types..."
                                      : "Select Group Type",
                                  hintStyle: const TextStyle(fontSize: 14),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  value: groupPrivacyType,
                                  onChanged: (CategoryModel? newValue) {
                                    if (newValue != null) {
                                      context
                                          .read<GroupPrivacyTypeCubit>()
                                          .selectGroupPrivacy(newValue.id);
                                    }
                                  },
                                  textInputAction: TextInputAction.next,
                                  items: logs
                                      .map((CategoryModel groupPrivacyTypes) {
                                    return DropdownMenuItem(
                                      value: groupPrivacyTypes,
                                      child: Text(
                                        groupPrivacyTypes.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please select the group type";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                          // group category
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.groupCategory),
                            child: ThemeTextFormField(
                              readOnly: true,
                              controller: categoryController,
                              textInputAction: TextInputAction.next,
                              contentPadding: const EdgeInsets.all(10),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hint: tr(LocaleKeys.selectCategory),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  builder: (context) {
                                    return CategorySelectionBottomSheetV2(
                                      categoryControllerCubit:
                                          categoryControllerCubit,
                                      onCategorySelected: setCategory,
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 10),
                          //Followers enable option
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: BoolEnableOptionWidget(
                              title: LocaleKeys.memberList,
                              enableText: LocaleKeys.show,
                              disableText: LocaleKeys.hide,
                              enable: showFollower,
                              onEnableChanged: (status) {
                                showFollower = status;
                              },
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
                        //emitting location data
                        await locationRenderCubit.emitLocation(
                          locationAddressWithLatLong:
                              locationServiceState.location,
                          locationType: LocationType.socialMedia,
                        );
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
                            final socialMediaLocation =
                                locationRenderState.socialMediaLocation;

                            groupPreferencePosition = socialMediaLocation;

                            LatLng? postFeedCoOrdinates;

                            if (groupPreferencePosition != null) {
                              postFeedCoOrdinates = LatLng(
                                groupPreferencePosition!.latitude,
                                groupPreferencePosition!.longitude,
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: postFeedCoOrdinates == null
                                  ? const MapAndFeedRadiusWidgetShimmer()
                                  : MapAndFeedRadiusWidget(
                                      headingText: Text(
                                        tr(LocaleKeys.postRadiusPreference),
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
                                            .emitRadius(radiusPreference!
                                                .copyWith(
                                                    socialMediaSearchRadius:
                                                        value));
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
                              ? LocaleKeys.updateGroup
                              : LocaleKeys.createNewGroup,
                        ),
                        showLoadingSpinner: createGroupState.isLoading,
                        disableButton:
                            locationServiceState == LoadingLocation(),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (groupPreferencePosition == null) {
                            ThemeToast.errorToast(
                                tr(LocaleKeys.pleaseselectalocation));
                            return;
                          } else if (radiusPreference == null) {
                            ThemeToast.errorToast(
                                tr(LocaleKeys.pleaseselectapostfeedradius));
                            return;
                          } else if (radiusPreference == null) {
                            ThemeToast.errorToast(
                                "Please select the group radius");
                            return;
                          } else if (selectedCategoryModel
                              .isNoSubCategorySelected) {
                            ThemeToast.errorToast("Please select category");
                            return;
                          } else {
                            if (formkey.currentState!.validate()) {
                              //logic to upload post
                              final createGroupModel = CreateGroupModel(
                                category: selectedCategoryModel,
                                groupPrivacyType: groupPrivacyType!.id,
                                groupName: groupNameController.text.trim(),
                                description:
                                    groupDescriptionController.text.trim(),
                                groupPreferenceRadius: radiusPreference!
                                    .socialMediaSearchRadius
                                    .toInt(),
                                address: groupPreferencePosition!.address,
                                latitude: groupPreferencePosition!.latitude,
                                longitude: groupPreferencePosition!.longitude,
                                enableFollower: showFollower,
                              );
                              context
                                  .read<ManageGroupCubit>()
                                  .createOrUpdateGroupDetails(
                                    groupDetailsModel: createGroupModel,
                                    pickedMediaList: pickedMedia,

                                    //Edit mode
                                    groupId: widget.existGroupViewData?.id,
                                    existingCoverImageUrl:
                                        existingCoverImageUrl,
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
