// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/logic/manage_sales_post/manage_sales_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/logic/sell_type_selector/sell_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/item_condition_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sales_post_manage_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sell_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/repository/manage_sales_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/widget/item_condition_selector.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/widget/sell_type_selector_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sales_post_detail_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/caption_box.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_privacy_controller_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/screen_header.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_map_radius_preference_widget.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/category/v2/model/category_type.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_preselection_strategy.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/logic/dynamic_field_controller/dynamic_field_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_post_from.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/repository/dynamic_category_field_repository.dart';
import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';
import 'package:snap_local/common/utils/category/widgets/category_selection_bottom_sheet_v2.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/multi_media_selection_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/check_box_with_text/widget/check_box_with_text.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ManageSalesPostScreen extends StatefulWidget {
  final SalesPostDetailModel? existSalesPostDetailModel;

  const ManageSalesPostScreen({super.key, this.existSalesPostDetailModel});

  static const routeName = 'manage_sales_post';

  @override
  State<ManageSalesPostScreen> createState() => _ManageSalesPostScreenState();
}

class _ManageSalesPostScreenState extends State<ManageSalesPostScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isEditMode = false;

  final manageSalesPostScrollController = ScrollController();
  final activeButtonCubit = ActiveButtonCubit();
  final itemLocationTextController = TextEditingController();

  //data models
  final itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final categoryController = TextEditingController();
  //Sell type
  SellType sellType = SellType.sell;

  //Condition type
  ItemCondition itemCondition = ItemCondition.brandNew;

  //Post permission settings
  PostVisibilityControlEnum postVisibilityPermission =
      PostVisibilityControlEnum.public;

  //Hide exact location
  bool hideExactLocation = false;

  List<NetworkMediaModel> serverMedia = [];

  late ManageSalesRepository manageSalesRepository = ManageSalesRepository();

  late ManageSalesPostCubit manageSalesPostCubit = ManageSalesPostCubit(
    mediaUploadRepository: context.read<MediaUploadRepository>(),
    manageSalesRepository: manageSalesRepository,
  );

  late SellTypeSelectorCubit sellTypeSelectorCubit =
      SellTypeSelectorCubit(sellType);

  //Common
  List<MediaFileModel> pickedMedia = [];
  LocationAddressWithLatLng? salesPostPreferencePosition;
  LocationAddressWithLatLng? taggedLocation;
  FeedRadiusModel? radiusPreference;
  late MediaPickCubit mediaPickCubit = MediaPickCubit();
  late RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  late LocationRenderCubit locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());
  //
  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          BuyAndSellCategory(SingleSubCategorySelectionStrategy()));

  //Selected category
  CategoryModelV2? selectedCategoryModel;

  DynamicCategoryFieldControllerCubit dynamicCategoryFieldControllerCubit =
      DynamicCategoryFieldControllerCubit(DynamicCategoryFieldRepository());

  //Set buy&sell category
  void setCategory(
    CategoryModelV2 categoryV2Model, {
    List<DynamicCategoryDataModel>? dynamicFields,
  }) {
    //assign the selected category to the selectedCategoryModel
    selectedCategoryModel = categoryV2Model;

    //add the selected sub categories in the category text controller
    categoryController.text =
        selectedCategoryModel!.selectedSubCategoryString();

    //fetch dynamic fields based on the selected category
    dynamicCategoryFieldControllerCubit.fetchDynamicField(
      categoryId: selectedCategoryModel!.id,
      dynamicCategoryPostFrom: DynamicCategoryPostFrom.buySell,
      preSelectedData: dynamicFields,
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

      //emitting location data
      await locationRenderCubit.emitLocation(
        locationAddressWithLatLong: locationModel,
        locationType: LocationType.marketPlace,
      );
    });
  }

  Future<void> setTaggedLocation(
      {LocationAddressWithLatLng? selectedTaggedLocation}) async {
    taggedLocation = selectedTaggedLocation;
    if (taggedLocation != null) {
      itemLocationTextController.text = taggedLocation!.address;
      //emitting location data to show on the map
      await locationRenderCubit.emitLocation(
        locationAddressWithLatLong: taggedLocation,
        locationType: LocationType.marketPlace,
      );
    } else {
      itemLocationTextController.clear();
    }
  }

  ///This method will use to prefill the data in the edit mode
  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    final existingSalesPostDetails = widget.existSalesPostDetailModel!;

    //server media
    serverMedia = existingSalesPostDetails.media;

    //Post settings
    postVisibilityPermission =
        existingSalesPostDetails.postVisibilityPermission;

    //Item Name
    itemNameController.text = existingSalesPostDetails.name;

    //Set sell type
    sellType = existingSalesPostDetails.saleType;

    if (existingSalesPostDetails.price != null) {
      //Sale item price
      itemPriceController.text =
          existingSalesPostDetails.price!.amount.toString();
    }

    /*//Fetch sales categories and select by id
    salesCategoryCubit.fetchSalesCategories(
        salesCategoryId: existingSalesPostDetails.category);*/

    //Select Item condition
    itemCondition = existingSalesPostDetails.itemCondition;

    setTaggedLocation(
        selectedTaggedLocation: existingSalesPostDetails.taggedlocation);

    //Sale post description
    itemDescriptionController.text = existingSalesPostDetails.description;

    //Hide exact location
    hideExactLocation = existingSalesPostDetails.hideExactLocation;

    //emitting radius data
    radiusSliderCubit.emitRadius(feedRadiusModel.copyWith(
      marketPlaceSearchRadius: existingSalesPostDetails.salePreferenceRadius,
    ));

    //set the category
    categoryControllerCubit.fetchCategories(
      preselectionStrategy: CategoryV2PreselectionFromCategoryModelV3(
        existingSalesPostDetails.category,
      ),
    );

    //listen to the category controller
    categoryControllerCubit.stream.listen((state) {
      if (state is CategoryControllerDataLoaded) {
        // from the categoryModel list, pick the first category where any of the sub category is selected
        final selectedCategoryModel = state.categories.data.firstWhereOrNull(
          (element) => element.subCategories
              .any((subCategory) => subCategory.isSelected),
        );
        if (selectedCategoryModel != null) {
          setCategory(
            selectedCategoryModel,
            dynamicFields: existingSalesPostDetails.category.dynamicFields,
          );
        }
      }
    });
  }

  void setItemPriceToZero() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      itemPriceController.clear();
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
          profileSettingState.profileSettingsModel!.marketPlaceLocation;

      //Edit mode
      if (widget.existSalesPostDetailModel != null) {
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
      }
    } else {
      throw ("Profile data not available");
    }
  }

  @override
  void dispose() {
    super.dispose();
    manageSalesPostScrollController.dispose();
    itemNameController.dispose();
    itemPriceController.dispose();
    itemDescriptionController.dispose();
    itemLocationTextController.dispose();
  }

  void willPopScope(bool allowPop) {
    if (allowPop) {
      GoRouter.of(context).pop();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: manageSalesPostCubit),
        BlocProvider.value(value: sellTypeSelectorCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider.value(value: categoryControllerCubit),
        BlocProvider.value(value: dynamicCategoryFieldControllerCubit),
        BlocProvider(
          create: (context) =>
              LocationTagControllerCubit(taggedLocation: taggedLocation),
        ),
        BlocProvider(
          create: (context) =>
              PostVisibilityControlCubit(postVisibilityPermission),
        ),
      ],
      child: BlocConsumer<ManageSalesPostCubit, ManageSalesPostState>(
        listener: (context, manageSalesPostState) {
          if (manageSalesPostState.isRequestSuccess) {
            if (mounted) {
              try {
                //Pop with true to run the data refresh api
                GoRouter.of(context).pop(true);
                return;
              } catch (e) {
                // Record the error in Firebase Crashlytics
                FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
                return;
              }
            }
          }
        },
        builder: (context, manageBusinessState) {
          // final mqSize = MediaQuery.sizeOf(context);
          return PopScope(
            canPop: !manageBusinessState.isLoading,
            child: Scaffold(
              appBar: CreatePostAppBar(
                willPop: () async =>
                    willPopScope(!manageBusinessState.isLoading),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: PostVisibilityControlWidget(
                      onPostVisibilitySelection:
                          (PostVisibilityControlEnum postVisibilityPermission) {
                        this.postVisibilityPermission =
                            postVisibilityPermission;
                      },
                    ),
                  )
                ],
              ),
              body: Form(
                key: formkey,
                child: ListView(
                  controller: manageSalesPostScrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScreenHeader(title: tr(LocaleKeys.buyAndsell)),
                    ),
                    //Post details
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Item name
                          ThemeTextFormField(
                            controller: itemNameController,
                            textInputAction: TextInputAction.next,
                            inputFormatters: const [],
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(fontSize: 14),
                            hint: tr(LocaleKeys.itemName),
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLength: TextFieldInputLength.itemNameMaxLength,
                            validator: (text) => TextFieldValidator
                                .standardValidatorWithMinLength(
                              text,
                              TextFieldInputLength.itemNameMinLength,
                            ),
                          ),

                          const SizedBox(height: 10),
                          //Item sales type selection
                          BlocBuilder<SellTypeSelectorCubit,
                              SellTypeSelectorState>(
                            builder: (context, sellTypeSelectorState) {
                              if (sellTypeSelectorState.sellType ==
                                  SellType.free) {
                                setItemPriceToZero();
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Buy Or Sell selection widget
                                  SellTypeSelector(
                                    preSelectedType: sellType,
                                    onSelection: (sellType) {
                                      this.sellType = sellType;
                                    },
                                  ),
                                  if (sellTypeSelectorState.sellType ==
                                      SellType.sell)
                                    //Item price
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: [
                                          WidgetHeading(
                                            title:
                                                "${tr(LocaleKeys.price)} (₹)",
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: ThemeTextFormField(
                                              controller: itemPriceController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              hint: tr(LocaleKeys.enterAmount),
                                              hintStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'^\d+\.?\d*')),
                                              ],
                                              maxLines: 1,
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                height: 1.0,
                                              ),
                                              // validator: (text) =>
                                              //     TextFieldValidator
                                              //         .standardValidator(text),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          //Select Sales post category
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.category),
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
                                      closeBottomSheetOnCategorySelected: true,
                                      categoryControllerCubit:
                                          categoryControllerCubit,
                                      onCategorySelected: (categoryModel) {
                                        // from the categoryModel list, pick the first category where any of the sub category is selected
                                        final selectedCategoryModel =
                                            categoryModel.data.firstWhereOrNull(
                                          (element) => element.subCategories
                                              .any((subCategory) =>
                                                  subCategory.isSelected),
                                        );
                                        if (selectedCategoryModel != null) {
                                          setCategory(selectedCategoryModel);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          //Dynamic fields
                          BlocBuilder<DynamicCategoryFieldControllerCubit,
                              DynamicCategoryFieldControllerState>(
                            builder:
                                (context, dynamicCategoryFieldControllerState) {
                              if (dynamicCategoryFieldControllerState
                                  is DynamicCategoryFieldControllerError) {
                                return ErrorTextWidget(
                                  error:
                                      dynamicCategoryFieldControllerState.error,
                                );
                              } else if (dynamicCategoryFieldControllerState
                                  is DynamicCategoryFieldControllerLoading) {
                                return const ThemeSpinner(size: 40);
                              } else if (dynamicCategoryFieldControllerState
                                  is DynamicCategoryFieldControllerLoaded) {
                                final logs = dynamicCategoryFieldControllerState
                                    .dynamicFields;
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Visibility(
                                    visible: logs.isNotEmpty,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          width: 0.4,
                                        ),
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: logs.length,
                                        itemBuilder: (context, index) {
                                          final dynamicField = logs[index];
                                          return Padding(
                                            key: ValueKey(index),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: dynamicField.build(context),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),

                          const SizedBox(height: 10),
                          //Item condition selection
                          WidgetHeading(title: tr(LocaleKeys.condition)),
                          ItemConditionSelector(
                            preSelectedItemCondition: itemCondition,
                            onChanged: (value) {
                              itemCondition = value;
                            },
                          ),
                          const SizedBox(height: 10),

                          //Item location
                          BlocListener<LocationTagControllerCubit,
                              LocationTagControllerState>(
                            listener: (context, locationTagControllerState) {
                              setTaggedLocation(
                                selectedTaggedLocation:
                                    locationTagControllerState.taggedLocation,
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetHeading(
                                    title: tr(LocaleKeys.itemLocation)),
                                const SizedBox(height: 2),
                                ThemeTextFormField(
                                  controller: itemLocationTextController,
                                  readOnly: true,
                                  textCapitalization:
                                      TextCapitalization.sentences,
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
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
                                ),
                              ],
                            ),
                          ),

                          //Hide Exact location
                          CheckBoxWithText(
                            activeColor: ApplicationColours.themeBlueColor,
                            initialValue: hideExactLocation,
                            title: tr(LocaleKeys.hideExactLocation),
                            onChanged: (value) {
                              hideExactLocation = value;
                            },
                          ),

                          //Item Descripton
                          CaptionBoxWidget(
                            allowMediaPick: !isEditMode,
                            margin: const EdgeInsets.only(top: 5, bottom: 15),
                            captionTextController: itemDescriptionController,
                            hintText: tr(LocaleKeys.description),
                            allowTagLocation: false,
                            maxLength:
                                TextFieldInputLength.descriptionMaxLength,
                            validator: (value) => TextFieldValidator
                                .standardValidatorWithMinLength(
                              value,
                              TextFieldInputLength.descriptionMinLength,
                              isOptional: true,
                            ),
                            gallaryFileType: FileType.media,
                          ),

                          //Upload posts pics
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: MultiMediaSelectionWidget(
                              serverMedia: serverMedia,
                              fileType: FileType.media,
                              onServerMediaUpdated: (serverMediaList) {
                                serverMedia = serverMediaList;
                              },
                              onMediaSelected: (selectedMediaList) {
                                pickedMedia = selectedMediaList;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Post Radius Preference
                    PostMapRadiusPreferenceWidget(
                      disableLocateMe: true,
                      locationType: LocationType.marketPlace,
                      onLocationRender:
                          (salesPostPreferencePosition, radiusPreference) {
                        this.radiusPreference = radiusPreference;
                        this.salesPostPreferencePosition =
                            salesPostPreferencePosition;
                      },
                    ),

                    //Post Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                        builder: (context, activeButtonState) {
                          return BlocBuilder<LocationServiceControllerCubit,
                              LocationServiceControllerState>(
                            builder: (context, locationServiceState) {
                              return ThemeElevatedButton(
                                textFontSize: 14,
                                buttonName: tr(
                                  isEditMode
                                      ? LocaleKeys.update
                                      : LocaleKeys.post,
                                ),
                                showLoadingSpinner:
                                    manageBusinessState.isLoading,
                                disableButton:
                                    locationServiceState == LoadingLocation(),
                                onPressed: () async {
                                  try {
                                    FocusScope.of(context).unfocus();

                                    if (isEditMode &&
                                            (serverMedia.isEmpty &&
                                                pickedMedia.isEmpty) ||
                                        !isEditMode && pickedMedia.isEmpty) {
                                      ThemeToast.errorToast(tr(LocaleKeys
                                          .pleaseselectatleastoneimage));
                                      await scrollToEnd(
                                        manageSalesPostScrollController,
                                      );
                                      return;
                                    } else if (sellType == SellType.sell &&
                                        itemPriceController.text
                                            .trim()
                                            .isEmpty) {
                                      scrollAnimateTo(
                                        scrollController:
                                            manageSalesPostScrollController,
                                        offset: 0,
                                      );
                                      ThemeToast.errorToast(
                                          tr(LocaleKeys.pleasesetaprice));
                                    } else if (selectedCategoryModel == null) {
                                      ThemeToast.errorToast(tr(
                                          LocaleKeys.pleaseselectthecategory));
                                    }

                                    // itemDescriptionController
                                    else if (itemDescriptionController.text
                                        .trim()
                                        .isEmpty) {
                                      scrollAnimateTo(
                                        scrollController:
                                            manageSalesPostScrollController,
                                        offset: 250,
                                      );
                                      ThemeToast.errorToast(
                                          tr(LocaleKeys.pleaseadddescription));
                                      return;
                                    } else if (taggedLocation == null) {
                                      ThemeToast.errorToast(tr(
                                          LocaleKeys.pleaseselectitemlocation));
                                      return;
                                    } else if (salesPostPreferencePosition ==
                                        null) {
                                      ThemeToast.errorToast(
                                          tr(LocaleKeys.pleaseselectalocation));
                                      return;
                                    } else if (radiusPreference == null) {
                                      ThemeToast.errorToast(tr(LocaleKeys
                                          .pleaseselectapostfeedradius));
                                      return;
                                    } else if (!context
                                        .read<
                                            DynamicCategoryFieldControllerCubit>()
                                        .validateDynamicFieldsData()) {
                                      scrollAnimateTo(
                                        scrollController:
                                            manageSalesPostScrollController,
                                        offset: 150,
                                      );
                                    } else {
                                      if (formkey.currentState!.validate()) {
                                        //logic to upload post
                                        final salesPostManageModel =
                                            SalesPostManageModel(
                                          id: widget
                                              .existSalesPostDetailModel?.id,

                                          category: CategoryModelV3(
                                            id: selectedCategoryModel!.id,
                                            name: selectedCategoryModel!.name,
                                            subCategory: selectedCategoryModel!
                                                .selectedSubCategory!,
                                            dynamicFields: context
                                                .read<
                                                    DynamicCategoryFieldControllerCubit>()
                                                .getDynamicFieldsData(),
                                          ),
                                          salesPreferenceRadius:
                                              radiusPreference!
                                                  .marketPlaceSearchRadius,
                                          postLocation:
                                              salesPostPreferencePosition!,
                                          taggedLocation: taggedLocation!,
                                          visibilityPermission:
                                              postVisibilityPermission,
                                          itemName:
                                              itemNameController.text.trim(),
                                          itemPrice:
                                              itemPriceController.text.trim(),
                                          itemCondition: itemCondition,
                                          sellType: sellType,
                                          itemDescription:
                                              itemDescriptionController.text
                                                  .trim(),
                                          hideExactLocation: hideExactLocation,
                                          //Copy the array to avoid array reference
                                          media: [...serverMedia],
                                        );

                                        context
                                            .read<ManageSalesPostCubit>()
                                            .createOrUpdateSalesPost(
                                              salesPostManageModel:
                                                  salesPostManageModel,
                                              pickedMediaList: pickedMedia,

                                              //Edit mode
                                              isEdit: isEditMode,
                                            );
                                      }
                                    }
                                  } catch (e) {
                                    // Record the error in Firebase Crashlytics
                                    FirebaseCrashlytics.instance
                                        .recordError(e, StackTrace.current);
                                    ThemeToast.errorToast(
                                        tr(LocaleKeys.unableToContinue));
                                  }
                                },
                              );
                            },
                          );
                        },
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
