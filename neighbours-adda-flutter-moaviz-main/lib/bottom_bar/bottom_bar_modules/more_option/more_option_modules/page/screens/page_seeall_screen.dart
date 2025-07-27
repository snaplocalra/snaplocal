// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/screen/create_or_update_page_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/search_page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_seeall_screen_data_widget.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/common/utils/widgets/search_with_filter_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PageSeeAllScreen extends StatefulWidget {
  const PageSeeAllScreen({super.key});
  static const String routeName = 'page-see-all-screen';

  @override
  State<PageSeeAllScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageSeeAllScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();

  //Tutorial coach
  GlobalKey pageSearchIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    //Fetch both type Pages data
    context.read<PageListCubit>().fetchPages();
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataOnMapViewControllerCubit()..setListView(),
      child: BlocBuilder<LanguageChangeControllerCubit,
          LanguageChangeControllerState>(
        builder: (context, _) {
          return Scaffold(
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              showBackButton: true,
              title: PageHeading(
                svgPath: SVGAssetsImages.spotlight,
                heading: PageListType.managedByYou.name,
                subHeading: PageListType.managedByYou.description,
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
                  child: BlocBuilder<PageListCubit, PageListState>(
                    builder: (context, pageListState) {
                      final pageListModel = pageListState.pageTypeListModel;

                      final managedByYouData = pageListModel.managedByYou.data;

                      final followedPageData =
                          pageListModel.pagesYouFollow.data;

                      final showLoading =
                          pageListState.isManagedByYouDataLoading &&
                              pageListState.isPagesYouFollowDataLoading;

                      if (showLoading) {
                        return Container(
                          color: Colors.white,
                          child: const CircleCardShimmerListBuilder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                        );
                      } else {
                        return RefreshIndicator.adaptive(
                          onRefresh: () async {
                            context.read<PageListCubit>().fetchPages();
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              //if both groups are empty
                              if (managedByYouData.isEmpty &&
                                  followedPageData.isEmpty)
                                Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: const EmptyDataPlaceHolder(
                                    emptyDataType: EmptyDataType.page,
                                  ),
                                ),

                              //Admin groups
                              if (managedByYouData.isNotEmpty)
                                PageSeeAllScreenDataWidget(
                                  pageList: managedByYouData,
                                  header: 'Admin',
                                  onLoadMore: () {
                                    context.read<PageListCubit>().fetchPages(
                                        loadMoreData: true,
                                        pageListType:
                                            PageListType.managedByYou);
                                  },
                                  isLastPage: pageListModel
                                      .managedByYou.paginationModel.isLastPage,
                                ),

                              //Joined groups
                              if (followedPageData.isNotEmpty)
                                PageSeeAllScreenDataWidget(
                                  pageList: followedPageData,
                                  header: 'Followed',
                                  onLoadMore: () {
                                    context.read<PageListCubit>().fetchPages(
                                        loadMoreData: true,
                                        pageListType:
                                            PageListType.pagesYouFollow);
                                  },
                                  isLastPage: pageListModel.pagesYouFollow
                                      .paginationModel.isLastPage,
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
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
