// ignore_for_file: use_build_context_synchronously

import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/logic/business_timming/business_timming_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/widgets/business_timming_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/logic/manage_business/manage_business_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/logic/manage_discount/manage_discount_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_manage_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/repository/manage_business_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/widgets/business_discount_slot_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/models/business_details_model.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
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
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_shimmer.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/delete_dialog.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/multi_media_selection_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/check_box_with_text/widget/check_box_with_text.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common/utils/widgets/bool_enable_option/bool_enable_option.dart';

class CreateOrUpdateBusinessScreen extends StatefulWidget {
  final BusinessDetailsModel? existBusinessData;

  const CreateOrUpdateBusinessScreen({
    super.key,
    this.existBusinessData,
  });

  static const routeName = 'manage_business';

  @override
  State<CreateOrUpdateBusinessScreen> createState() =>
      _CreateOrUpdateBusinessScreenState();
}

class _CreateOrUpdateBusinessScreenState
    extends State<CreateOrUpdateBusinessScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isEditMode = false;

  final manageBusinessScrollController = ScrollController();
  final activeButtonCubit = ActiveButtonCubit();

  //data models
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessMobileController = TextEditingController();
  final businessDiscountPercentageController = TextEditingController();
  final businessLocationController = TextEditingController();
  final websiteLinkController = TextEditingController();
  final otherCategoryController = TextEditingController();
  final categoryController = TextEditingController();
  final businessLocationTagControllerCubit = LocationTagControllerCubit();

  //Business location
  LocationAddressWithLatLng? businessLocation;

  bool enableChat = true;

  List<NetworkMediaModel> serverMedia = [];
  LocationAddressWithLatLng? businessPreferencePosition;

  late ManageBusinessRepository manageBusinessRepository =
      context.read<ManageBusinessRepository>();

  late ManageBusinessCubit manageBusinessCubit = ManageBusinessCubit(
    mediaUploadRepository: context.read<MediaUploadRepository>(),
    manageBusinessRepository: manageBusinessRepository,
  );
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          BusinessCategory(DualSubCategorySelectionStrategy()));

  //Selected categories
  CategoryListModelV2 selectedCategoryModel =
      const CategoryListModelV2(data: []);
  //business discount in percentage
  final ManageDiscountOptionCubit disocuntsInPercentageCubit =
      ManageDiscountOptionCubit();

  //business discount in price
  final ManageDiscountOptionCubit disocuntsInPriceCubit =
      ManageDiscountOptionCubit();

  bool hasDiscount = false;

  //Common
  List<MediaFileModel> pickedMedia = [];
  FeedRadiusModel? radiusPreference;
  late MediaPickCubit mediaPickCubit = MediaPickCubit();
  late RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  late LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());
  late BusinessHoursCubit businessHoursCubit = BusinessHoursCubit();
  //

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
        locationType: LocationType.marketPlace,
      );
    });
  }

