import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/profile/gender/logic/gender_selector/gender_selector_cubit.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';
import 'package:snap_local/common/social_media/profile/gender/widgets/gender_selection_widget.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_cubit.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';
import 'package:snap_local/common/social_media/profile/language_known/widget/language_known_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/model/edit_profile_details_model.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/profile/manage_profile_details/widgets/camera_button_widget.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/widgets/text_field_heading_widget.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';
import 'package:snap_local/utility/year_of_birth/model/dob_years_list.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = 'edit_profile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final shortBioController = TextEditingController();
  final occupationController = TextEditingController();
  final workPlaceController = TextEditingController();
  final dobController = TextEditingController();

  //year of birth
  int? yearOfBirth;

  String? profileImageUrl;
  String? coverImageUrl;
  MediaFileModel? pickedProfileImage;
  MediaFileModel? pickedCoverImage;
  List<LanguageKnownModel> languagesKnown = [];

  GenderSelectorCubit genderSelectorCubit = GenderSelectorCubit();
  MediaPickCubit profilePicPickCubit = MediaPickCubit();
  MediaPickCubit coverPicPickCubit = MediaPickCubit();
  GenderEnum gender = GenderEnum.none;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    shortBioController.dispose();
    dobController.dispose();
    occupationController.dispose();
    workPlaceController.dispose();
    super.dispose();
  }

  void initializeProfileDetails(ProfileDetailsModel profileDetailsModel) {
    //Assign the name
    nameController.text = profileDetailsModel.name;

    //Assign the email
    if (profileDetailsModel.email != null) {
      emailController.text = profileDetailsModel.email!;
    }

    //Assign the short bio
    shortBioController.text = profileDetailsModel.bio;

    //Assign the year of birth
    yearOfBirth = profileDetailsModel.dob?.year;

    //Assign the occupation
    occupationController.text = profileDetailsModel.occupation;

    //Assign the work place
    workPlaceController.text = profileDetailsModel.workPlace;

    //Assign the languages
    context.read<LanguageKnownCubit>().selectLanguageById(profileDetailsModel
        .languageKnownList.languages
        .map((e) => e.id)
        .toList());

    //Assign the profile image
    profileImageUrl = profileDetailsModel.profileImage;

    //Assign the cover image
    coverImageUrl = profileDetailsModel.coverImage;

    //select gender
    gender = profileDetailsModel.gender;
    genderSelectorCubit.selectGender(gender);
  }

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ManageProfileDetailsBloc>().state;
    if (!profileState.dataLoading && profileState.isProfileDetailsAvailable) {
      initializeProfileDetails(profileState.profileDetailsModel!);
    }
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return LanguageChangeBuilder(
      builder: (context, languageState) {
        return BlocProvider.value(
          value: genderSelectorCubit,
          child:
              BlocConsumer<ManageProfileDetailsBloc, ManageProfileDetailsState>(
            listener: (context, profileState) {
              if (profileState.isRequestSuccess) {
                if (mounted) {
                  GoRouter.of(context).pop();
                }
              }
            },
            builder: (context, profileState) {
              return PopScope(
                canPop: willPopScope(!profileState.isRequestLoading),
                child: LanguageChangeBuilder(
                  builder: (context, _) {
                    return Scaffold(
                      appBar: ThemeAppBar(
                        //TODO:need to check
                        onPop: () async =>
                            willPopScope(!profileState.isRequestLoading),
                        backgroundColor: Colors.white,
                        title: Text(
                          tr(LocaleKeys.editProfile),
                          style: TextStyle(
                              color: ApplicationColours.themeBlueColor),
                        ),
                      ),
                      body: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: formkey,
                            child: Column(
                              children: [
                                //Cover image
                                BlocProvider.value(
                                  value: coverPicPickCubit,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 15,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    alignment: Alignment.center,
                                    child: BlocConsumer<MediaPickCubit,
                                        MediaPickState>(
                                      listener: (context, mediaPickState) {
                                        final logs = mediaPickState
                                            .mediaPickerModel.pickedFiles;
                                        if (logs.isNotEmpty) {
                                          pickedCoverImage = logs.first;
                                        }
                                      },
                                      builder: (context, mediaPickState) {
                                        return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            transitionBuilder:
                                                (child, animation) {
                                              return ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              );
                                            },
                                            child: mediaPickState.dataLoading
                                                ? const ThemeSpinner(size: 40)
                                                : Stack(
                                                    children: [
                                                      //Show the picked file image
                                                      pickedCoverImage != null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        MediaPickCubit>()
                                                                    .pickGalleryMedia(
                                                                      context,
                                                                      type: FileType
                                                                          .image,
                                                                    );
                                                              },
                                                              child: Image.file(
                                                                ((pickedCoverImage
                                                                        as ImageFileMediaModel)
                                                                    .imageFile),
                                                              ),
                                                            )
                                                          :
                                                          //No image handler
                                                          coverImageUrl ==
                                                                      null ||
                                                                  coverImageUrl!
                                                                      .isEmpty
                                                              ? CircleAvatar(
                                                                  radius: mqSize
                                                                          .width *
                                                                      0.18,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade100,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 80,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              :
                                                              //Network Image
                                                              Hero(
                                                                  tag:
                                                                      coverImageUrl!,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        coverImageUrl!,
                                                                  ),
                                                                ),
                                                      Positioned(
                                                        bottom: 10,
                                                        right: 10,
                                                        child:
                                                            CircleCameraButton(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    MediaPickCubit>()
                                                                .pickGalleryMedia(
                                                                  context,
                                                                  type: FileType
                                                                      .image,
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                      },
                                    ),
                                  ),
                                ),

                                //Profile Image
                                BlocProvider.value(
                                  value: profilePicPickCubit,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 15,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    alignment: Alignment.center,
                                    child: BlocConsumer<MediaPickCubit,
                                        MediaPickState>(
                                      listener: (context, mediaPickState) {
                                        final logs = mediaPickState
                                            .mediaPickerModel.pickedFiles;
                                        if (logs.isNotEmpty) {
                                          pickedProfileImage = logs.first;
                                        }
                                      },
                                      builder: (context, mediaPickState) {
                                        return mediaPickState.dataLoading
                                            ? CircleAvatar(
                                                radius: mqSize.width * 0.18,
                                                backgroundColor:
                                                    Colors.grey.shade100,
                                                child: const ThemeSpinner(
                                                    size: 40),
                                              )
                                            : Stack(
                                                children: [
                                                  //Show the picked file image
                                                  pickedProfileImage != null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    MediaPickCubit>()
                                                                .pickGalleryMedia(
                                                                  context,
                                                                  type: FileType
                                                                      .image,
                                                                );
                                                          },
                                                          child: CircleAvatar(
                                                            radius:
                                                                mqSize.width *
                                                                    0.18,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .shade100,
                                                            foregroundImage:
                                                                FileImage(
                                                              (pickedProfileImage
                                                                      as ImageFileMediaModel)
                                                                  .imageFile,
                                                            ),
                                                          ),
                                                        )
                                                      :
                                                      //No image handler
                                                      profileImageUrl == null ||
                                                              profileImageUrl!
                                                                  .isEmpty
                                                          ? CircleAvatar(
                                                              radius:
                                                                  mqSize.width *
                                                                      0.18,
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade100,
                                                              child: const Icon(
                                                                Icons.person,
                                                                size: 80,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          :
                                                          //Network Image
                                                          Hero(
                                                              tag:
                                                                  profileImageUrl!,
                                                              child:
                                                                  NetworkImageCircleAvatar(
                                                                radius: mqSize
                                                                        .width *
                                                                    0.18,
                                                                imageurl:
                                                                    profileImageUrl!,
                                                              ),
                                                            ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 10,
                                                    child: CircleCameraButton(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                MediaPickCubit>()
                                                            .pickGalleryMedia(
                                                              context,
                                                              type: FileType
                                                                  .image,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                      },
                                    ),
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 15,
                                  ),
                                  child: Column(
                                    children: [
                                      TextFieldWithHeading(
                                        textFieldHeading:
                                            tr(LocaleKeys.fullName),
                                        headingPadding:
                                            const EdgeInsets.only(bottom: 6),
                                        child: ThemeTextFormField(
                                          controller: nameController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('[a-z,A-Z, ]'),
                                            ),
                                          ],
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.name
                                          ],
                                          hint: tr(LocaleKeys.enterYourName),
                                          style: const TextStyle(fontSize: 14),
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          maxLength: 50,
                                          validator: (text) => TextFieldValidator
                                              .standardValidatorWithMinLength(
                                            text,
                                            TextFieldInputLength
                                                .fullNameMinLength,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        children: [
                                          TextFieldHeadingTextWidget(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            text: tr(LocaleKeys.selectGender),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          GenderSelectionWidget(
                                              onGenderSelected:
                                                  (selectedGender) {
                                            gender = selectedGender;
                                            context
                                                .read<GenderSelectorCubit>()
                                                .selectGender(selectedGender);
                                          }),
                                        ],
                                      ),
                                      //Commented out the email field as per client requirement
                                      // const SizedBox(height: 10),
                                      // TextFieldWithHeading(
                                      //   textFieldHeading:
                                      //       tr(LocaleKeys.emailId),
                                      //   child: ThemeTextFormField(
                                      //     controller: emailController,
                                      //     hint: tr(LocaleKeys.addYourEmail),
                                      //     textInputAction: TextInputAction.next,
                                      //     autofillHints: const [
                                      //       AutofillHints.email
                                      //     ],
                                      //     inputFormatters: [
                                      //       FilteringTextInputFormatter.deny(
                                      //           RegExp('[ ]')),
                                      //     ],
                                      //     keyboardType:
                                      //         TextInputType.emailAddress,
                                      //     textCapitalization:
                                      //         TextCapitalization.none,
                                      //     style: const TextStyle(fontSize: 14),
                                      //     hintStyle:
                                      //         const TextStyle(fontSize: 14),
                                      //     validator: (value) =>
                                      //         value != null && value.isNotEmpty
                                      //             ? TextFieldValidator
                                      //                 .emailValidator(value)
                                      //             : null,
                                      //   ),
                                      // ),
                                      const SizedBox(height: 10),
                                      TextFieldWithHeading(
                                        textFieldHeading:
                                            tr(LocaleKeys.selectDOB),
                                        child:
                                            //Year of Birth
                                            TextFieldWithHeading(
                                          textFieldHeading:
                                              tr(LocaleKeys.yearOfBirth),
                                          child: ThemeTextFormFieldDropDown(
                                            hint: tr(
                                                LocaleKeys.selectYearOfBirth),
                                            hintStyle:
                                                const TextStyle(fontSize: 14),
                                            items:
                                                DOBYearsList.years.map((year) {
                                              return DropdownMenuItem<int>(
                                                value: year,
                                                child: Text(year.toString()),
                                              );
                                            }).toList(),
                                            value: yearOfBirth,
                                            onChanged: (int? value) {
                                              if (value != null) {
                                                yearOfBirth = value;
                                              }
                                            },
                                          ),
                                        ),

                                        // ThemeTextFormField(
                                        //   hint: tr(
                                        //       LocaleKeys.enterYourDateofBirth),
                                        //   readOnly: true,
                                        //   controller: dobController,
                                        //   style: const TextStyle(fontSize: 14),
                                        //   hintStyle:
                                        //       const TextStyle(fontSize: 14),
                                        //   textInputAction: TextInputAction.next,
                                        //   validator: (text) =>
                                        //       TextFieldValidator
                                        //           .standardValidator(text),
                                        //   onTap: () async {
                                        //     await showDatePicker(
                                        //       context: context,
                                        //       helpText: tr(LocaleKeys
                                        //           .selectYourDateofBirth),
                                        //       locale: Locale(
                                        //         context.locale.languageCode,
                                        //         "IN",
                                        //       ),
                                        //       initialDate:
                                        //           selectedDOB ?? DateTime(2000),
                                        //       firstDate: DateTime(1940),
                                        //       lastDate: DateTime.now().subtract(
                                        //           const Duration(
                                        //               days: 365 * 16)),
                                        //     ).then((selectedDate) {
                                        //       if (selectedDate != null) {
                                        //         selectedDOB = selectedDate;
                                        //         dobController.text = FormatDate
                                        //             .selectedDateDDMMYYYY(
                                        //                 selectedDOB!);
                                        //       }
                                        //     });
                                        //   },
                                        //   suffixIcon: const Icon(
                                        //     Icons.calendar_month_rounded,
                                        //     size: 20,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFieldWithHeading(
                                        showOptional: true,
                                        textFieldHeading:
                                            tr(LocaleKeys.aShortBio),
                                        child: ThemeTextFormField(
                                          hint: tr(LocaleKeys.enterAShortBio),
                                          controller: shortBioController,
                                          textInputAction:
                                              TextInputAction.newline,
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          maxLines: 4,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          style: const TextStyle(fontSize: 14),
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          maxLength: TextFieldInputLength
                                              .shortBioMaxLength,
                                          validator: (text) => TextFieldValidator
                                              .standardValidatorWithMinLength(
                                            text,
                                            TextFieldInputLength
                                                .shortBioMinLength,
                                            isOptional: true,
                                          ),
                                        ),
                                      ),

                                      //Occupation text field
                                      const SizedBox(height: 10),
                                      TextFieldWithHeading(
                                        showOptional: true,
                                        textFieldHeading:
                                            tr(LocaleKeys.occupation),
                                        child: ThemeTextFormField(
                                          hint:
                                              tr(LocaleKeys.addYourOccupation),
                                          controller: occupationController,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.jobTitle
                                          ],
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('[a-z,A-Z, ]'),
                                            ),
                                          ],
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          style: const TextStyle(fontSize: 14),
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          maxLength: TextFieldInputLength
                                              .generalTextMaxLength,
                                          validator: (text) => TextFieldValidator
                                              .standardValidatorWithMinLength(
                                            text,
                                            TextFieldInputLength
                                                .generalTextMinLength,
                                            isOptional: true,
                                          ),
                                        ),
                                      ),

                                      //Work place text field
                                      const SizedBox(height: 10),
                                      TextFieldWithHeading(
                                        showOptional: true,
                                        textFieldHeading: "Work Place",
                                        child: ThemeTextFormField(
                                          hint: "Add your work place",
                                          controller: workPlaceController,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const [
                                            AutofillHints.organizationName
                                          ],
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('[a-z,A-Z, ]'),
                                            ),
                                          ],
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          style: const TextStyle(fontSize: 14),
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          maxLength: TextFieldInputLength
                                              .generalTextMaxLength,
                                          validator: (text) => TextFieldValidator
                                              .standardValidatorWithMinLength(
                                            text,
                                            TextFieldInputLength
                                                .generalTextMinLength,
                                            isOptional: true,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                      LanguageKnownWidget(
                                        onLanguageSelected:
                                            (selectedLanguages) {
                                          languagesKnown = selectedLanguages;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 20),
                                  child: ThemeElevatedButton(
                                    buttonName: tr(LocaleKeys.save),
                                    showLoadingSpinner:
                                        profileState.isRequestLoading,
                                    onPressed: () {
                                      if (formkey.currentState!.validate()) {
                                        if (!gender.isGenderAvalable) {
                                          ThemeToast.errorToast(
                                            tr(LocaleKeys.pleaseSelectaGender),
                                          );
                                          return;
                                        }
                                        //  else if (languagesKnown.isEmpty) {
                                        //   ThemeToast.errorToast(
                                        //       "Please select atleast one known language");
                                        //   return;
                                        // }
                                        else {
                                          FocusScope.of(context).unfocus();
                                          final editProfileModel =
                                              EditProfileDetailsModel(
                                            name: nameController.text.trim(),
                                            email: emailController.text.trim(),
                                            gender: gender,
                                            profileImageUrl: profileImageUrl,
                                            coverImageUrl: coverImageUrl,
                                            dateOfBirth: yearOfBirth != null
                                                ? DateTime(yearOfBirth!)
                                                : null,
                                            bio: shortBioController.text.trim(),
                                            occupation: occupationController
                                                .text
                                                .trim(),
                                            workPlace:
                                                workPlaceController.text.trim(),
                                            languageKnownList:
                                                LanguageKnownList(
                                                    languages: languagesKnown),
                                          );
                                          context
                                              .read<ManageProfileDetailsBloc>()
                                              .add(
                                                UpdateProfileDetails(
                                                  pickedImageFile:
                                                      pickedProfileImage,
                                                  pickedCoverImageFile:
                                                      pickedCoverImage,
                                                  editProfileDetailsModel:
                                                      editProfileModel,
                                                ),
                                              );
                                        }
                                      }
                                    },
                                  ),
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
            },
          ),
        );
      },
    );
  }
}
