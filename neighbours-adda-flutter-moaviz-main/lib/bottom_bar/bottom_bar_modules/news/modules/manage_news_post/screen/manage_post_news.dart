import 'dart:async';

import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/logic/news_location_type_selector/cubit/news_location_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/logic/news_location_type_selector/cubit/news_location_type_selector_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/manage_news_post/manage_news_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/news_post_type_controller/news_post_type_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/news_reporter_name_controller/news_reporter_name_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/manage_news_post_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/post_news_preview_screen_payload.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/screen/post_news_preview_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/widgets/news_contributor_name_change_dialog.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/widgets/news_post_content_language_selector.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/widgets/news_publish_type_selector_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_channel_details/own_news_channel_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/newlocation_type_selector_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_success_dialog.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_app_bar.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/location_tag_controller/location_tag_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v1/logic/category_controller_v1/category_controller_v1_cubit.dart';
import 'package:snap_local/common/utils/category/v1/model/category_type_v1.dart';
import 'package:snap_local/common/utils/category/v1/model/category_v1_selection_strategy.dart';
import 'package:snap_local/common/utils/category/v1/widget/category_selection_bottom_sheet.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/common/utils/widgets/bool_enable_option/bool_enable_option.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/multi_media_selection_widget.dart';
import 'package:snap_local/utility/common/active_button/active_button_cubit.dart';
import 'package:snap_local/utility/common/media_picker/logic/media_pick/media_pick_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/google_translate/google_translate/cubit/google_translate_cubit.dart';
import 'package:snap_local/utility/localization/google_translate/repository/google_gemini_trasnlator.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class ManagePostNewsScreen extends StatefulWidget {
  final PostDetailsControllerCubit? postDetailsControllerCubit;

  const ManagePostNewsScreen({super.key, this.postDetailsControllerCubit});

  static const routeName = 'manage_post_news';

  @override
  State<ManagePostNewsScreen> createState() => _ManagePostNewsScreenState();
}

class _ManagePostNewsScreenState extends State<ManagePostNewsScreen> {
  String? channelId;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  NewsPostModel? existingNewsDetails;

  final manageNewsScrollController = ScrollController();

  LocationAddressWithLatLng? taggedLocation;

  // News location type
  NewsLocationTypeSelectorCubit newsLocationTypeSelectorCubit =
      NewsLocationTypeSelectorCubit(NewsLocationTypeEnum.local);

  // Global news type enable status
  bool enableGlobalNewsType = false;

  // News post type controller
  final newsPostTypeControllerCubit = NewsPostTypeControllerCubit();

  // Text controllers
  final newsHeadLineTextController = TextEditingController();
  final newsDescriptionTextController = TextEditingController();
  final newsLocationTextController = TextEditingController();
  final newsCategoryTextController = TextEditingController();
  final categoryController = TextEditingController();
  final otherCategoryController = TextEditingController();

  //Language handling
  LanguageEnum channelLanguage = LanguageEnum.english;
  bool isNewsHeadlineChannelLanguageSelected = true;
  bool isNewsDescriptionChannelLanguageSelected = true;
  late GoogleTranslateCubit headLineTranslateCubit =
      GoogleTranslateCubit(sourceText: newsHeadLineTextController.text.trim());
  late GoogleTranslateCubit descriptionTranslateCubit = GoogleTranslateCubit(
      sourceText: newsDescriptionTextController.text.trim());

  //Timer to trigger the translation
  Timer? _debounce;

  ///Use to replace the last word of the text after translating
  void replaceTheLastWord(
    TextEditingController textEditingController,
    String newWord,
  ) {
    final text = textEditingController.text;
    final lastSpaceIndex = text.lastIndexOf(' ');
    final newText = text.replaceRange(lastSpaceIndex + 1, text.length, newWord);
    textEditingController.text = newText;
  }

