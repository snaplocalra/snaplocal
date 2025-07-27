import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_grid_builder.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/conntection_action_button_v2.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/screen/analytics_overview_screen.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/shimmers/square_grid_shimmer.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/profile/manage_profile_details/screens/edit_profile_screen.dart';
import 'package:snap_local/profile/profile_details/model/post_view_type.dart';
import 'package:snap_local/profile/profile_details/own_profile/logic/own_posts/own_posts_cubit.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/refer_earn/screen/refer_earn_screen.dart';
import 'package:snap_local/profile/profile_details/repository/profile_posts_repository.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/widget/snap_local_achievements.dart';
import 'package:snap_local/profile/profile_settings/screens/settings_menu_screen.dart';
import 'package:snap_local/profile/widgets/profile_details_widget.dart';
import 'package:snap_local/profile/widgets/profile_post_view_tab_widget.dart';
import 'package:snap_local/tutorial_screens/tutorial_logic/logic.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

import '../../../../tutorial_screens/own_profile_tutorial.dart';
import '../../../connections/screens/profile_connections_screen.dart';

class OwnProfilePostsScreen extends StatefulWidget {
  const OwnProfilePostsScreen({super.key});

  static const routeName = 'own_profile_posts';

  @override
  State<OwnProfilePostsScreen> createState() => _OwnProfilePostsScreenState();
}

class _OwnProfilePostsScreenState extends State<OwnProfilePostsScreen> {
  OwnPostsCubit ownPostsCubit = OwnPostsCubit(ProfilePostsRepository());
  final ownPostScrollController = ScrollController();
  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  PostViewType postViewType = PostViewType.posts;

  @override
  void initState() {
    super.initState();
    ownPostsCubit.fetchOwnSocialPosts(postViewType);
    ownPostScrollController.addListener(() {
      //When scrolling ensure that, the reaction option is close
      showReactionCubit.closeReactionEmojiOption();
      //////
      if (ownPostScrollController.position.maxScrollExtent ==
          ownPostScrollController.offset) {
        ownPostsCubit.fetchOwnSocialPosts(
          postViewType,
          loadMoreData: true,
        );
      }
    });
    //handleOwnProfileTutorial(context);
  }



  @override
  void dispose() {
    super.dispose();
    ownPostScrollController.dispose();
  }

  bool willPopScope(bool allowPop) {
    //Before pop the screen, fetch the latest own feed post
    ownPostsCubit.fetchOwnSocialPosts(postViewType);
    return allowPop;
  }