//Set business category
  void setCategory(CategoryListModelV2 selectedCategory) {
    //assign the selected category to the selectedCategoryModel
    selectedCategoryModel = selectedCategory;

    //add the selected sub categories in the category text controller
    categoryController.text = selectedCategoryModel.selectedSubCategoryString();
  }

  ///This method will use to prefill the data in the edit mode
  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    final existingBusinessDetails = widget.existBusinessData!;

    //media
    serverMedia = existingBusinessDetails.media;

    //Business Name
    businessNameController.text = existingBusinessDetails.businessName;

    /* //Fetch business types and select by id
    businessCategoryCubit.fetchBusinessCategories(
        businessCategoryId: existingBusinessDetails.businessCategoryId);*/

    //Other category if available

    //Business address
    businessAddressController.text = existingBusinessDetails.businessAddress;

    //Set business location
    setBusinessLocation(existingBusinessDetails.businessLocation);

    //Business hours
    businessHoursCubit
        .renderBusinessHours(existingBusinessDetails.businessHoursModel);

    //website link
    websiteLinkController.text = existingBusinessDetails.websiteLink;

    //Business Mobile number
    businessMobileController.text = existingBusinessDetails.phoneNumber;

    //chat enable
    enableChat = existingBusinessDetails.enableChat;

    //Discount show status
    hasDiscount = existingBusinessDetails.hasDiscount;

    if (hasDiscount) {
      //Discount in percentage
      disocuntsInPercentageCubit
          .addInitialData(existingBusinessDetails.discountInPercentage);

      //Discount in price
      disocuntsInPriceCubit
          .addInitialData(existingBusinessDetails.discountInPrice);
    }

    //emitting radius data
    radiusSliderCubit.emitRadius(feedRadiusModel.copyWith(
      marketPlaceSearchRadius: existingBusinessDetails.businessPreferenceRadius,
    ));

    //set business category
    categoryControllerCubit.fetchCategories(
      preselectionStrategy: CategoryV2PreselectionFromListModel(
        existingBusinessDetails.category,
      ),
    );

    //listen to the category controller
    categoryControllerCubit.stream.listen((state) {
      if (state is CategoryControllerDataLoaded) {
        setCategory(state.categories);
      }
    });
  }

  void _clearDiscountData() {
    businessDiscountPercentageController.clear();
    // businessDisocuntsOnCubit.clearAllSelection();
  }

  //Set work location
  Future<void> setBusinessLocation(LocationAddressWithLatLng location) async {
    businessLocation = location;
    businessLocationController.text = location.address;

    //Add location tag
    //emitting location data
    await locationRenderCubit.emitLocation(
      locationAddressWithLatLong: location,
      locationType: LocationType.marketPlace,
    );
  }

  //clean work location
  void cleanBusinessLocation() {
    businessLocation = null;
    businessLocationController.clear();
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
          profileSettingState.profileSettingsModel!.marketPlaceLocation;

      //Edit mode
      if (widget.existBusinessData != null) {
        isEditMode = true;
        prefillData(feedRadiusModel: feedRadiusModel);
      } else {
        if (locationModel != null) {
          _renderLocationAndFeedRadius(
            feedRadiusModel: feedRadiusModel.copyWith(
              marketPlaceSearchRadius:
                  //70% of feedRadiusModel.maxSearchVisibilityRadius
                  feedRadiusModel.maxSearchVisibilityRadius * 0.7,
            ),
            locationModel: locationModel,
          );
        }

        //Fetch business deals categories
        // businessDealCategoryCubit.fetchBusinessDealCategories(
        //     dataPreSelect: false);

        //Fetch business discount categories
        // businessDisocuntsOnCubit.fetchBusinessDealCategories(
        //     dataPreSelect: false);
      }
    } else {
      throw ("Profile data not available");
    }
  }

  @override
  void dispose() {
    super.dispose();
    manageBusinessScrollController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    businessMobileController.dispose();
    businessDiscountPercentageController.dispose();
    businessLocationController.dispose();
    websiteLinkController.dispose();
    otherCategoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: manageBusinessCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider.value(value: businessHoursCubit),
        BlocProvider.value(value: businessLocationTagControllerCubit),
      ],
      child: BlocConsumer<ManageBusinessCubit, ManageBusinessState>(
        listener: (context, manageBusinessState) {
          if (manageBusinessState.isRequestSuccess) {
            if (mounted) {
              GoRouter.of(context).pop();
              return;
            }
          } else if (manageBusinessState.isDeleteSuccess) {
            if (mounted) {
              GoRouter.of(context).pop();
            }
          }
        },
        builder: (context, manageBusinessState) {
          // final mqSize = MediaQuery.sizeOf(context);

          return PopScope(
            canPop: willPopScope(!manageBusinessState.isLoading &&
                !manageBusinessState.isDeleteLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                elevation: 2,
                backgroundColor: Colors.white,
                onPop: () async => willPopScope(
                    !manageBusinessState.isLoading &&
                        !manageBusinessState.isDeleteLoading),
                title: Text(
                  tr(
                    isEditMode
                        ? LocaleKeys.updateBusinessPage
                        : LocaleKeys.createBusinessPage,
                  ),
                  style: TextStyle(
                      color: ApplicationColours.themeBlueColor, fontSize: 16),
                ),
                actions: [
                  //Delete business, show delete confirm dialog
                  if (isEditMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircularSvgButton(
                        showLoading: manageBusinessState.isDeleteLoading,
                        svgImage: SVGAssetsImages.delete,
                        iconColor: Colors.white,
                        backgroundColor: ApplicationColours.themeLightPinkColor,
                        onTap: () async {
                          await showDeleteAlertDialog(
                            context,
                            description:
                                "Are you sure you want to delete this business?",
                          ).then((value) {
                            if (value) {
                              context
                                  .read<ManageBusinessCubit>()
                                  .deleteBusiness(widget.existBusinessData!.id);
                            }
                          });
                        },
                      ),
                    ),
                ],
              ),
              body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: manageBusinessScrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  children: [
                    //Upload business pics
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: MultiMediaSelectionWidget(
                        serverMedia: serverMedia,
                        onServerMediaUpdated: (serverMediaList) {
                          serverMedia = serverMediaList;
                        },
                        onMediaSelected: (selectedMediaList) {
                          pickedMedia = selectedMediaList;
                        },
                        fileType: FileType.media,
                      ),
                    ),
                    const SizedBox(height: 10),

                    //Business details
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                //Business Name
                                TextFieldWithHeading(
                                  textFieldHeading: tr(LocaleKeys.businessName),
                                  child: ThemeTextFormField(
                                    controller: businessNameController,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: const [
                                      // FilteringTextInputFormatter.deny(RegExp('[ ]')),
                                    ],
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: const TextStyle(fontSize: 14),
                                    hintStyle: const TextStyle(fontSize: 14),
                                    maxLength: TextFieldInputLength
                                        .businessNameMaxLength,
                                    validator: (text) => TextFieldValidator
                                        .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength
                                          .businessNameMinLength,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                //Select Business category
                                TextFieldWithHeading(
                                  textFieldHeading:
                                      tr(LocaleKeys.businessCategory),
                                  child: ThemeTextFormField(
                                    readOnly: true,
                                    controller: categoryController,
                                    textInputAction: TextInputAction.next,
                                    contentPadding: const EdgeInsets.all(10),
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.sentences,
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

                                //Business Address
                                TextFieldWithHeading(
                                  textFieldHeading: tr(LocaleKeys.address),
                                  child: ThemeTextFormField(
                                    controller: businessAddressController,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 3,
                                    maxLines: 6,
                                    contentPadding: const EdgeInsets.all(10),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.0,
                                    ),
                                    hintStyle: const TextStyle(fontSize: 14),
                                    maxLength:
                                        TextFieldInputLength.addressMaxLength,
                                    validator: (text) => TextFieldValidator
                                        .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength.addressMinLength,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                //Business location
                                //Work Location
                                BlocListener<LocationTagControllerCubit,
                                    LocationTagControllerState>(
                                  listener:
                                      (context, locationTagControllerState) {
                                    if (locationTagControllerState
                                            .taggedLocation !=
                                        null) {
                                      setBusinessLocation(
                                          locationTagControllerState
                                              .taggedLocation!);
                                    } else {
                                      cleanBusinessLocation();
                                    }
                                  },
                                  child: TextFieldWithHeading(
                                    textFieldHeading:
                                        tr(LocaleKeys.businessLocation),
                                    child: ThemeTextFormField(
                                      controller: businessLocationController,
                                      readOnly: true,
                                      onTap: () {
                                        GoRouter.of(context)
                                            .pushNamed<
                                                LocationAddressWithLatLng>(
                                          TagLocationScreen.routeName,
                                          extra: businessLocation,
                                        )
                                            .then((location) {
                                          if (location != null) {
                                            context
                                                .read<
                                                    LocationTagControllerCubit>()
                                                .addLocationTag(location);
                                          }
                                        });
                                      },
                                      textInputAction: TextInputAction.next,
                                      prefixIcon: Icon(
                                        Icons.location_on,
                                        color:
                                            ApplicationColours.themeBlueColor,
                                        size: 18,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          context
                                              .read<
                                                  LocationTagControllerCubit>()
                                              .removeLocationTag();
                                        },
                                        icon: const Icon(Icons.cancel),
                                      ),
                                      hint: tr(LocaleKeys.addLocation),
                                      contentPadding: const EdgeInsets.all(10),
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.0,
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      validator: (text) =>
                                          TextFieldValidator.standardValidator(
                                              text),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                //Business Mobile
                                TextFieldWithHeading(
                                  textFieldHeading: tr(LocaleKeys.phoneNumber),
                                  child: ThemeTextFormField(
                                    controller: businessMobileController,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.telephoneNumberLocalSuffix
                                    ],
                                    inputFormatters: [
                                      //the limit set to 11 to handle the mobile number and also
                                      //the landline number as per client requirement
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]')),
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    hint: tr(LocaleKeys.enterPhoneNumber),
                                    style: const TextStyle(fontSize: 14),
                                    hintStyle: const TextStyle(fontSize: 14),
                                    validator: (text) =>
                                        TextFieldValidator.phoneNumberValidator(
                                      text,
                                      maxNumber: 10,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                //Website
                                TextFieldWithHeading(
                                  textFieldHeading: tr(LocaleKeys.website),
                                  showOptional: true,
                                  child: ThemeTextFormField(
                                    controller: websiteLinkController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.url,
                                    style: const TextStyle(fontSize: 14),
                                    hintStyle: const TextStyle(fontSize: 14),
                                    validator: (text) =>
                                        text == null || text.trim().isEmpty
                                            ? null
                                            : TextFieldValidator
                                                .websiteLinkValidator(text),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          //Business hours slot
                          const BusinessHoursSlotWidget(),

                          //Chat enable option
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: BoolEnableOptionWidget(
                              title: LocaleKeys.chat,
                              enable: enableChat,
                              onEnableChanged: (status) {
                                enableChat = status;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    //Business discount details
                    StatefulBuilder(builder: (context, discountState) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            CheckBoxWithText(
                              title: LocaleKeys.haveAnyDiscounts,
                              initialValue: hasDiscount,
                              onChanged: (status) {
                                hasDiscount = status;
                                if (!hasDiscount) {
                                  //clear discount data
                                  _clearDiscountData();
                                }
                                discountState(() {});
                              },
                            ),

                            //Discount options
                            Visibility(
                              visible: hasDiscount,
                              child: Column(
                                children: [
                                  BlocProvider.value(
                                    value: disocuntsInPercentageCubit,
                                    child: BusinessDiscountSlotWidget(
                                      heading: "${tr(LocaleKeys.discount)} (%)",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  BlocProvider.value(
                                    value: disocuntsInPriceCubit,
                                    child: BusinessDiscountSlotWidget(
                                      heading: "${tr(LocaleKeys.discount)} (₹)",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    //Post Radius Preference
                    BlocListener<LocationServiceControllerCubit,
                        LocationServiceControllerState>(
                      listener: (context, locationServiceState) async {
                        if (locationServiceState is LocationFetched) {
                          //emitting location data
                          await locationRenderCubit.emitLocation(
                            locationAddressWithLatLong:
                                locationServiceState.location,
                            locationType: LocationType.marketPlace,
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
                              final marketPlaceLocation =
                                  locationRenderState.marketPlaceLocation;

                              businessPreferencePosition = marketPlaceLocation;

                              LatLng? postFeedCoOrdinates;

                              if (businessPreferencePosition != null) {
                                postFeedCoOrdinates = LatLng(
                                  businessPreferencePosition!.latitude,
                                  businessPreferencePosition!.longitude,
                                );
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 15),
                                child: postFeedCoOrdinates == null
                                    ? const MapAndFeedRadiusWidgetShimmer()
                                    : MapAndFeedRadiusWidget(
                                        disableLocateMe: true,
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
                                            .marketPlaceSearchRadius,
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
                                                      marketPlaceSearchRadius:
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
                    BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                      builder: (context, activeButtonState) {
                        return BlocBuilder<LocationServiceControllerCubit,
                            LocationServiceControllerState>(
                          builder: (context, locationServiceState) {
                            return ThemeElevatedButton(
                              buttonName: tr(
                                isEditMode
                                    ? LocaleKeys.updateBusinessPage
                                    : LocaleKeys.createBusinessPage,
                              ),
                              showLoadingSpinner: manageBusinessState.isLoading,
                              disableButton:
                                  // !activeButtonState.isEnabled ||
                                  locationServiceState == LoadingLocation(),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                //take the instance of the discount in percentage and discount in price
                                final discountInPercentage =
                                    disocuntsInPercentageCubit
                                        .state.businessDiscountOptionList;

                                final discountInPrice = disocuntsInPriceCubit
                                    .state.businessDiscountOptionList;

                                final allDiscountInPercentageOptionEmpty =
                                    discountInPercentage.allEmptyOption;

                                final allDiscountInPriceOptionEmpty =
                                    discountInPrice.allEmptyOption;

                                if (isEditMode &&
                                        (serverMedia.isEmpty &&
                                            pickedMedia.isEmpty) ||
                                    !isEditMode && pickedMedia.isEmpty) {
                                  ThemeToast.errorToast(
                                      "Please select atleast one business image");
                                  await scrollAnimateTo(
                                    scrollController:
                                        manageBusinessScrollController,
                                    offset: 0.0,
                                  );
                                  return;
                                } else if (websiteLinkController.text
                                        .trim()
                                        .isNotEmpty &&
                                    !await canLaunchUrl(
                                      Uri.parse(
                                        websiteLinkController.text.trim(),
                                      ),
                                    )) {
                                  ThemeToast.errorToast(
                                      "Please enter a valid website link");
                                  return;
                                }
                                //Check for the discount in percentage and discount in price
                                else if (hasDiscount &&
                                    (discountInPercentage.partialEmptyOption ||
                                        discountInPrice.partialEmptyOption)) {
                                  ThemeToast.errorToast(
                                      "Please complete the discount options");
                                  return;
                                } else if (hasDiscount &&
                                    allDiscountInPercentageOptionEmpty &&
                                    allDiscountInPriceOptionEmpty) {
                                  ThemeToast.errorToast("Please add discount");
                                  return;
                                } else if (selectedCategoryModel
                                    .isNoSubCategorySelected) {
                                  ThemeToast.errorToast(
                                      "Please select a business category");
                                  return;
                                } else if (businessLocation == null) {
                                  ThemeToast.errorToast(
                                      "Please select a business location");
                                  return;
                                } else if (businessPreferencePosition == null) {
                                  ThemeToast.errorToast(
                                      "Please select a post location");
                                  return;
                                } else if (radiusPreference == null) {
                                  ThemeToast.errorToast(tr(
                                      LocaleKeys.pleaseselectapostfeedradius));
                                  return;
                                } else {
                                  if (formkey.currentState!.validate()) {
                                    //logic to upload post
                                    final manageBusinessModel =
                                        BusinessManageModel(
                                      id: widget.existBusinessData?.id,
                                      category: selectedCategoryModel,
                                      businessAddress:
                                          businessAddressController.text.trim(),
                                      businessLocation: businessLocation!,
                                      websiteLink:
                                          websiteLinkController.text.trim(),
                                      enableChat: enableChat,
                                      discountInPercentage:
                                          discountInPercentage,
                                      discountInPrice: discountInPrice,

                                      hasDiscount: hasDiscount,

                                      businessPreferenceRadius:
                                          radiusPreference!
                                              .marketPlaceSearchRadius,
                                      postLocation: businessPreferencePosition!,
                                      businessHoursModel: businessHoursCubit
                                          .state.businessHoursModel,
                                      phoneNumber:
                                          businessMobileController.text.trim(),
                                      businessName:
                                          businessNameController.text.trim(),
                                      otherBusinessCategory:
                                          otherCategoryController.text.trim(),
                                      //Copy the array to avoid array reference
                                      media: [...serverMedia],
                                    );

                                    context
                                        .read<ManageBusinessCubit>()
                                        .createOrUpdateBusinessDetails(
                                          businessManageModel:
                                              manageBusinessModel,
                                          pickedMediaList: pickedMedia,

                                          //Edit mode
                                          isEdit: isEditMode,
                                        );
                                  }
                                }
                              },
                            );
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
