import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/logic/manage_page/manage_page_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/models/create_page_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/repository/manage_page_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/models/page_detail_model.dart';
import 'package:snap_local/common/social_media/create/create_group_or_page/social_media/widgets/upload_cover_image_widget.dart';
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
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

import '../../../../../../../../common/utils/widgets/bool_enable_option/bool_enable_option.dart';

class CreateOrUpdatePageDetailsScreen extends StatefulWidget {
  final PageProfileDetailsModel? existPageViewData;

  const CreateOrUpdatePageDetailsScreen({
    super.key,
    this.existPageViewData,
  });

  static const routeName = 'manage_Page';

  @override
  State<CreateOrUpdatePageDetailsScreen> createState() =>
      _CreateOrUpdatePageDetailsScreenState();
}

class _CreateOrUpdatePageDetailsScreenState
    extends State<CreateOrUpdatePageDetailsScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isEditMode = false;

  final createPageScrollController = ScrollController();

  //data models
  final pageNameController = TextEditingController();
  final pageDescriptionController = TextEditingController();
  final categoryController = TextEditingController();
  String? existingCoverImageUrl;
  LocationAddressWithLatLng? pagePreferencePosition;

  late ManagePageCubit managePageCubit = ManagePageCubit(
    managePageRepository: context.read<ManagePageRepository>(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );

  //Common
  List<MediaFileModel> pickedMedia = [];
  FeedRadiusModel? radiusPreference;
  late MediaPickCubit mediaPickCubit = MediaPickCubit();
  late RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  late LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  //
  bool enableChat = true;
  bool showFollower = true;
  bool willPopScope(bool allowPop) {
    return allowPop;
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

  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(PageCategory(DualSubCategorySelectionStrategy()));

  //Selected categories
  CategoryListModelV2 selectedCategoryModel =
      const CategoryListModelV2(data: []);
  //Set page category
  void setCategory(CategoryListModelV2 selectedCategoryModel) {
    this.selectedCategoryModel = selectedCategoryModel;

    //add the selected sub categories in the category text controller
    categoryController.text = selectedCategoryModel.selectedSubCategoryString();
  }

  ///This method will use to prefill the data in the edit mode
  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    final existingPageDetails = widget.existPageViewData!;

    existingCoverImageUrl = existingPageDetails.coverImage;
    pageNameController.text = existingPageDetails.name;
    pageDescriptionController.text = existingPageDetails.description;
    //chat enable
    enableChat = existingPageDetails.enableChat;
    //Follower enable
    showFollower = existingPageDetails.showFollower;

    final modifiedFeedRadiusModel = FeedRadiusModel(
      maxPageVisibilityRadius: feedRadiusModel.maxPageVisibilityRadius,
      socialMediaSearchRadius:
          existingPageDetails.pagePreferenceRadius.toDouble(),
    );

    final modifiedLocationModel = LocationAddressWithLatLng(
      address: existingPageDetails.address,
      latitude: existingPageDetails.latitude,
      longitude: existingPageDetails.longitude,
    );
    _renderLocationAndFeedRadius(
      feedRadiusModel: modifiedFeedRadiusModel,
      locationModel: modifiedLocationModel,
    );

    //set job category
    categoryControllerCubit.fetchCategories(
      preselectionStrategy: CategoryV2PreselectionFromListModel(
        existingPageDetails.category,
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
      if (widget.existPageViewData != null) {
        isEditMode = true;
        prefillData(feedRadiusModel: feedRadiusModel);
      } else {
        if (locationModel != null) {
          _renderLocationAndFeedRadius(
            feedRadiusModel: feedRadiusModel.copyWith(
              socialMediaSearchRadius:
                  //70% of feedRadiusModel.maxPageVisibilityRadius
                  feedRadiusModel.maxPageVisibilityRadius * 0.7,
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
    pageNameController.dispose();
    pageDescriptionController.dispose();
    createPageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: managePageCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
      ],
      child: BlocConsumer<ManagePageCubit, ManagePageState>(
        listener: (context, managePageState) {
          if (managePageState.isRequestSuccess) {
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
        builder: (context, createNewsState) {
          return PopScope(
            canPop: willPopScope(!createNewsState.isLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                elevation: 2,
                backgroundColor: Colors.white,
                onPop: () async => willPopScope(!createNewsState.isLoading),
                title: Text(
                  tr(
                    isEditMode
                        ? LocaleKeys.updatePage
                        : LocaleKeys.createNewPage,
                  ),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: SafeArea(
                child: ListView(
                  controller: createPageScrollController,
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
                              textFieldHeading: tr(LocaleKeys.pageName),
                              child: ThemeTextFormField(
                                controller: pageNameController,
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
                            TextFieldWithHeading(
                              textFieldHeading: tr(LocaleKeys.description),
                              showOptional: true,
                              child: ThemeTextFormField(
                                controller: pageDescriptionController,
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
                            const SizedBox(height: 10),

                            //Select Page category
                            /*BlocBuilder<PageCategoryCubit, PageCategoryState>(
                              builder: (context, pageCategoryState) {
                                final logs = pageCategoryState
                                    .pageCategoriesListModel.data;

                                final selectedData = pageCategoryState
                                    .pageCategoriesListModel.selectedData;
                                if (selectedData != null) {
                                  pageCategory = selectedData;
                                }
                                return TextDropdownFieldWithHeading(
                                  textFieldHeading: tr(LocaleKeys.pageCategory),
                                  textFieldDropDownField:
                                      ThemeTextFormFieldDropDown<CategoryModel>(
                                    hint: pageCategoryState.dataLoading
                                        ? "Loading Categories..."
                                        : "Select Page Category",
                                    hintStyle: const TextStyle(fontSize: 14),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    value: pageCategory,
                                    onChanged: (CategoryModel? newValue) {
                                      if (newValue != null) {
                                        context
                                            .read<PageCategoryCubit>()
                                            .selectPageCategory(newValue.id);
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                    items: logs.map((CategoryModel pageCategory) {
                                      return DropdownMenuItem(
                                        value: pageCategory,
                                        child: Text(
                                          pageCategory.name,
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
                                        return "Please select the Page category";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                );
                              },
                            ),*/
                            TextFieldWithHeading(
                              textFieldHeading: tr(LocaleKeys.pageCategory),
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
                            //Chat enable option
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: BoolEnableOptionWidget(
                                title: LocaleKeys.chat,
                                enable: enableChat,
                                onEnableChanged: (status) {
                                  enableChat = status;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            //Followers enable option
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: BoolEnableOptionWidget(
                                title: LocaleKeys.followersList,
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
                              // double circleRadius = (radiusPreference!
                              //         .userSelectedFeedRadius
                              //         .toDouble() *
                              //     1000);

                              final maxRadius =
                                  radiusPreference!.maxPageVisibilityRadius;
                              final location =
                                  locationRenderState.socialMediaLocation;

                              pagePreferencePosition = location;

                              LatLng? postFeedCoOrdinates;

                              if (pagePreferencePosition != null) {
                                postFeedCoOrdinates = LatLng(
                                  pagePreferencePosition!.latitude,
                                  pagePreferencePosition!.longitude,
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
                                ? LocaleKeys.updatePage
                                : LocaleKeys.createPage,
                          ),
                          showLoadingSpinner: createNewsState.isLoading,
                          disableButton:
                              locationServiceState == LoadingLocation(),
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (pagePreferencePosition == null) {
                              ThemeToast.errorToast(
                                  tr(LocaleKeys.pleaseselectalocation));
                              return;
                            } else if (radiusPreference == null) {
                              ThemeToast.errorToast(
                                  "Please select the page radius");
                              return;
                            } else if (selectedCategoryModel
                                .isNoSubCategorySelected) {
                              ThemeToast.errorToast("Please select category");
                              return;
                            } else {
                              if (formkey.currentState!.validate()) {
                                //logic to upload post
                                final createPageModel = CreatePageModel(
                                  category: selectedCategoryModel,
                                  pageName: pageNameController.text.trim(),
                                  description:
                                      pageDescriptionController.text.trim(),
                                  pagePreferenceRadius: radiusPreference!
                                      .socialMediaSearchRadius
                                      .toInt(),
                                  address: pagePreferencePosition!.address,
                                  latitude: pagePreferencePosition!.latitude,
                                  longitude: pagePreferencePosition!.longitude,
                                  enableChat: enableChat,
                                  showFollower: showFollower,
                                );
                                context
                                    .read<ManagePageCubit>()
                                    .createOrUpdatePageDetails(
                                      pageDetailsModel: createPageModel,
                                      pickedMediaList: pickedMedia,

                                      //Edit mode
                                      pageId: widget.existPageViewData?.id,
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
            ),
          );
        },
      ),
    );
  }
}
