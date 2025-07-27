import 'package:collection/collection.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/logic/event_category/event_category_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/logic/manage_event/manage_event_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/model/manage_event_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/repository/manage_event_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/logic/event_list/event_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/caption_box.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/discard_post_dialog.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_pick_media_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_privacy_controller_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/visibility_controller/visibility_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/screen_header.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_map_radius_preference_widget.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/location/logic/location_render/location_render_cubit.dart';
import 'package:snap_local/common/utils/location/logic/radius_slider_render/radius_slider_render_cubit.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/time_of_day_extension.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/pick_time/pick_time.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class CreateEventScreen extends StatefulWidget {
  final PostDetailsControllerCubit? postDetailsControllerCubit;
  const CreateEventScreen({super.key, this.postDetailsControllerCubit});

  static const routeName = 'create_event';

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool get isEdit => widget.postDetailsControllerCubit != null;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //ScrollController
  final ScrollController _scrollController = ScrollController();

  EventPostModel? existingEventDetails;
  LocationAddressWithLatLng? postFeedPosition;
  LocationAddressWithLatLng? taggedLocation;

  final titleTextController = TextEditingController();
  final eventLocationTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  final startDateTextController = TextEditingController();
  final endDateTextController = TextEditingController();

  final startTimeTextController = TextEditingController();
  final endTimeTextController = TextEditingController();

  //Event topics
  CategoryModel? eventCategory;

  DateTime? startDate;
  DateTime? endDate;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<MediaFileModel> pickedMedia = [];
  List<NetworkMediaModel> serverMedia = [];

  FeedRadiusModel? radiusPreference;

  //Post permission settings
  PostSharePermission postSharePermission = PostSharePermission.allow;
  PostCommentPermission postCommentPermission = PostCommentPermission.enable;
  PostVisibilityControlEnum postVisibilityPermission =
      PostVisibilityControlEnum.public;

  late EventCategoryCubit eventCategoryCubit =
      EventCategoryCubit(ManageEventRepository());

  //Required Cubits
  late ManageEventCubit manageEventCubit = ManageEventCubit(
    manageEventRepository: ManageEventRepository(),
    mediaUploadRepository: context.read<MediaUploadRepository>(),
  );

  RadiusSliderRenderCubit radiusSliderCubit = RadiusSliderRenderCubit();
  LocationRenderCubit locationRenderCubit = LocationRenderCubit();

  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  final activeButtonCubit = ActiveButtonCubit();
