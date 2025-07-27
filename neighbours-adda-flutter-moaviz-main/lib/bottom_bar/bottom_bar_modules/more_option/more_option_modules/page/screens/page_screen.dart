// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/search_filter_controller/search_filter_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/search_filter_tab.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_home_data/page_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/screen/create_or_update_page_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/search_page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_list_widget.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/tutorial_coach/shared_pref/tutorial_coach_shared_pref.dart';
import 'package:snap_local/common/utils/tutorial_coach/widgets/target_coach_widget.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/common/utils/widgets/search_with_filter_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../../../tutorial_screens/tutorial_logic/logic.dart';

class PageScreen extends StatefulWidget {
  final PageListType pageListType;
  const PageScreen({
    super.key,
    required this.pageListType,
  });
  static const routeName = 'pages';

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  //Search filter type
  SearchFilterTypeEnum searchFilterTypeEnum = SearchFilterTypeEnum.yourPages;
  late SearchFilterControllerCubit searchFilterControllerCubit =
      SearchFilterControllerCubit(PageSearchFilter())
        ..selectSearchFilterType(searchFilterTypeEnum);

  //Tutorial coach
  GlobalKey pageSearchIconKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      hideSkip: true,
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "page_search_icon_key",
        keyTarget: pageSearchIconKey,
        alignSkip: Alignment.center,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TargetCoachWidget(
                tutorialCoachMark: tutorialCoachMark,
                title: "Click here to search and join pages",
                nextText: "OK",
                onNext: () async {
                  await TutorialCoachSharedPref().setPageScreenCoachComplete();
                  tutorialCoachMark.finish();
                },
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  void initTutorialCoach() {
    //Tutorial coach
    createTutorial();
    Future.delayed(Duration.zero, () async {
      if (!await TutorialCoachSharedPref().isPageScreenCoachCompleted()) {
        showTutorial();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //initTutorialCoach();

    //handlePagesTutorial(context);

    //Fetch both type Pages data
    context.read<PageListCubit>().fetchPages();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Fetch the initial data
      context
          .read<PageHomeDataCubit>()
          .fetchGroupHomeData(searchFilterTypeEnum);

      //Listen to the search filter type and fetch the data
      searchFilterControllerCubit.stream.listen(
        (state) {
          if (state.selectedSearchFilterTypeCategory != null) {
            searchFilterTypeEnum = state.selectedSearchFilterTypeCategory!.type;
            if (mounted) {
              context
                  .read<PageHomeDataCubit>()
                  .fetchGroupHomeData(searchFilterTypeEnum);
            }
          }
        },
      );

      //Listen to the group home data, and if the data come empty for Your Groups, then select the Suggested group
      context.read<PageHomeDataCubit>().stream.listen((state) {
        if (state is PageHomeDataLoaded) {
          if (state.data.isEmpty &&
              searchFilterTypeEnum == SearchFilterTypeEnum.yourPages) {
            searchFilterControllerCubit
                .selectSearchFilterType(SearchFilterTypeEnum.suggested);
          }
        }
      });
    });
  }

  void openCreateOrUpdatePageDetailsScreen(
      ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.socialMediaLocation !=
          null) {
        if (mounted) {
          GoRouter.of(context)
              .pushNamed(CreateOrUpdatePageDetailsScreen.routeName)
              .whenComplete(() => context
                  .read<PageListCubit>()
                  .fetchPages(pageListType: PageListType.managedByYou));
        }
      } else {
        showThemeAlertDialog(
          context: context,
          onAcceptPressed: () {
            if (mounted) {
              GoRouter.of(context).pushNamed(
                LocationManageMapScreen.routeName,
                extra: {
                  "locationType": LocationType.socialMedia,
                  "locationManageType": LocationManageType.setting,
                },
              );
            }
          },
          agreeButtonText: "Update Now",
          cancelButtonText: tr(LocaleKeys.cancel),
          title: "You need to update your location to procced.",
        );
      }
    }
  }

  @override
  void dispose() {
    //Close tutorial
    tutorialCoachMark.finish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DataOnMapViewControllerCubit()..setListView(),
        ),
        BlocProvider.value(value: searchFilterControllerCubit),
      ],
      child: BlocBuilder<LanguageChangeControllerCubit,
          LanguageChangeControllerState>(
        builder: (context, _) {
          return Scaffold(
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              showBackButton: true,
              title: PageHeading(
                svgPath: SVGAssetsImages.spotlight,
                heading: widget.pageListType.name,
                subHeading: widget.pageListType.description,
              ),
              appBarHeight: 60,
            ),
            body: Column(
              children: [
                SearchBoxWidget(
                  key: pageSearchIconKey,
                  searchHint: tr(LocaleKeys.searchPages),
                  onSearchTap: () {
                    GoRouter.of(context).pushNamed(SearchPageScreen.routeName);
                  },
                ),
                const SearchFilterSelectorWidget(),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: AddressWithLocateMe(
                    key: _addressWithLocateMeKey,
                    is3D: true,
                    iconSize: 15,
                    iconTopPadding: 0,
                    locationType: LocationType.socialMedia,
                    contentMargin: EdgeInsets.zero,
                    height: 35,
                    decoration: BoxDecoration(
                      color: ApplicationColours.skyColor.withOpacity(1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: null,
                  ),
                ),

                //Pages you followed
                Expanded(
                    child: PageListWidget(
                  pageListType: widget.pageListType,
                )),
              ],
            ),
            floatingActionButton:
                BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
              builder: (context, profileSettingsState) {
                if (profileSettingsState.isProfileSettingModelAvailable) {
                  return ManagePostActionButton(
                    onPressed: () {
                      openCreateOrUpdatePageDetailsScreen(profileSettingsState);
                    },
                    text: tr(LocaleKeys.createPage),
                    // text: 'hello',
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
