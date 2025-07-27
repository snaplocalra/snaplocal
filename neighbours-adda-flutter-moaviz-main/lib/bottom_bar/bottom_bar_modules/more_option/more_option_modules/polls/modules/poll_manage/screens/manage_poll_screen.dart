import 'dart:io';

import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_feed_posts/home_feed_posts_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/manage_poll_option/manage_poll_option_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_location_type_selector/poll_location_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_service/poll_service_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_option_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/repository/manage_poll_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/widget/manage_poll_option.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/widgets/poll_location_type_selector_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/widgets/poll_type_selector_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/caption_box.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_privacy_controller_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/screen_header.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_map_radius_preference_widget.dart';
import 'package:snap_local/common/utils/category/v1/logic/category_controller_v1/category_controller_v1_cubit.dart';
import 'package:snap_local/common/utils/category/v1/model/category_type_v1.dart';
import 'package:snap_local/common/utils/category/v1/model/category_v1_selection_strategy.dart';
import 'package:snap_local/common/utils/category/v1/widget/category_selection_bottom_sheet.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/check_box_with_text/widget/check_box_with_text.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class ManagePollScreen extends StatefulWidget {
  final PostDetailsControllerCubit? postDetailsControllerCubit;

  const ManagePollScreen({super.key, this.postDetailsControllerCubit});

  static const routeName = 'manage_poll';

  @override
  State<ManagePollScreen> createState() => _ManagePollScreenState();
}