  ///Use to trigger the translation of the text, if the channel language is selected.
  void triggerTranslation(
    TextEditingController textEditingController,
    GoogleTranslateCubit googleTranslateCubit,
  ) {
    //Cancel the previous timer
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    //Add a timer, when the user stops typing for 1 second, then trigger the translation
    _debounce = Timer(const Duration(milliseconds: 500), () {
      /// When user press space then take the total value of the text field and
      /// extract the last word to translate. From the last space move to left
      /// and check the 1st character or word, and extract the last word or character.
      final text = textEditingController.text;
      final lastSpaceIndex = text.lastIndexOf(' ');
      final lastWord = text.substring(lastSpaceIndex + 1, text.length);

      if (lastWord.trim().isNotEmpty) {
        googleTranslateCubit.translateText(
          channelLanguage.locale.languageCode,
          sourceText: lastWord,
          translationRepository: GoogleGeminiTranslator(),
        );
      }
    });
  }

  void listenToContentLanguageChange() {
    headLineTranslateCubit.stream.listen((state) {
      replaceTheLastWord(
        newsHeadLineTextController,
        state.translatedText,
      );
    });

    descriptionTranslateCubit.stream.listen((state) {
      replaceTheLastWord(
        newsDescriptionTextController,
        state.translatedText,
      );
    });
  }

  final NewsReporterNameControllerCubit newsReporterNameControllerCubit =
      NewsReporterNameControllerCubit();

  final activeButtonCubit = ActiveButtonCubit();

  List<MediaFileModel> pickedMedia = [];
  List<NetworkMediaModel> serverMedia = [];

  // Target location
  LocationAddressWithLatLng? newsLocation;

  final CategoryControllerV1Cubit categoryControllerV1Cubit =
      CategoryControllerV1Cubit(
          NewsCategoryTypeV1(SingleCategorySelectionStrategy()));

  Future<void> setTaggedLocation(LocationAddressWithLatLng location) async {
    newsLocation = location;
    newsLocationTextController.text = newsLocation!.address;
  }

  // Clear target location
  void clearTaggedLocation() {
    newsLocation = null;
    newsLocationTextController.clear();
  }

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  /// This method will use to prefill the data in the edit mode
  Future<void> prefillData() async {
    existingNewsDetails = widget
        .postDetailsControllerCubit!.state.socialPostModel as NewsPostModel;

    postButtonValidator();
  }

  @override
  void initState() {
    super.initState();

    if (context.read<OwnNewsChannelCubit>().state is OwnNewsChannelLoaded) {
      final ownNewsChannel =
          (context.read<OwnNewsChannelCubit>().state as OwnNewsChannelLoaded)
              .ownNewsChannel;

      if (ownNewsChannel != null) {
        channelId = ownNewsChannel.id;
        //assigning the news reporter name
        newsReporterNameControllerCubit
            .assignContributorName(ownNewsChannel.reporterName);

        //assign channel language
        channelLanguage = ownNewsChannel.language;

        if (channelLanguage == LanguageEnum.english) {
          isNewsHeadlineChannelLanguageSelected = false;
          isNewsDescriptionChannelLanguageSelected = false;
        }

        //Allow to change news type
        enableGlobalNewsType = ownNewsChannel.enableGlobalNewsType;

        //Set channel location as default location for create news post
        setTaggedLocation(ownNewsChannel.location);
      }
    }

    categoryControllerV1Cubit.fetchCategories();

    listenToContentLanguageChange();

    //News location type selector
    newsLocationTypeSelectorCubit.stream.listen((state) {
      //If the location type is local, then unselect all the news post type
      //Because local news does not have any news post type
      if (state.selectedLocationType == NewsLocationTypeEnum.local) {
        newsPostTypeControllerCubit.unSelectAllNewsPostType();
      }
    });
  }

  // Enable or disable the post button
  void postButtonValidator() {
    if (newsCategoryTextController.text.trim().isEmpty) {
      activeButtonCubit.changeStatus(false);
    } else {
      activeButtonCubit.changeStatus(true);
    }
  }

