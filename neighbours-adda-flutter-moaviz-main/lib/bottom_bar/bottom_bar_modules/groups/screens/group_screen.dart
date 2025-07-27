// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_home_data/group_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/search_filter_controller/search_filter_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/screen/create_or_update_group_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/search_group_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/group_list_widget_v2.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/search_filter_tab.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
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
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../tutorial_screens/tutorial_logic/logic.dart';

class GroupScreen extends StatefulWidget {
  final bool isRootNavigation;
  final GroupListType groupListType;
  const GroupScreen({
    super.key,
    this.isRootNavigation = false,
    required this.groupListType,
  });
  static const routeName = 'group';

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  //use for bottom bar hide
  DateTime? previousEventTime;
  double previousScrollOffset = 0;

  //Tutorial coach
  GlobalKey groupSearchIconKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  //Search filter type
  SearchFilterTypeEnum searchFilterTypeEnum = SearchFilterTypeEnum.yourGroups;
  late SearchFilterControllerCubit searchFilterControllerCubit =
      SearchFilterControllerCubit(GroupSearchFilter())
        ..selectSearchFilterType(searchFilterTypeEnum);

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
        identify: "group_search_icon_key",
        keyTarget: groupSearchIconKey,
        shape: ShapeLightFocus.RRect,
        alignSkip: Alignment.center,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TargetCoachWidget(
                tutorialCoachMark: tutorialCoachMark,
                title: "Click here to search and join groups",
                nextText: "OK",
                onNext: () async {
                  await TutorialCoachSharedPref().setGroupScreenCoachComplete();
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
      if (!await TutorialCoachSharedPref().isGroupScreenCoachCompleted()) {
        showTutorial();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //initTutorialCoach();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Fetch the initial data
      context
          .read<GroupHomeDataCubit>()
          .fetchGroupHomeData(searchFilterTypeEnum);

      //Listen to the search filter type and fetch the data
      searchFilterControllerCubit.stream.listen(
        (state) {
          if (state.selectedSearchFilterTypeCategory != null) {
            searchFilterTypeEnum = state.selectedSearchFilterTypeCategory!.type;
            if (mounted) {
              context
                  .read<GroupHomeDataCubit>()
                  .fetchGroupHomeData(searchFilterTypeEnum);
            }
          }
        },
      );

      //Listen to the group home data, and if the data come empty for Your Groups, then select the Suggested group
      context.read<GroupHomeDataCubit>().stream.listen((state) {
        if (state is GroupHomeDataLoaded) {
          if (state.data.isEmpty &&
              searchFilterTypeEnum == SearchFilterTypeEnum.yourGroups) {
            searchFilterControllerCubit
                .selectSearchFilterType(SearchFilterTypeEnum.suggested);
          }
        }
      });
    });
    //handleGroupsTutorial(context);
  }

  void openCreateOrUpdateGroupDetailsScreen(
      ProfileSettingsState profileSettingsState) {
    if (profileSettingsState.isProfileSettingModelAvailable) {
      if (profileSettingsState.profileSettingsModel!.socialMediaLocation !=
          null) {
        if (mounted) {
          GoRouter.of(context)
              .pushNamed(CreateOrUpdateGroupDetailsScreen.routeName)
              .whenComplete(() => context.read<GroupListCubit>().fetchGroups(
                  groupListType: GroupListType.managedByYou,
                  disableLoading: true));
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
    super.dispose();
    //Close the tutorial
    tutorialCoachMark.finish();
  }

  void willPopScope() {
    if (widget.isRootNavigation) {
      context.read<BottomBarNavigatorCubit>().goToHome();
    } else {
      GoRouter.of(context).pop();
    }
    return;
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          }
          willPopScope();
        },
        child: Scaffold(
          appBar: ThemeAppBar(
            appBarHeight: 60,
            backgroundColor: Colors.white,
            showBackButton: !widget.isRootNavigation,
            title: PageHeading(
              svgPath: SVGAssetsImages.groupsColored,
              heading: widget.groupListType.name,
              subHeading: widget.groupListType.description,
            ),
          ),
          body: Column(
            children: [
              SearchBoxWidget(
                key: groupSearchIconKey,
                searchHint: tr(LocaleKeys.searchGroup),
                onSearchTap: () {
                  GoRouter.of(context).pushNamed(SearchGroupScreen.routeName);
                },
              ),
              const SearchFilterSelectorWidget(),
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
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
              Expanded(
                child: GroupListWidgetV2(groupListType: widget.groupListType),
              ),
            ],
          ),
          floatingActionButton:
              BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
            builder: (context, profileSettingsState) {
              if (profileSettingsState.isProfileSettingModelAvailable) {
                return ManagePostActionButton(
                  onPressed: () {
                    openCreateOrUpdateGroupDetailsScreen(profileSettingsState);
                  },
                  text: tr(LocaleKeys.createGroup),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