class _ManagePollScreenState extends State<ManagePollScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool get isEditMode => widget.postDetailsControllerCubit != null;
  PollPostModel? existingPollDetails;

  final managePollScrollController = ScrollController();

  //Poll type selector cubit
  PollTypeSelectorCubit pollTypeSelectorCubit =
      PollTypeSelectorCubit(PollTypeEnum.text);

  //poll location type
  PollLocationTypeSelectorCubit pollLocationTypeSelectorCubit =
      PollLocationTypeSelectorCubit(PollLocationTypeEnum.local);

  //text controllers
  final pollQuestionController = TextEditingController();
  final targetLocationTextController = TextEditingController();
  final pollEndDateTextController = TextEditingController();
  final pollCategoryTextController = TextEditingController();
  final categoryController = TextEditingController();
  final otherCategoryController = TextEditingController();

  LocationAddressWithLatLng? postFeedPosition;

  //Post permission settings
  PostSharePermission postSharePermission = PostSharePermission.allow;
  PostCommentPermission postCommentPermission = PostCommentPermission.enable;
  PostVisibilityControlEnum postVisibilityPermission =
      PostVisibilityControlEnum.public;

  final activeButtonCubit = ActiveButtonCubit();

  List<ManagePollOptionModel> managePollOptions = [];

  //Poll option controller
  final managePollOptionControllerCubit = ManagePollOptionCubit();

  //The default poll end date is the current date
  DateTime? pollEndDate;

  bool hideResultUntilPollEnds = false;

  List<File> pickedMedia = [];

  late PollServiceCubit pollServiceCubit;

  //target location
  LocationAddressWithLatLng? targetLocation;

  FeedRadiusModel? radiusPreference;
  late RadiusSliderRenderCubit radiusSliderCubit;
  late LocationRenderCubit locationRenderCubit;
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  //

  final CategoryControllerV1Cubit categoryControllerV1Cubit =
      CategoryControllerV1Cubit(
          PollCategoryTypeV1(SingleCategorySelectionStrategy()));

  Future<void> setTaggedLocation(LocationAddressWithLatLng location) async {
    targetLocation = location;

    targetLocationTextController.text = targetLocation!.address;
    //emitting location data to show on the map
    await locationRenderCubit.emitLocation(
      locationAddressWithLatLong: targetLocation,
      locationType: LocationType.socialMedia,
    );
  }

  //clear target location
  void clearTaggedLocation() {
    targetLocation = null;
    targetLocationTextController.clear();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  Future<void> _renderLocationAndFeedRadius({
    required FeedRadiusModel feedRadiusModel,
    required LocationAddressWithLatLng locationModel,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //emitting feedRadius data
      await radiusSliderCubit.emitRadius(feedRadiusModel);

      //emitting location data
      setTaggedLocation(locationModel);
    });
  }

  ///This method will use to prefill the data in the edit mode
  Future<void> prefillData({required FeedRadiusModel feedRadiusModel}) async {
    existingPollDetails = widget
        .postDetailsControllerCubit!.state.socialPostModel as PollPostModel;

    //poll type
    pollTypeSelectorCubit.switchType(existingPollDetails!.pollsModel.pollType);

    //poll location type (local, global)
    pollLocationTypeSelectorCubit.switchType(
      existingPollDetails!.pollsModel.isGlobalLocation
          ? PollLocationTypeEnum.global
          : PollLocationTypeEnum.local,
    );

    //poll question
    pollQuestionController.text = existingPollDetails!.pollsModel.pollQuestion;

    //Post settings
    postSharePermission = existingPollDetails!.postSharePermission;
    postVisibilityPermission = existingPollDetails!.postVisibilityPermission;
    postCommentPermission = existingPollDetails!.postCommentPermission;

    //Assigning the existing polls option
    final existingPollOptions =
        existingPollDetails!.pollsModel.pollOptionDetails.options
            .map((e) => ManagePollOptionModel(
                  optionId: e.optionId,
                  optionName: e.optionName,
                  optionImage: e.optionImage,
                ))
            .toList();

    //Assigning data in manage poll list controller
    managePollOptionControllerCubit.addInitialData(existingPollOptions);

    //Poll end date
    pollEndDate = existingPollDetails!.pollsModel.pollEndDate;
    pollEndDateTextController.text =
        FormatDate.selectedDateDDMMYYYY(pollEndDate!);

    //Poll result secret status
    hideResultUntilPollEnds =
        existingPollDetails!.pollsModel.hideResultUntilPollEnds;

    //set job category
    await categoryControllerV1Cubit.fetchCategories(
      dataPreSelect: true,
      categoryId: existingPollDetails!.pollsModel.categoryId,
    );

    //Other category
    if (existingPollDetails!.pollsModel.otherCategoryName != null) {
      otherCategoryController.text =
          existingPollDetails!.pollsModel.otherCategoryName!;
    }

    _renderLocationAndFeedRadius(
      feedRadiusModel: feedRadiusModel.copyWith(
        socialMediaSearchRadius:
            existingPollDetails!.postPreferenceRadius.toDouble(),
      ),
      locationModel: existingPollDetails!.postLocation,
    );

    postButtonValidator();
  }

  @override
  void initState() {
    super.initState();
    pollServiceCubit = PollServiceCubit(
      managePollRepository: ManagePollRepository(),
      mediaUploadRepository: context.read<MediaUploadRepository>(),
    );

    locationRenderCubit = LocationRenderCubit();
    radiusSliderCubit = RadiusSliderRenderCubit();

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
        categoryControllerV1Cubit.fetchCategories();

        //Here by default 2 option must visible
        final List<ManagePollOptionModel> initialData = [
          ManagePollOptionModel(optionId: "0", optionName: ""),
          ManagePollOptionModel(optionId: "0", optionName: ""),
        ];
        //Assigning data in manage poll list controller
        managePollOptionControllerCubit.addInitialData(initialData);
        //Initial poll end date
        // pollEndDateTextController.text =
        //     FormatDate.selectedDateDDMMYYYY(pollEndDate);
        if (locationModel != null) {
          _renderLocationAndFeedRadius(
            feedRadiusModel: feedRadiusModel.copyWith(
              socialMediaSearchRadius:
                  //70% of feedRadiusModel.maxPollVisibilityRadius
                  feedRadiusModel.maxPollVisibilityRadius * 0.7,
            ),
            locationModel: locationModel,
          );
        }
      }
    } else {
      throw ("Profile data not available");
    }
  }

  //Enable or disable the post button
  void postButtonValidator() {
    if (isEditMode && pollQuestionController.text.trim().isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else if (!isEditMode && managePollOptions.isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else {
      activeButtonCubit.changeStatus(true);
    }
  }

  Future<void> pickPollEndDate() async {
    await showDatePicker(
      context: context,
      helpText: "Select poll end date",
      locale: Locale(
        EasyLocalization.of(context)!.locale.languageCode,
        "IN",
      ),
      initialDate: pollEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((selectedDate) {
      if (selectedDate != null) {
        pollEndDate = selectedDate;
        pollEndDateTextController.text =
            FormatDate.selectedDateDDMMYYYY(pollEndDate!);
      }
    });
  }

  void selectCategory() {
    final selectedCategory = categoryControllerV1Cubit.selectedFirstData;

    if (selectedCategory != null) {
      pollCategoryTextController.text = selectedCategory.name;
    }
  }

  @override
  void dispose() {
    pollQuestionController.dispose();
    managePollScrollController.dispose();
    pollEndDateTextController.dispose();
    targetLocationTextController.dispose();
    pollCategoryTextController.dispose();
    categoryController.dispose();
    otherCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: pollServiceCubit),
        BlocProvider.value(value: managePollOptionControllerCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: pollTypeSelectorCubit),
        BlocProvider.value(value: pollLocationTypeSelectorCubit),
        BlocProvider.value(value: categoryControllerV1Cubit),
        BlocProvider(
          create: (context) => LocationTagControllerCubit(
            taggedLocation: targetLocation,
          ),
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
        BlocProvider(create: (context) => MediaPickCubit()),
      ],
      child: BlocConsumer<PollServiceCubit, PollServiceState>(
        listener: (context, managePollState) {
          if (managePollState.isManagePollRequestSuccess) {
            if (mounted && GoRouter.of(context).canPop()) {
              //Pop with true to run the data refresh list api
              GoRouter.of(context).pop(true);
              return;
            }
          }
        },
        builder: (context, managePollState) {
          return PopScope(
            canPop: willPopScope(!managePollState.isRequestLoading),
            child: Scaffold(
              appBar: CreatePostAppBar(
                willPop: () {
                  GoRouter.of(context).pop();
                },
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
                  ),
                ],
              ),
              body: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                controller: managePollScrollController,
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formkey,
                      child: Column(
                        children: [
                          //Screen header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ScreenHeader(
                              title: isEditMode
                                  ? tr(LocaleKeys.updatePoll)
                                  : tr(LocaleKeys.createPoll),
                            ),
                          ),

                          //poll type selector
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Visibility(
                              visible: !isEditMode,
                              child: const PollTypeSelectorWidget(),
                            ),
                          ),

                          //Caption box
                          CaptionBoxWidget(
                            enabled: !isEditMode,
                            allowTagLocation: false,
                            allowMediaPick: false,
                            maxLines: 10,
                            minLines: 5,
                            captionTextController: pollQuestionController,
                            hintText: tr(LocaleKeys.askPollQuestion),
                            onChanged: () {
                              postButtonValidator();
                            },
                            onPostCommentPermissionSelection:
                                (PostCommentPermission postCommentPermission) {
                              this.postCommentPermission =
                                  postCommentPermission;
                            },
                            onPostSharePermissionSelection:
                                (PostSharePermission postSharePermission) {
                              this.postSharePermission = postSharePermission;
                            },
                            maxLength:
                                TextFieldInputLength.pollDescriptionMaxLength,
                            validator: (value) => TextFieldValidator
                                .standardValidatorWithMinLength(
                              value,
                              TextFieldInputLength.pollDescriptionMinLength,
                              isOptional: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Poll options module
                          ManagePollOptionWidget(
                            enableOption: !isEditMode,
                            onListModelUpdated: (updatedListModel) {
                              managePollOptions = updatedListModel.data;
                            },
                          ),
                          const SizedBox(height: 15),
                          //Poll end date
                          Align(
                            alignment: Alignment.centerLeft,
                            child: WidgetHeading(
                              title: tr(LocaleKeys.pollEndDate),
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return pollEndDate == null
                                  ? GestureDetector(
                                      onTap: () async {
                                        await pickPollEndDate().whenComplete(
                                            () => setState(() {}));
                                      },
                                      child: const SelectPollEndDatesWidget(),
                                    )
                                  : Column(
                                      children: [
                                        ThemeTextFormField(
                                          readOnly: true,
                                          controller: pollEndDateTextController,
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontSize: 14),
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          onTap: () async {
                                            await pickPollEndDate();
                                          },
                                          suffixIcon: const Icon(
                                            Icons.calendar_month_rounded,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          validator: (text) =>
                                              TextFieldValidator
                                                  .standardValidator(text),
                                        ),
                                        //Poll result secret status
                                        CheckBoxWithText(
                                          title: LocaleKeys
                                              .keepResultSecretUntilPollEnd,
                                          initialValue: hideResultUntilPollEnds,
                                          onChanged: (status) {
                                            hideResultUntilPollEnds = status;
                                          },
                                        ),
                                      ],
                                    );
                            },
                          ),

                          const SizedBox(height: 10),

                          //Category
                          Align(
                            alignment: Alignment.centerLeft,
                            child: WidgetHeading(
                              title: tr(LocaleKeys.category),
                            ),
                          ),
                          const SizedBox(height: 5),

                          //Select Poll category
                          BlocConsumer<CategoryControllerV1Cubit,
                              CategoryControllerV1State>(
                            listener: (context, categoryControllerV1State) {
                              if (categoryControllerV1State.assignCategory) {
                                selectCategory();
                              }
                            },
                            builder: (context, categoryControllerV1State) {
                              return Column(
                                children: [
                                  //Dropdown
                                  ThemeTextFormField(
                                    controller: pollCategoryTextController,
                                    readOnly: true,
                                    enabled: !isEditMode,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: const TextStyle(fontSize: 14),
                                    hint: tr(LocaleKeys.selectCategory),
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(104, 107, 116, 0.6),
                                      fontSize: 14,
                                    ),
                                    //dropdown icon
                                    suffixIcon: isEditMode
                                        ? null
                                        : Icon(
                                            Icons.arrow_drop_down,
                                            color: ApplicationColours
                                                .themeBlueColor,
                                            size: 20,
                                          ),
                                    onTap: isEditMode
                                        ? null
                                        : () {
                                            //Reset search before opening the bottom sheet
                                            categoryControllerV1Cubit
                                                .resetSearch();

                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(25),
                                                ),
                                              ),
                                              builder: (_) {
                                                return BlocProvider.value(
                                                  value: context.read<
                                                      CategoryControllerV1Cubit>(),
                                                  child:
                                                      const CategorySelectionBottomSheet(),
                                                );
                                              },
                                            );
                                          },
                                  ),

                                  //Other category
                                  AnimatedHideWidget(
                                    visible: categoryControllerV1Cubit
                                            .selectedFirstData
                                            ?.isOtherCategory ??
                                        false,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ThemeTextFormField(
                                        enabled: !isEditMode,
                                        controller: otherCategoryController,
                                        textInputAction: TextInputAction.next,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        hint: "Enter other category",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.0,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color:
                                              ApplicationColours.themeBlueColor,
                                        ),
                                        validator: (text) => TextFieldValidator
                                            .standardValidator(text),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // post location type
                  const PollLocationTypeSelectorWidget(),

                  //Post Radius Preference
                  BlocBuilder<PollLocationTypeSelectorCubit,
                      PollLocationTypeSelectorState>(
                    builder: (context, pollLocationTypeSelectorState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            //target location
                            //Item location
                            BlocListener<LocationTagControllerCubit,
                                LocationTagControllerState>(
                              listener: (context, locationTagControllerState) {
                                final selectedTaggedLocation =
                                    locationTagControllerState.taggedLocation;
                                if (selectedTaggedLocation != null) {
                                  setTaggedLocation(selectedTaggedLocation);
                                } else {
                                  clearTaggedLocation();
                                }
                              },
                              child: Visibility(
                                visible: pollLocationTypeSelectorState
                                        .selectedLocationType ==
                                    PollLocationTypeEnum.local,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      WidgetHeading(
                                        title: tr(LocaleKeys.targetLocation),
                                      ),
                                      const SizedBox(height: 2),
                                      ThemeTextFormField(
                                        controller:
                                            targetLocationTextController,
                                        readOnly: true,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        hint: tr(LocaleKeys.addLocation),
                                        hintStyle: const TextStyle(
                                          color: Color.fromRGBO(
                                              104, 107, 116, 0.6),
                                          fontSize: 14,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on_sharp,
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          size: 18,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<
                                                    LocationTagControllerCubit>()
                                                .removeLocationTag();
                                          },
                                          child: const Icon(Icons.cancel,
                                              size: 18),
                                        ),
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          GoRouter.of(context)
                                              .pushNamed<
                                                  LocationAddressWithLatLng>(
                                            TagLocationScreen.routeName,
                                            extra: targetLocation,
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
                            ),

                            //map with radius preference
                            PostMapRadiusPreferenceWidget(
                              visible: pollLocationTypeSelectorState
                                      .selectedLocationType ==
                                  PollLocationTypeEnum.local,
                              postType: PostType.poll,
                              disableLocateMe: true,
                              locationType: LocationType.socialMedia,
                              onLocationRender:
                                  (postFeedPosition, radiusPreference) {
                                this.radiusPreference = radiusPreference;
                                this.postFeedPosition = postFeedPosition;
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  //Post Button
                  BlocBuilder<LocationServiceControllerCubit,
                      LocationServiceControllerState>(
                    builder: (context, locationServiceState) {
                      return //Post Button
                          BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                        builder: (context, activeButtonState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ThemeElevatedButton(
                              buttonName: tr(
                                isEditMode
                                    ? LocaleKeys.update
                                    : LocaleKeys.publish,
                              ),
                              showLoadingSpinner:
                                  managePollState.isRequestLoading,
                              disableButton:
                                  locationServiceState == LoadingLocation() ||
                                      !activeButtonState.isEnabled,
                              onPressed: () {
                                final isGlobalLocation = context
                                        .read<PollLocationTypeSelectorCubit>()
                                        .state
                                        .selectedLocationType ==
                                    PollLocationTypeEnum.global;

                                if (formkey.currentState!.validate()) {
                                  final optionListModel = ManagePollOptionList(
                                      data: managePollOptions);

                                  FocusScope.of(context).unfocus();
                                  if (managePollOptions.isEmpty) {
                                    ThemeToast.errorToast(
                                        "Please add at least one option");

                                    return;
                                  } else if (optionListModel
                                      .minimumOptionEmpty) {
                                    ThemeToast.errorToast(
                                        "You must enter data for at least two options.");

                                    return;
                                  } else if (optionListModel
                                      .emptyOptionAvailable) {
                                    ThemeToast.errorToast(
                                        "Please remove the empty option");
                                    return;
                                  } else if (!isEditMode &&
                                      pollTypeSelectorCubit
                                              .state.selectedType ==
                                          PollTypeEnum.photo &&
                                      optionListModel.isEmptyImageAvailable) {
                                    ThemeToast.errorToast(
                                        "Please upload the image for all options");
                                    return;
                                  } else if (pollEndDate == null) {
                                    ThemeToast.errorToast(
                                        "Please select the poll end date");
                                    return;
                                  } else if (!categoryControllerV1Cubit
                                      .state.isAnyCategorySelected) {
                                    ThemeToast.errorToast(
                                        "Please select a category");
                                    return;
                                  } else if (postFeedPosition == null) {
                                    ThemeToast.errorToast(
                                        tr(LocaleKeys.pleaseselectalocation));
                                    return;
                                  } else if (!isGlobalLocation &&
                                      targetLocation == null) {
                                    ThemeToast.errorToast(
                                        "Please select a target location");
                                    return;
                                  } else if (!isGlobalLocation &&
                                      radiusPreference == null) {
                                    ThemeToast.errorToast(tr(LocaleKeys
                                        .pleaseselectapostfeedradius));
                                    return;
                                  } else {
                                    //logic to upload post
                                    final managePollModel = ManagePollModel(
                                      id: existingPollDetails?.id,
                                      pollEndDate: pollEndDate,
                                      pollQuestion:
                                          pollQuestionController.text.trim(),
                                      pollPreferenceRadius: radiusPreference!
                                          .socialMediaSearchRadius
                                          .toInt(),
                                      hideResultUntilPollEnds:
                                          hideResultUntilPollEnds,
                                      sharePermission: postSharePermission,
                                      commentPermission: postCommentPermission,
                                      visibilityPermission:
                                          postVisibilityPermission,
                                      postLocation: postFeedPosition!,
                                      managePollOptionList: optionListModel,
                                      pollTypeEnum: context
                                          .read<PollTypeSelectorCubit>()
                                          .state
                                          .selectedType,
                                      isGlobalLocation: isGlobalLocation,
                                      categoryId: categoryControllerV1Cubit
                                          .state
                                          .categoriesListModel
                                          .selectedFirstData!
                                          .id,
                                      otherCategoryName:
                                          otherCategoryController.text.trim(),
                                      targetLocation: targetLocation,
                                    );

                                    //Manage poll controller
                                    context
                                        .read<PollServiceCubit>()
                                        .managePoll(
                                          managePollModel: managePollModel,
                                          isEdit: isEditMode,
                                        )
                                        .whenComplete(() {
                                      context
                                          .read<HomeSocialPostsCubit>()
                                          .fetchHomeSocialPosts();
                                    });
                                  }
                                }
                              },
                            ),
                          );
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

class SelectPollEndDatesWidget extends StatelessWidget {
  const SelectPollEndDatesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_month,
            size: 20,
            color: Color.fromRGBO(
              184,
              184,
              184,
              1,
            ),
          ),
          const SizedBox(width: 2),
          Text(tr(LocaleKeys.selectDates))
        ],
      ),
    );
  }
}