  void selectCategory() {
    final selectedCategory = categoryControllerV1Cubit.selectedFirstData;

    if (selectedCategory != null) {
      newsCategoryTextController.text = selectedCategory.name;
    }
  }

  @override
  void dispose() {
    newsCategoryTextController.dispose();
    manageNewsScrollController.dispose();
    newsLocationTextController.dispose();
    categoryController.dispose();
    otherCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: activeButtonCubit),
        BlocProvider.value(value: newsLocationTypeSelectorCubit),
        BlocProvider.value(value: categoryControllerV1Cubit),
        BlocProvider.value(value: newsReporterNameControllerCubit),
        BlocProvider(
          create: (context) => LocationTagControllerCubit(
            taggedLocation: newsLocation,
          ),
        ),
        BlocProvider(create: (context) => MediaPickCubit()),

        // News post type controller
        BlocProvider.value(value: newsPostTypeControllerCubit),
      ],
      child: BlocConsumer<ManageNewsPostCubit, ManageNewsPostState>(
        listener: (context, manageNewsState) async {
          if (manageNewsState.isRequestSuccess) {
            if (mounted && GoRouter.of(context).canPop()) {
              //pop the screen
              GoRouter.of(context).pop(true);

              //Show the success dialog
              await showDialog(
                context: context,
                builder: (context) => const NewsSuccessDialog(),
              );
              return;
            }
          }
        },
        builder: (context, manageNewsState) {
          return PopScope(
            canPop: willPopScope(!manageNewsState.isLoading),
            child: Scaffold(
              appBar: CreatePostAppBar(
                willPop: () {
                  GoRouter.of(context).pop();
                },
              ),
              body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: BlocBuilder<NewsLocationTypeSelectorCubit,
                    NewsLocationTypeSelectorState>(
                  builder: (context, newsLocationTypeSelectorState) {
                    return ListView(
                      controller: manageNewsScrollController,
                      padding: const EdgeInsets.all(10),
                      children: [
                        Column(
                          children: [
                            // News Type
                            Align(
                              alignment: Alignment.centerLeft,
                              child: WidgetHeading(
                                title: tr(LocaleKeys.newsType),
                              ),
                            ),
                            const SizedBox(height: 5),
                            // News location type selector
                            NewsLocationTypeSelectorWidget(
                              enableGlobalNewsType: enableGlobalNewsType,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // News headline
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetHeading(
                              title: tr(LocaleKeys.newsHeadline),
                            ),
                            NewsPostContentLanguageSelector(
                              channelLanguage: channelLanguage,
                              isChannelLanguageSelected:
                                  isNewsHeadlineChannelLanguageSelected,
                              onChannelLanguageSelected: (value) {
                                isNewsHeadlineChannelLanguageSelected = value;
                              },
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            controller: newsHeadLineTextController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(fontSize: 14),
                            maxLength:
                                TextFieldInputLength.newsHeadlineMaxLength,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            validator: (text) => TextFieldValidator
                                .standardValidatorWithMinLength(
                              text,
                              TextFieldInputLength.newsHeadlineMinLength,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  isNewsHeadlineChannelLanguageSelected) {
                                triggerTranslation(
                                  newsHeadLineTextController,
                                  headLineTranslateCubit,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        // News Description
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetHeading(
                              title: tr(LocaleKeys.newsDescription),
                            ),
                            NewsPostContentLanguageSelector(
                              channelLanguage: channelLanguage,
                              isChannelLanguageSelected:
                                  isNewsDescriptionChannelLanguageSelected,
                              onChannelLanguageSelected: (value) {
                                isNewsDescriptionChannelLanguageSelected =
                                    value;
                              },
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            controller: newsDescriptionTextController,
                            textInputAction: TextInputAction.newline,
                            maxLines: 8,
                            minLines: 4,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.3,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            maxLength:
                                TextFieldInputLength.pageDescriptionMaxLength,
                            validator: (value) => TextFieldValidator
                                .standardValidatorWithMinLength(
                              value,
                              TextFieldInputLength.pageDescriptionMinLength,
                              isOptional: true,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  isNewsDescriptionChannelLanguageSelected) {
                                triggerTranslation(
                                  newsDescriptionTextController,
                                  descriptionTranslateCubit,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        //Upload news/media
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: MultiMediaSelectionWidget(
                            fileType: FileType.media,
                            serverMedia: serverMedia,
                            onServerMediaUpdated: (serverMediaList) {
                              serverMedia = serverMediaList;
                            },
                            onMediaSelected: (selectedMediaList) {
                              pickedMedia = selectedMediaList;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        //Show the news post type selector if the global news is selected
                        AnimatedHideWidget(
                          visible: newsLocationTypeSelectorState
                                  .selectedLocationType ==
                              NewsLocationTypeEnum.global,
                          //News post type selector
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: NewsPostTypeSelectorWidget(),
                          ),
                        ),

                        // Show the news tag location if the local news is selected
                        // News Tag location
                        AnimatedHideWidget(
                          visible: newsLocationTypeSelectorState
                                  .selectedLocationType ==
                              NewsLocationTypeEnum.local,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BlocListener<LocationTagControllerCubit,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetHeading(
                                    title: tr(LocaleKeys.newsLocation),
                                  ),
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
                                        extra: newsLocation,
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

                        //News Category
                        Align(
                          alignment: Alignment.centerLeft,
                          child: WidgetHeading(
                            title: tr(LocaleKeys.category),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Select news category
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
                                // Dropdown
                                ThemeTextFormField(
                                  controller: newsCategoryTextController,
                                  readOnly: true,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: const TextStyle(fontSize: 14),
                                  hint: tr(LocaleKeys.selectCategory),
                                  hintStyle: const TextStyle(
                                    color: Color.fromRGBO(104, 107, 116, 0.6),
                                    fontSize: 14,
                                  ),
                                  // Dropdown icon
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: ApplicationColours.themeBlueColor,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    // Reset search before opening the bottom sheet
                                    categoryControllerV1Cubit.resetSearch();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
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

                                // Other category
                                AnimatedHideWidget(
                                  visible: categoryControllerV1Cubit
                                          .selectedFirstData?.isOtherCategory ??
                                      false,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ThemeTextFormField(
                                      controller: otherCategoryController,
                                      textInputAction: TextInputAction.next,
                                      contentPadding: const EdgeInsets.all(10),
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
                                      validator: (text) =>
                                          TextFieldValidator.standardValidator(
                                              text),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        //reporter name show/hide option
                        BlocBuilder<NewsReporterNameControllerCubit,
                            NewsReporterNameControllerState>(
                          builder: (context, newsReporterNameControllerState) {
                            return newsReporterNameControllerState
                                        .newsReporter ==
                                    null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: BoolEnableOptionWidget(
                                      headingWidget: //Contributor name heading
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                tr(LocaleKeys.reporterName),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: ApplicationColours
                                                        .themeBlueColor),
                                              ),
                                              const SizedBox(width: 5),
                                              //edit icon
                                              GestureDetector(
                                                onTap: () {
                                                  //Show dialog to edit the reporter name
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return BlocProvider.value(
                                                        value:
                                                            newsReporterNameControllerCubit,
                                                        child:
                                                            const NewsContributorNameChangeDialog(),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          //Contributor name text widget
                                          Text(
                                            newsReporterNameControllerState
                                                .newsReporter!.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      enableText: LocaleKeys.show,
                                      disableText: LocaleKeys.hide,
                                      enable: newsReporterNameControllerState
                                          .newsReporter!.visibility,
                                      onEnableChanged: (status) {
                                        //Assign visibility
                                        context
                                            .read<
                                                NewsReporterNameControllerCubit>()
                                            .assignContributorVisibility(
                                              status,
                                            );
                                      },
                                    ),
                                  );
                          },
                        ),
                        // Post Button
                        BlocBuilder<ActiveButtonCubit, ActiveButtonState>(
                          builder: (context, activeButtonState) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ThemeElevatedButton(
                                buttonName: tr(LocaleKeys.publish),
                                showLoadingSpinner: manageNewsState.isLoading,
                                disableButton: activeButtonState.isEnabled,
                                onPressed: () {
                                  final isGlobalLocation = context
                                          .read<NewsLocationTypeSelectorCubit>()
                                          .state
                                          .selectedLocationType ==
                                      NewsLocationTypeEnum.global;

                                  //News post type
                                  final newsPostType = context
                                      .read<NewsPostTypeControllerCubit>()
                                      .getSelectedNewsPostType();

                                  if (channelId == null) {
                                    ThemeToast.errorToast(
                                        "Channel id not available");
                                  }
                                  if (formkey.currentState!.validate()) {
                                    if (!categoryControllerV1Cubit
                                        .state.isAnyCategorySelected) {
                                      ThemeToast.errorToast(
                                          "Please select a category");
                                      return;
                                    } else if (!isGlobalLocation &&
                                        newsLocation == null) {
                                      ThemeToast.errorToast(
                                          "Please select a target location");
                                      return;
                                    } else if (newsReporterNameControllerCubit
                                            .state.newsReporter ==
                                        null) {
                                      ThemeToast.errorToast(
                                        "Contributor name is required",
                                      );
                                      return;
                                    }
                                    //Check for media, if both server and picked media is empty,
                                    //then show error
                                    else if (serverMedia.isEmpty &&
                                        pickedMedia.isEmpty) {
                                      ThemeToast.errorToast(
                                          "Please select media to upload");
                                      return;
                                    }

                                    //If the news location type is global, then user must to select the news post type
                                    else if (isGlobalLocation &&
                                        newsPostType == null) {
                                      ThemeToast.errorToast(
                                          "Please select a news post type");
                                      return;
                                    } else {
                                      final manageNewsPostModel =
                                          ManageNewsPostModel(
                                        newsHeadLine: newsHeadLineTextController
                                            .text
                                            .trim(),
                                        newsDescription:
                                            newsDescriptionTextController.text
                                                .trim(),
                                        categoryId: categoryControllerV1Cubit
                                            .selectedFirstData!.id,
                                        otherCategoryName:
                                            otherCategoryController.text.trim(),
                                        newsReporter:
                                            newsReporterNameControllerCubit
                                                .state.newsReporter!,
                                        postLocation: newsLocation!,
                                        isGlobalNews: isGlobalLocation,
                                        media: [...serverMedia],
                                        channelId: channelId!,
                                        newsPostType: newsPostType,
                                      );

                                      final postNewsPreviewScreenPayload =
                                          PostNewsPreviewScreenPayload(
                                        newsPostModel: manageNewsPostModel,
                                        pickedMediaList: pickedMedia,
                                      );

                                      //Before post news open the preview screen
                                      GoRouter.of(context)
                                          .pushNamed<bool>(
                                        PostNewsPreviewScreen.routeName,
                                        extra: postNewsPreviewScreenPayload,
                                      )
                                          .then((value) {
                                        if (value != null &&
                                            value &&
                                            context.mounted) {
                                          // Create or update the news
                                          context
                                              .read<ManageNewsPostCubit>()
                                              .createOrUpdateNewsPostDetails(
                                                newspostDetailsModel:
                                                    postNewsPreviewScreenPayload
                                                        .newsPostModel,
                                                pickedMediaList:
                                                    postNewsPreviewScreenPayload
                                                        .pickedMediaList,
                                              );
                                        }
                                      });
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