//

  ///Update the data on parent widget
  void updatePostController() {
    widget.postDetailsControllerCubit!.postStateUpdate(
      UpdatePostState(
        existingEventDetails!.copyWith(
          eventShortDetails: existingEventDetails!.eventShortDetails.copyWith(
            startDate: startDate!,
            endDate: endDate!,
            startTime: startTime!,
            endTime: endTime!,
            title: titleTextController.text.trim(),
            description: descriptionTextController.text.trim(),
          ),
          postLocation: postFeedPosition!,
          taggedlocation: taggedLocation,
          postSharePermission: postSharePermission,
          postCommentPermission: postCommentPermission,
          postVisibilityPermission: postVisibilityPermission,
          postPreferenceRadius: radiusPreference!.socialMediaSearchRadius,
        ),
      ),
    );
  }

  void onPost() {
    if (formkey.currentState!.validate()) {
      if (eventCategory == null) {
        ThemeToast.errorToast("Please select event category");
        return;
      } else if (startDate == null || endDate == null) {
        ThemeToast.errorToast("Please select event dates");
        return;
      } else if (startTime == null || endTime == null) {
        ThemeToast.errorToast("Please select event times");
        return;
      } else if (taggedLocation == null) {
        ThemeToast.errorToast("Please select the event location");
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
        final manageEventModel = ManageEventModel(
          id: existingEventDetails?.id,
          postType: PostType.event,
          startDate: startDate!,
          endDate: endDate!,
          startTime: startTime!,
          endTime: endTime!,
          eventCategoryId: eventCategory!.id,
          postLocation: postFeedPosition!,
          eventLocation: taggedLocation,
          sharePermission: postSharePermission,
          title: titleTextController.text.trim(),
          commentPermission: postCommentPermission,
          visibilityPermission: postVisibilityPermission,
          description: descriptionTextController.text.trim(),
          postRadiusPreference: radiusPreference!.socialMediaSearchRadius,
          media: [...serverMedia],
        );

        manageEventCubit.manageEventPost(
          manageEventModel: manageEventModel,
          pickedMediaList: pickedMedia,
          isEdit: isEdit,
        );
      }
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

  Future<void> setTaggedLocation(
      {LocationAddressWithLatLng? selectedTaggedLocation}) async {
    taggedLocation = selectedTaggedLocation;
    if (taggedLocation != null) {
      eventLocationTextController.text = taggedLocation!.address;

      //emitting location data
      await locationRenderCubit.emitLocation(
        locationAddressWithLatLong: taggedLocation,
        locationType: LocationType.socialMedia,
      );
    } else {
      eventLocationTextController.clear();
    }
  }

  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    existingEventDetails = widget
        .postDetailsControllerCubit!.state.socialPostModel as EventPostModel;

    titleTextController.text = existingEventDetails!.eventShortDetails.title;
    descriptionTextController.text =
        existingEventDetails!.eventShortDetails.description;

    //event topics
    eventCategoryCubit.fetchEventCategorys(
      targetEventCategoryId:
          existingEventDetails!.eventShortDetails.eventCategoryId,
    );

    //Post settings
    postSharePermission = existingEventDetails!.postSharePermission;
    postVisibilityPermission = existingEventDetails!.postVisibilityPermission;
    postCommentPermission = existingEventDetails!.postCommentPermission;

    //Tag location
    setTaggedLocation(
      selectedTaggedLocation: existingEventDetails!.taggedlocation,
    );

    //Event Date Time
    //Start Date
    setEventDate(
      selectedDate: existingEventDetails!.eventShortDetails.startDate,
      isStartDate: true,
    );

    //End Date
    setEventDate(
      selectedDate: existingEventDetails!.eventShortDetails.endDate,
      isStartDate: false,
    );

    //Wait for the widget tree to render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Start Time
      setEventTime(
        selectedTime: existingEventDetails!.eventShortDetails.startTime,
        isStartTime: true,
      );

      //End Time
      setEventTime(
        selectedTime: existingEventDetails!.eventShortDetails.endTime,
        isStartTime: false,
      );
    });

    //Server Media
    serverMedia = existingEventDetails!.media;

    //Radius

    //emitting radius data
    radiusSliderCubit.emitRadius(feedRadiusModel.copyWith(
      socialMediaSearchRadius: existingEventDetails!.postPreferenceRadius,
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
        eventCategoryCubit.fetchEventCategorys();
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
    eventLocationTextController.dispose();
    descriptionTextController.dispose();
    startDateTextController.dispose();
    endDateTextController.dispose();
    startTimeTextController.dispose();
    endTimeTextController.dispose();
  }

  //Enable or disable the post button
  void postButtonValidator() {
    if (isEdit &&
        descriptionTextController.text.trim().isEmpty &&
        existingEventDetails!.media.isEmpty) {
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

  bool timeValidForSameDay(
    bool isStart, {
    TimeOfDay? selectedTime,
  }) {
    if (startDate != null &&
        endDate != null &&
        startDate!.compareTo(endDate!) == 0) {
      final selectedStartTime =
          isStart ? (selectedTime ?? startTime) : startTime;
      final selectedEndTime = isStart ? endTime : (selectedTime ?? endTime);
      if (selectedStartTime != null && selectedEndTime != null) {
        if (isStart) {
          //if start date and end date are same then, check if the start greater than end time
          //then show the error message
          if (selectedStartTime.isAfter(selectedEndTime)) {
            ThemeToast.errorToast(
                "Start time should be less than end time in the same day");
            return false;
          }
        } else {
          //if start date and end date are same then, check if the end time is less than start time
          //then show the error message

          if (selectedEndTime.isBefore(selectedStartTime)) {
            ThemeToast.errorToast(
                "End time should be greater than start time in the same day");
            return false;
          }
        }
      }
    }
    return true;
  }

  void setEventDate({
    required DateTime selectedDate,
    required bool isStartDate,
  }) {
    if (isStartDate) {
      startDate = selectedDate;
      startDateTextController.text =
          FormatDate.selectedDateDDMMYYYY(startDate!);
    } else {
      endDate = selectedDate;
      endDateTextController.text = FormatDate.selectedDateDDMMYYYY(endDate!);
    }

    if (!timeValidForSameDay(isStartDate)) {
      //clear the time fields
      clearTimeFields();
    }
  }

//clear time fields
  void clearTimeFields() {
    startTime = null;
    endTime = null;
    startTimeTextController.clear();
    endTimeTextController.clear();
  }

  Future<void> pickEventDate({required bool isStartDate}) async {
    Pick()
        .date(
      context,
      locale: Locale(
        EasyLocalization.of(context)!.locale.languageCode,
        "IN",
      ),
      //If the start Date is selected, then make it the 1st day for the Event End date
      firstDate: isStartDate ? null : startDate,
      lastDate: isStartDate ? endDate : null,
      initialDate: isStartDate ? startDate : endDate,
    )
        .then((selectedDate) {
      if (selectedDate != null) {
        setEventDate(selectedDate: selectedDate, isStartDate: isStartDate);
      }
    });
  }

  void setEventTime({
    required TimeOfDay selectedTime,
    required bool isStartTime,
  }) {
    if (!timeValidForSameDay(isStartTime, selectedTime: selectedTime)) {
      return;
    }

    if (isStartTime) {
      startTime = selectedTime;
      startTimeTextController.text = startTime!.format(context);
    } else {
      endTime = selectedTime;
      endTimeTextController.text = endTime!.format(context);
    }
  }

  Future<void> pickEventTime({required bool isStartTime}) async {
    await Pick()
        .time(
      context,
      initialTime: (isStartTime ? startTime : endTime) ?? TimeOfDay.now(),
    )
        .then((selectedTime) {
      if (selectedTime != null) {
        setEventTime(selectedTime: selectedTime, isStartTime: isStartTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: eventCategoryCubit),
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: manageEventCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider(create: (context) => MediaPickCubit()),
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
      child: BlocConsumer<ManageEventCubit, ManageEventState>(
        listener: (context, manageEventState) {
          if (manageEventState.isRequestSuccess) {
            if (isEdit) {
              updatePostController();
            } else {
              if (mounted) {
                context
                    .read<EventListCubit>()
                    .fetchEvents(eventPostListType: EventPostListType.myEvents);
              }
            }
            if (GoRouter.of(context).canPop()) {
              //Pop with true to run the data refresh list api
              GoRouter.of(context).pop(true);
            }
            return;
          }
        },
        builder: (context, manageEventState) {
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
                willPopScope(!manageEventState.isLoading);
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: CreatePostAppBar(
                  willPop: () => willPopScope(!manageEventState.isLoading),
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
                    ),
                  ],
                ),
                body: Form(
                  key: formkey,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 10),
                    children: [
                      //Screen header
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ScreenHeader(
                          title: isEdit
                              ? tr(LocaleKeys.updateEvent)
                              : tr(LocaleKeys.createEvent),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Title
                            WidgetHeading(title: tr(LocaleKeys.eventTitle)),
                            const SizedBox(height: 2),
                            ThemeTextFormField(
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
                              maxLength:
                                  TextFieldInputLength.eventTitleMaxLength,
                              validator: (value) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                value,
                                TextFieldInputLength.eventTitleMinLength,
                              ),
                            ),
                            const SizedBox(height: 10),

                            //Select Event Category
                            BlocConsumer<EventCategoryCubit,
                                EventCategoryState>(
                              listener: (context, eventCategoryState) {
                                final eventCategoryListModel =
                                    eventCategoryState.eventTopics;

                                //Assign the 1st selected category from the list
                                eventCategory = eventCategoryListModel.data
                                    .firstWhereOrNull(
                                        (element) => element.isSelected);
                              },
                              builder: (context, eventTopicState) {
                                final logs = eventTopicState.eventTopics.data;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WidgetHeading(
                                        title: tr(LocaleKeys.eventCategory)),
                                    const SizedBox(height: 5),
                                    ThemeTextFormFieldDropDown<CategoryModel>(
                                      hint: eventTopicState.dataLoading
                                          ? "Loading categories..."
                                          : "Select Event Category",
                                      hintStyle: const TextStyle(fontSize: 14),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      value: eventCategory,
                                      onChanged: (CategoryModel? newValue) {
                                        if (newValue != null) {
                                          context
                                              .read<EventCategoryCubit>()
                                              .selectEventCategory(newValue.id);
                                        }
                                      },
                                      textInputAction: TextInputAction.next,
                                      items: logs.map(
                                          (CategoryModel businessCategory) {
                                        return DropdownMenuItem(
                                          value: businessCategory,
                                          child: Text(
                                            businessCategory.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ApplicationColours
                                                  .themeBlueColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please select the event topic";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            //Event location
                            WidgetHeading(title: tr(LocaleKeys.eventLocation)),
                            const SizedBox(height: 2),
                            ThemeTextFormField(
                              controller: eventLocationTextController,
                              readOnly: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(fontSize: 14),
                              hint: tr(LocaleKeys.addEventLocation),
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
                                  if (location != null && context.mounted) {
                                    context
                                        .read<LocationTagControllerCubit>()
                                        .addLocationTag(location);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 10),

                            ////////////EVENT TIMMING////////////
                            //START DATE
                            WidgetHeading(title: tr(LocaleKeys.eventStarts)),
                            ThemeTextFormField(
                              readOnly: true,
                              controller: startDateTextController,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(fontSize: 14),
                              hint: tr(LocaleKeys.startDate),
                              hintStyle: const TextStyle(fontSize: 14),
                              onTap: () async {
                                await pickEventDate(isStartDate: true);
                              },
                              suffixIcon: const Icon(
                                Icons.calendar_month_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                              validator: (text) =>
                                  TextFieldValidator.standardValidator(text),
                            ),
                            const SizedBox(height: 5),
                            //START TIME
                            ThemeTextFormField(
                              readOnly: true,
                              controller: startTimeTextController,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(fontSize: 14),
                              hint: tr(LocaleKeys.startTime),
                              hintStyle: const TextStyle(fontSize: 14),
                              onTap: () async {
                                await pickEventTime(isStartTime: true);
                              },
                              suffixIcon: const Icon(
                                FeatherIcons.clock,
                                size: 20,
                                color: Colors.grey,
                              ),
                              validator: (text) =>
                                  TextFieldValidator.standardValidator(text),
                            ),

                            const SizedBox(height: 10),

                            //END DATE
                            WidgetHeading(title: tr(LocaleKeys.eventEnds)),
                            ThemeTextFormField(
                              readOnly: true,
                              controller: endDateTextController,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(fontSize: 14),
                              hint: tr(LocaleKeys.endDate),
                              hintStyle: const TextStyle(fontSize: 14),
                              onTap: () async {
                                await pickEventDate(isStartDate: false);
                              },
                              suffixIcon: const Icon(
                                Icons.calendar_month_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                              validator: (text) =>
                                  TextFieldValidator.standardValidator(text),
                            ),
                            const SizedBox(height: 5),

                            //END TIME
                            ThemeTextFormField(
                              readOnly: true,
                              controller: endTimeTextController,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(fontSize: 14),
                              hint: tr(LocaleKeys.endTime),
                              hintStyle: const TextStyle(fontSize: 14),
                              onTap: () async {
                                await pickEventTime(isStartTime: false);
                              },
                              suffixIcon: const Icon(
                                FeatherIcons.clock,
                                size: 20,
                                color: Colors.grey,
                              ),
                              validator: (text) =>
                                  TextFieldValidator.standardValidator(text),
                            ),
                          ],
                        ),
                      ),

                      //Caption box for event description
                      CaptionBoxWidget(
                        allowTagLocation: false,
                        allowMediaPick: !isEdit,
                        scrollController: _scrollController,
                        margin: const EdgeInsets.all(10),
                        gallaryFileType: FileType.media,
                        captionTextController: descriptionTextController,
                        hintText: tr(LocaleKeys.eventDescription),
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
                            TextFieldInputLength.eventDescriptionMaxLength,
                        validator: (value) =>
                            TextFieldValidator.standardValidatorWithMinLength(
                          value,
                          TextFieldInputLength.eventDescriptionMinLength,
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
                        postType: PostType.event,
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
                              showLoadingSpinner: manageEventState.isLoading,
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
            ),
          );
        },
      ),
    );
  }
}
