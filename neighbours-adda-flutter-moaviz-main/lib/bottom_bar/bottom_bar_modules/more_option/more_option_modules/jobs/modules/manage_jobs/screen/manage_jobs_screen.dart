import 'package:collection/collection.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/logic/job_skills/job_skills_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/logic/manage_jobs/manage_jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/models/jobs_manage_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/repository/manage_jobs_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/widgets/job_skills_selection_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/widgets/job_type_builder_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/widgets/work_type_builder_widget.dart';
import 'package:snap_local/common/market_places/widgets/single_media_picker.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
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
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_shimmer.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/helper/location_permanent_denied_dialog.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

import '../../../../../../../../common/utils/widgets/bool_enable_option/bool_enable_option.dart';

class ManageJobsScreen extends StatefulWidget {
  final JobDetailModel? existJobsDetailModel;

  const ManageJobsScreen({super.key, this.existJobsDetailModel});

  static const routeName = 'manage_job_post';

  @override
  State<ManageJobsScreen> createState() => _ManageJobsScreenState();
}

class _ManageJobsScreenState extends State<ManageJobsScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isEditMode = false;

  final manageJobsScrollController = ScrollController();
  final activeButtonCubit = ActiveButtonCubit();

  //Text field controllers
  final companyNameController = TextEditingController();
  final jobDesignationController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final cityNameController = TextEditingController();
  final maximumExperienceController = TextEditingController();
  final minimumExperienceController = TextEditingController();
  final minimumSalaryController = TextEditingController();
  final maximumSalaryController = TextEditingController();
  final categoryController = TextEditingController();
  final workLocationController = TextEditingController();
  final numberOfPositionsController = TextEditingController();
  final jobQualificationController = TextEditingController();

  LocationAddressWithLatLng? workLocation;

  //Job type
  JobType jobType = JobType.contract;

  //Work type
  WorkType workType = WorkType.remote;

  //Server media
  NetworkMediaModel? serverMedia;

  //Must have skills
  List<String> mustHaveSkills = [];

  //Enable chat
  bool enableChat = true;

  //Manage Job Repository
  final manageJobRepository = ManageJobRepository();

  //Initialization of cubits
  late JobSkillsCubit jobSkillsCubit = JobSkillsCubit(manageJobRepository);
  late ManageJobsCubit manageJobsCubit = ManageJobsCubit(
    mediaUploadRepository: context.read<MediaUploadRepository>(),
    manageJobRepository: manageJobRepository,
  );

  final MediaPickCubit mediaPickCubit = MediaPickCubit();
  final radiusSliderCubit = RadiusSliderRenderCubit();
  final locationRenderCubit = LocationRenderCubit();
  late LocationServiceControllerCubit locationServiceControllerCubit =
      LocationServiceControllerCubit(context.read<LocationServiceRepository>());

  final workLocationTagControllerCubit = LocationTagControllerCubit();

  final CategoryControllerCubit categoryControllerCubit =
      CategoryControllerCubit(
          JobCategory(SingleSubCategorySelectionStrategy()));

  //Selected category
  CategoryModelV2? selectedCategoryModel;

  DynamicCategoryFieldControllerCubit dynamicCategoryFieldControllerCubit =
      DynamicCategoryFieldControllerCubit(DynamicCategoryFieldRepository());

  //Common
  MediaFileModel? pickedMedia;
  LocationAddressWithLatLng? jobsPreferencePosition;
  FeedRadiusModel? radiusPreference;

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

  //Set job category
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
      dynamicCategoryPostFrom: DynamicCategoryPostFrom.jobs,
      preSelectedData: dynamicFields,
    );
  }

  ///This method will use to prefill the data in the edit mode
  void prefillData({required FeedRadiusModel feedRadiusModel}) {
    final existingJobsDetails = widget.existJobsDetailModel!;

    serverMedia = existingJobsDetails.media.firstOrNull;

    //Company Name
    companyNameController.text = existingJobsDetails.companyName;

    //job designation
    jobDesignationController.text = existingJobsDetails.jobDesignation;

    //job experience
    minimumExperienceController.text =
        existingJobsDetails.minWorkExperience.formatNumber();
    maximumExperienceController.text =
        existingJobsDetails.maxWorkExperience.formatNumber();

    //Salary
    minimumSalaryController.text = existingJobsDetails.minSalary.toString();
    maximumSalaryController.text = existingJobsDetails.maxSalary.toString();

    //Set work location
    setWorkLocation(existingJobsDetails.workLocation);

    //Job type
    jobType = existingJobsDetails.jobType;

    //Work type
    workType = existingJobsDetails.workType;

    //City
    cityNameController.text = existingJobsDetails.cityName;

    //Number of positions
    if (existingJobsDetails.numberOfPositions > 0) {
      numberOfPositionsController.text =
          existingJobsDetails.numberOfPositions.toString();
    }

    //Job qualification
    jobQualificationController.text = existingJobsDetails.jobQualification;

    //Enable chat
    enableChat = existingJobsDetails.enableChat;

    //Fetch skills and select by id list
    jobSkillsCubit.selectJobSkill(jobSkills: existingJobsDetails.skills);

    //set job category
    categoryControllerCubit.fetchCategories(
      preselectionStrategy: CategoryV2PreselectionFromCategoryModelV3(
        existingJobsDetails.category,
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
            dynamicFields: existingJobsDetails.category.dynamicFields,
          );
        }
      }
    });

    //Job description
    jobDescriptionController.text = existingJobsDetails.jobDescription;

    //emitting radius data
    radiusSliderCubit.emitRadius(feedRadiusModel.copyWith(
      marketPlaceSearchRadius: existingJobsDetails.jobPreferenceRadius,
    ));
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

      //Fetch skills
      jobSkillsCubit.fetchJobSkillsCategories();

      //Edit mode
      if (widget.existJobsDetailModel != null) {
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
    //Scroll controller
    manageJobsScrollController.dispose();

    //Text controllers
    companyNameController.dispose();
    jobDesignationController.dispose();
    jobDescriptionController.dispose();
    minimumExperienceController.dispose();
    maximumExperienceController.dispose();
    minimumSalaryController.dispose();
    maximumSalaryController.dispose();
    cityNameController.dispose();
    categoryController.dispose();
    workLocationController.dispose();
    numberOfPositionsController.dispose();
    jobQualificationController.dispose();
  }

  //Set work location
  Future<void> setWorkLocation(LocationAddressWithLatLng location) async {
    workLocation = location;
    workLocationController.text = location.address;

    //Add the location to the tag controller
    //emitting location data
    await locationRenderCubit.emitLocation(
      locationAddressWithLatLong: location,
      locationType: LocationType.marketPlace,
    );
  }

  //clean work location
  void cleanWorkLocation() {
    workLocation = null;
    workLocationController.clear();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: jobSkillsCubit),
        BlocProvider.value(value: manageJobsCubit),
        BlocProvider.value(value: mediaPickCubit),
        BlocProvider.value(value: locationServiceControllerCubit),
        BlocProvider.value(value: locationRenderCubit),
        BlocProvider.value(value: radiusSliderCubit),
        BlocProvider.value(value: workLocationTagControllerCubit),
        BlocProvider.value(value: categoryControllerCubit),
        BlocProvider.value(value: dynamicCategoryFieldControllerCubit),
      ],
      child: BlocConsumer<ManageJobsCubit, ManageJobsState>(
        listener: (context, manageJobsState) {
          if (manageJobsState.isRequestSuccess) {
            if (mounted) {
              try {
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
        builder: (context, manageJobState) {
          // final mqSize = MediaQuery.sizeOf(context);

          return PopScope(
            canPop: willPopScope(!manageJobState.isLoading),
            child: Scaffold(
              appBar: ThemeAppBar(
                elevation: 2,
                backgroundColor: Colors.white,
                onPop: () async => willPopScope(!manageJobState.isLoading),
                title: Text(
                  tr(
                    isEditMode
                        ? LocaleKeys.updateJobPost
                        : LocaleKeys.createJobPost,
                  ),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
              ),
              body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: manageJobsScrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    //Upload the logo
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: BlocBuilder<MediaPickCubit, MediaPickState>(
                        builder: (context, mediaPickState) {
                          final logs =
                              mediaPickState.mediaPickerModel.pickedFiles;

                          //Assign the first file to the pickedMedia
                          pickedMedia = logs.firstOrNull;
                          return Column(
                            children: [
                              TextFieldHeadingTextWidget(
                                padding: const EdgeInsets.only(bottom: 8),
                                text: tr(LocaleKeys.uploadLogo),
                                fontWeight: FontWeight.w500,
                              ),
                              SingleMediaPickerWidget(
                                serverMedia: serverMedia,
                                onServerMediaRemove: () {
                                  //clear the media
                                  serverMedia = null;
                                },
                                onMediaPicked: (media) {
                                  pickedMedia = media;
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    //Post details
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          //Job designation
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.jobDesignation),
                            child: ThemeTextFormField(
                              controller: jobDesignationController,
                              textInputAction: TextInputAction.next,
                              hint: tr(LocaleKeys.exSeniorAnalyst),
                              contentPadding: const EdgeInsets.all(10),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              maxLength:
                                  TextFieldInputLength.jobDesignationMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength
                                          .jobDesignationMinLength),
                            ),
                          ),
                          const SizedBox(height: 10),
                          //Company name
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.companyName),
                            child: ThemeTextFormField(
                              controller: companyNameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(fontSize: 14),
                              hint: tr(LocaleKeys.exPaypal),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              maxLength:
                                  TextFieldInputLength.companyNameMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.companyNameMinLength,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          //City
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.city),
                            child: ThemeTextFormField(
                              controller: cityNameController,
                              textInputAction: TextInputAction.next,
                              hint: tr(LocaleKeys.exHyderabadMumbai),
                              contentPadding: const EdgeInsets.all(10),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              maxLength: TextFieldInputLength.cityNameMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.cityNameMinLength,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Work Location
                          BlocListener<LocationTagControllerCubit,
                              LocationTagControllerState>(
                            listener: (context, locationTagControllerState) {
                              if (locationTagControllerState.taggedLocation !=
                                  null) {
                                setWorkLocation(
                                    locationTagControllerState.taggedLocation!);
                              } else {
                                cleanWorkLocation();
                              }
                            },
                            child: TextFieldWithHeading(
                              textFieldHeading: tr(LocaleKeys.workLocation),
                              child: ThemeTextFormField(
                                controller: workLocationController,
                                readOnly: true,
                                onTap: () {
                                  GoRouter.of(context)
                                      .pushNamed<LocationAddressWithLatLng>(
                                          TagLocationScreen.routeName,
                                          extra: workLocation)
                                      .then((location) {
                                    if (location != null) {
                                      context
                                          .read<LocationTagControllerCubit>()
                                          .addLocationTag(location);
                                    }
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: ApplicationColours.themeBlueColor,
                                  size: 18,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<LocationTagControllerCubit>()
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
                                    TextFieldValidator.standardValidator(text),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          //Job Experience
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.experienceRequired),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ThemeTextFormField(
                                    controller: minimumExperienceController,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    contentPadding: const EdgeInsets.all(10),
                                    keyboardType: TextInputType.number,
                                    hint: tr(LocaleKeys.minYears),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.0,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: ApplicationColours.themeBlueColor,
                                    ),
                                    maxLength: TextFieldInputLength
                                        .experienceRequiredMaxLength,
                                    validator: (text) => TextFieldValidator
                                        .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength
                                          .experienceRequiredMinLength,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ThemeTextFormField(
                                    controller: maximumExperienceController,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    contentPadding: const EdgeInsets.all(10),
                                    keyboardType: TextInputType.number,
                                    hint: tr(LocaleKeys.maxYears),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.0,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: ApplicationColours.themeBlueColor,
                                    ),
                                    maxLength: TextFieldInputLength
                                        .experienceRequiredMaxLength,
                                    validator: (text) => TextFieldValidator
                                        .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength
                                          .experienceRequiredMinLength,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Must have skills
                          BlocProvider.value(
                            value: jobSkillsCubit,
                            child: JobSkillsSelectionWidget(
                              label: tr(LocaleKeys.selectSkill),
                              heading: LocaleKeys.mustHaveSkills,
                              onJobSkillSelected: (selectedJobSkill) {
                                //If selected skills list is not empty then enable the post button
                                context
                                    .read<ActiveButtonCubit>()
                                    .changeStatus(selectedJobSkill.isNotEmpty);

                                mustHaveSkills = selectedJobSkill;
                              },
                            ),
                          ),

                          const SizedBox(height: 10),
                          //Number of positions
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.numberOfPositions),
                            showOptional: true,
                            child: ThemeTextFormField(
                              controller: numberOfPositionsController,
                              textInputAction: TextInputAction.next,
                              contentPadding: const EdgeInsets.all(10),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              maxLength:
                                  TextFieldInputLength.jobPositionMaxLength,
                            ),
                          ),

                          //Qualification
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.jobQualification),
                            showOptional: true,
                            child: ThemeTextFormField(
                              controller: jobQualificationController,
                              textInputAction: TextInputAction.next,
                              contentPadding: const EdgeInsets.all(10),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              maxLength: TextFieldInputLength
                                  .jobQualificationMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.jobQualificationMinLength,
                                isOptional: true,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          //Salary Range
                          TextFieldWithHeading(
                            textFieldHeading:
                                "${tr(LocaleKeys.salaryRange)} (${LocaleKeys.annually})",
                            child: Row(
                              children: [
                                Expanded(
                                  child: ThemeTextFormField(
                                    controller: minimumSalaryController,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    contentPadding: const EdgeInsets.all(10),
                                    keyboardType: TextInputType.number,
                                    hint: "₹ ${tr(LocaleKeys.min)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.0,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: ApplicationColours.themeBlueColor,
                                    ),
                                    maxLength: TextFieldInputLength
                                        .salaryRangeMaxLength,
                                    validator: (text) => TextFieldValidator
                                        .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength.salaryRangeMinLength,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ThemeTextFormField(
                                    controller: maximumSalaryController,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    contentPadding: const EdgeInsets.all(10),
                                    keyboardType: TextInputType.number,
                                    hint: "₹ ${tr(LocaleKeys.max)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.0,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: ApplicationColours.themeBlueColor,
                                    ),
                                    maxLength: TextFieldInputLength
                                        .salaryRangeMaxLength,
                                    validator: (text) => TextFieldValidator
                                        .standardValidatorWithMinLength(
                                      text,
                                      TextFieldInputLength.salaryRangeMinLength,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          //Job Type
                          JobTypeBuilderWidget(
                            jobType: jobType,
                            onJobTypeSelected: (selectedJobType) {
                              jobType = selectedJobType;
                            },
                          ),
                          const SizedBox(height: 15),

                          //Work Type
                          WorkTypeBuilderWidget(
                            workType: workType,
                            onWorkTypeSelected: (selectedWorkType) {
                              workType = selectedWorkType;
                            },
                          ),

                          const SizedBox(height: 20),

                          //Select Job category
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.jobCategory),
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
                          //Job Descripton
                          TextFieldWithHeading(
                            textFieldHeading: tr(LocaleKeys.jobDescription),
                            child: ThemeTextFormField(
                              controller: jobDescriptionController,
                              textInputAction: TextInputAction.newline,
                              minLines: 6,
                              maxLines: 10,
                              textCapitalization: TextCapitalization.sentences,
                              hint:
                                  tr(LocaleKeys.exLookingforaTableauDeveloper),
                              contentPadding: const EdgeInsets.all(10),
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: ApplicationColours.themeBlueColor,
                              ),
                              maxLength:
                                  TextFieldInputLength.jobDescriptionMaxLength,
                              validator: (text) => TextFieldValidator
                                  .standardValidatorWithMinLength(
                                text,
                                TextFieldInputLength.jobDescriptionMinLength,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          //Chat enable option
                          BoolEnableOptionWidget(
                            title: LocaleKeys.chat,
                            enable: enableChat,
                            onEnableChanged: (status) {
                              enableChat = status;
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
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

                              jobsPreferencePosition = marketPlaceLocation;

                              LatLng? postFeedCoOrdinates;

                              if (jobsPreferencePosition != null) {
                                postFeedCoOrdinates = LatLng(
                                  jobsPreferencePosition!.latitude,
                                  jobsPreferencePosition!.longitude,
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
                                          tr(LocaleKeys
                                              .jobPostRadiusPreference),
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
                                      ? LocaleKeys.updateJobPost
                                      : LocaleKeys.createJobPost,
                                ),
                                showLoadingSpinner: manageJobState.isLoading,
                                disableButton:
                                    locationServiceState == LoadingLocation(),
                                onPressed: () async {
                                  try {
                                    FocusScope.of(context).unfocus();

                                    // if (isEditMode &&
                                    //         (serverMedia.isEmpty &&
                                    //             pickedMedia.isEmpty) ||
                                    //     !isEditMode && pickedMedia.isEmpty) {
                                    // ThemeToast.errorToast(
                                    //     "Please select atleast one job image");
                                    // await scrollAnimateTo(
                                    //   scrollController:
                                    //       manageJobsScrollController,
                                    //   offset: 0.0,
                                    // );
                                    // return;
                                    // } else

                                    // if (mustHaveSkills.isEmpty) {
                                    //   ThemeToast.errorToast(
                                    //       "Please select at least one skill");
                                    //   await scrollAnimateTo(
                                    //       scrollController:
                                    //           manageJobsScrollController,
                                    //       offset: 500);
                                    //   return;
                                    // } else

                                    if (selectedCategoryModel == null) {
                                      ThemeToast.errorToast(tr(LocaleKeys
                                          .pleaseSelectTheJobCategory));
                                      return;
                                    } else if (!context
                                        .read<
                                            DynamicCategoryFieldControllerCubit>()
                                        .validateDynamicFieldsData()) {
                                      scrollAnimateTo(
                                        scrollController:
                                            manageJobsScrollController,
                                        offset: 150,
                                      );
                                    } else if (jobsPreferencePosition == null) {
                                      ThemeToast.errorToast(
                                          tr(LocaleKeys.pleaseselectalocation));
                                      return;
                                    } else if (radiusPreference == null) {
                                      ThemeToast.errorToast(tr(LocaleKeys
                                          .pleaseselectapostfeedradius));
                                      return;
                                    } else if (workLocation == null) {
                                      ThemeToast.errorToast(tr(LocaleKeys
                                          .pleaseselectaworklocation));
                                    } else {
                                      if (formkey.currentState!.validate()) {
                                        final jobManageModel = JobManageModel(
                                          id: widget.existJobsDetailModel?.id,

                                          companyName:
                                              companyNameController.text.trim(),
                                          workLocation: workLocation!,

                                          jobDesignation:
                                              jobDesignationController.text
                                                  .trim(),
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
                                          minSalary: double.parse(
                                              minimumSalaryController.text
                                                  .trim()),
                                          maxSalary: double.parse(
                                              maximumSalaryController.text
                                                  .trim()),
                                          cityName:
                                              cityNameController.text.trim(),
                                          jobType: jobType,
                                          workType: workType,
                                          minWorkExperience: double.parse(
                                              minimumExperienceController.text
                                                  .trim()),
                                          maxWorkExperience: double.parse(
                                              maximumExperienceController.text
                                                  .trim()),

                                          jobDescription:
                                              jobDescriptionController.text
                                                  .trim(),

                                          numberOfPositions: int.tryParse(
                                              numberOfPositionsController.text
                                                  .trim()),

                                          jobQualification:
                                              jobQualificationController.text
                                                  .trim(),
                                          musHaveSkills: mustHaveSkills,

                                          jobPreferenceRadius: radiusPreference!
                                              .marketPlaceSearchRadius,
                                          postLocation: jobsPreferencePosition!,
                                          enableChat: enableChat,

                                          //Copy the array to avoid array reference
                                          media: serverMedia != null
                                              ? [serverMedia!]
                                              : [],
                                        );

                                        context
                                            .read<ManageJobsCubit>()
                                            .createOrUpdateJobs(
                                              jobManageModel: jobManageModel,
                                              pickedMedia: pickedMedia,

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