  void fetchUserData() {
    context.read<ManageProfileDetailsBloc>().add(FetchProfileDetails());
    ownPostsCubit.fetchOwnSocialPosts(postViewType);
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ownPostsCubit),
        BlocProvider.value(value: showReactionCubit),
      ],
      child: LanguageChangeBuilder(builder: (context, _) {
        return PopScope(
          canPop: willPopScope(true),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator.adaptive(
              onRefresh: () async => fetchUserData(),
              child: CustomScrollView(
                controller: ownPostScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: BlocBuilder<ManageProfileDetailsBloc,
                        ManageProfileDetailsState>(
                      builder: (context, profileState) {
                        if (profileState.dataLoading ||
                            profileState.isProfileDetailsAvailable) {
                          final ProfileDetailsModel profileDetails =
                              profileState.profileDetailsModel!;
                          bool isOfficial=profileDetails.userType=="official";
                          return Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    ProfileDetailsWidget(
                                      isOwnProfile: true,
                                      isOfficial: isOfficial,
                                      profileDetailsModel: profileDetails,
                                    ),
                                    SafeArea(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Back button
                                          const IOSBackButton(
                                            circleSize: 30,
                                            iconSize: 23,
                                          ),

                                          //Settings button
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: mqSize.width * 0.03),
                                            child: CircularSvgButton(
                                                svgImage:
                                                    SVGAssetsImages.settings,
                                                iconSize: 20,
                                                backgroundColor:
                                                    Colors.blue.shade50,
                                                onTap: () {
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                    SettingsMenuScreen
                                                        .routeName,
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: const Color.fromRGBO(245, 245, 245, 1),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ConnectionActionButtonV2(
                                        buttonName: LocaleKeys.editProfile,
                                        onPressed: () {
                                          GoRouter.of(context).pushNamed(
                                              EditProfileScreen.routeName);
                                        },
                                        backgroundColor: ApplicationColours
                                            .themeLightPinkColor,
                                      ),
                                      if(!isOfficial)
                                      ConnectionActionButtonV2(
                                        buttonName: LocaleKeys.analytics,
                                        onPressed: () {
                                          GoRouter.of(context).pushNamed(
                                            AnalyticsOverviewScreen.routeName,
                                            queryParameters: {
                                              'module_id': profileDetails.id,
                                              'module_type': AnalyticsModuleType
                                                  .profile.jsonValue,
                                            },
                                          );
                                        },
                                        backgroundColor: ApplicationColours
                                            .themeLightPinkColor,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          GoRouter.of(context).pushNamed(
                                              ReferEarnScreen.routeName);
                                        },
                                        child: const SvgButtonWidget(
                                          svgImage: SVGAssetsImages.giftBox,
                                          svgSize: 30,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: ThemeDivider(height: 5)),
                  SliverToBoxAdapter(
                    child: BlocBuilder<ManageProfileDetailsBloc,
                        ManageProfileDetailsState>(
                      builder: (context, manageProfileDetailsState) {
                        return manageProfileDetailsState.isProfileDetailsAvailable&&manageProfileDetailsState.profileDetailsModel?.name!="Snap Local"
                            ? Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                child: SnaplocalAchievements(
                                  userId: manageProfileDetailsState
                                      .profileDetailsModel!.id,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: ThemeDivider(height: 5)),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              tr(LocaleKeys.connectionsDescription),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          ThemeElevatedButton(
                            buttonName: tr(LocaleKeys.connections),
                            width: mqSize.width * 0.3,
                            height: mqSize.height * 0.045,
                            padding: EdgeInsets.zero,
                            backgroundColor:
                                ApplicationColours.themeLightPinkColor,
                            textFontSize: 12,
                            onPressed: () {
                              //Go to connection screen
                              GoRouter.of(context)
                                  .pushNamed(ProfileConnectionScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: ThemeDivider(height: 5)),
                  SliverToBoxAdapter(
                    child: ProfilePostViewTabWidget(
                      onTabChange: (postViewType) {
                        this.postViewType = postViewType;
                        ownPostsCubit.fetchOwnSocialPosts(
                          postViewType,
                          showLoading: true,
                        );
                      },
                      tabViewBuilder: (tabController) =>
                          BlocBuilder<OwnPostsCubit, OwnPostsState>(
                        builder: (context, ownPostsState) {
                          final logs = ownPostsState.ownPosts.socialPostList;
                          if (ownPostsState.error != null) {
                            return ErrorTextWidget(error: ownPostsState.error!);
                          } else if (ownPostsState.dataLoading) {
                            return postViewType == PostViewType.photos ||
                                    postViewType == PostViewType.videos
                                ? const SquareGridShimmerBuilder(gridCount: 3)
                                : const PostListShimmer(scrollable: true);
                          } else if (logs.isEmpty) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: mqSize.height * 0.08),
                              child: const EmptyDataPlaceHolder(
                                emptyDataType: EmptyDataType.post,
                              ),
                            );
                          } else {
                            return postViewType == PostViewType.photos ||
                                    postViewType == PostViewType.videos
                                ? SocialPostGridBuilder(
                                    allowNavigation: false,
                                    socialPostsModel: ownPostsState.ownPosts,
                                  )
                                : SocialPostListBuilder(
                                    allowNavigation: false,
                                    socialPostsModel: ownPostsState.ownPosts,
                                    hideEmptyPlaceHolder: true,
                                    onRemoveItemFromList: (index) {
                                      context
                                          .read<OwnPostsCubit>()
                                          .removePost(index);
                                    },
                                  );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
