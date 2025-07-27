// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_grid_builder.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/shimmers/square_grid_shimmer.dart';
import 'package:snap_local/common/utils/widgets/svg_button_text_widget.dart';
import 'package:snap_local/profile/connections/logic/profile_connection_action/profile_connection_action_cubit.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';
import 'package:snap_local/profile/profile_details/model/post_view_type.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/logic/neighbours_posts/neighbours_posts_cubit.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/logic/neighbours_profile/neighbours_profile_cubit.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/model/neighbours_profile_posts_model.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/repository/neighbours_profile_posts_repository.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/widgets/profile_action_button_shimmer.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/widgets/profile_connection_action_widgets.dart';
import 'package:snap_local/profile/profile_details/repository/profile_posts_repository.dart';
import 'package:snap_local/profile/profile_details/snap_local_achievements/widget/snap_local_achievements.dart';
import 'package:snap_local/profile/widgets/profile_details_widget.dart';
import 'package:snap_local/profile/widgets/profile_details_widget_shimmer.dart';
import 'package:snap_local/profile/widgets/profile_post_view_tab_widget.dart';
import 'package:snap_local/tutorial_screens/tutorial_logic/logic.dart';
import 'package:snap_local/utility/common/pop_up_menu/models/pop_up_menu_type.dart';
import 'package:snap_local/utility/common/pop_up_menu/widgets/pop_up_menu_child.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

import '../../../../common/social_media/profile/connections/widgets/conntection_action_button_v2.dart';

class NeighboursProfileAndPostsScreen extends StatefulWidget {
  final String userid;

  ///This ProfileConnectionActionCubit instance will use, when there is already an instance was created before navigating to this screen.
  final ProfileConnectionActionCubit? profileConnectionActionCubit;
  const NeighboursProfileAndPostsScreen({
    super.key,
    required this.userid,
    this.profileConnectionActionCubit,
  });

  static const routeName = 'neighbours_profile_and_post';

  @override
  State<NeighboursProfileAndPostsScreen> createState() =>
      _NeighboursProfileAndPostsScreenState();
}

class _NeighboursProfileAndPostsScreenState
    extends State<NeighboursProfileAndPostsScreen> {
  final neighboursPostsScrollController = ScrollController();

  //BLoC initialization
  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  //Profile post cubit
  final neighboursPostsCubit = NeighboursPostsCubit(ProfilePostsRepository());

  //Profile connection action cubit
  late ProfileConnectionActionCubit profileConnectionActionCubit =
      widget.profileConnectionActionCubit ??
          ProfileConnectionActionCubit(
            connectionRepository: ProfileConnectionRepository(),
          );

  //Neighbours profile cubit
  NeighboursProfileCubit neighboursProfileCubit =
      NeighboursProfileCubit(NeighboursProfileRepository());

  PostViewType postViewType = PostViewType.posts;

  @override
  void initState() {
    super.initState();

    neighboursProfileCubit.fetchNeighboursProfile(widget.userid);
    neighboursPostsCubit.fetchSocialPosts(
      postViewType,
      userId: widget.userid,
    );

    neighboursPostsScrollController.addListener(() {
      //When scrolling ensure that, the reaction option is close
      showReactionCubit.closeReactionEmojiOption();
      //////
      if (neighboursPostsScrollController.position.maxScrollExtent ==
          neighboursPostsScrollController.offset) {
        neighboursPostsCubit.fetchSocialPosts(
          postViewType,
          userId: widget.userid,
          loadMoreData: true,
        );
      }
    });
    //handleOtherProfileTutorial(context);
  }

  @override
  void dispose() {
    neighboursPostsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: neighboursProfileCubit),
        BlocProvider.value(value: neighboursPostsCubit),
        BlocProvider.value(value: profileConnectionActionCubit),
        BlocProvider.value(value: showReactionCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<NeighboursProfileCubit, NeighboursProfileState>(
          listener: (context, neighboursProfilePostState) {
            if (neighboursProfilePostState.isDataLoaded) {
              //On data load in the neighbours profile post cubit, stop the loading on the connection action if active
              context.read<ProfileConnectionActionCubit>().stopLoading();
            }
          },
          builder: (context, neighboursProfilePostState) {
            if (neighboursProfilePostState.error != null) {
              return ErrorTextWidget(error: neighboursProfilePostState.error!);
            } else if (neighboursProfilePostState.dataLoading) {
              return const SafeArea(child: ProfileLoadingShimmer());
            } else {
              final NeighboursProfileModel neighboursProfilePosts =
                  neighboursProfilePostState.neighboursProfileModel!;

              final connectionDetails =
                  neighboursProfilePosts.connectionDetailsModel;
              final neighboursProfile =
                  neighboursProfilePosts.profileDetailsModel;
              print("---------------------------------------------");
              print(neighboursProfile.toJson());
              bool isOfficial=neighboursProfile.userType=="official";
              return RefreshIndicator.adaptive(
                onRefresh: () => neighboursProfileCubit
                    .fetchNeighboursProfile(widget.userid),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: neighboursPostsScrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                ProfileDetailsWidget(
                                  isOwnProfile: false,
                                  isOfficial: isOfficial,
                                  profileDetailsModel: neighboursProfile,
                                ),
                                SafeArea(
                                  child: Row(
                                    children: [
                                      //Back button
                                      const IOSBackButton(
                                        circleSize: 30,
                                        iconSize: 23,
                                      ),
                                      // SvgButtonTextWidget(
                                      //   onTap: () {
                                      //     //Share the profile
                                      //     context.read<ShareCubit>().generalShare(
                                      //       context,
                                      //       data: widget.userid,
                                      //       screenURL:
                                      //       NeighboursProfileAndPostsScreen
                                      //           .routeName,
                                      //       shareSubject:
                                      //       "${neighboursProfile.name} Profile",
                                      //     );
                                      //   },
                                      //   text: tr(LocaleKeys.share),
                                      //   svgImage: SVGAssetsImages.shareArrow,
                                      //   svgHeight: 20,
                                      //   svgWidth: 20,
                                      // ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          //Share the profile
                                          context.read<ShareCubit>().generalShare(
                                            context,
                                            data: widget.userid,
                                            screenURL:
                                            NeighboursProfileAndPostsScreen
                                                .routeName,
                                            shareSubject:
                                            "${neighboursProfile.name} Profile",
                                          );
                                        },
                                        child: CircularSvgButton(
                                          svgImage: SVGAssetsImages.shareArrow,
                                          iconSize: 20,
                                          backgroundColor:
                                          Colors.blue.shade50,
                                        ),
                                      ),
                                      //Block user popup menu
                                      BlocBuilder<NeighboursProfileCubit, NeighboursProfileState>(
                                        builder:
                                            (context, neighboursProfileState) {
                                          return (neighboursProfileState
                                                          .neighboursProfileModel !=
                                                      null &&
                                                  !neighboursProfileState
                                                      .neighboursProfileModel!
                                                      .profileDetailsModel
                                                      .isBlockedByYou)
                                              ? BlocBuilder<
                                                  ProfileConnectionActionCubit,
                                                  ProfileConnectionActionState>(
                                                  builder: (context,
                                                      profileConnectionActionState) {
                                                    return PopupMenuButton(
                                                      enabled:
                                                          !profileConnectionActionState
                                                              .toggleBlockLoading,
                                                      icon: CircularSvgButton(
                                                        svgImage: SVGAssetsImages.moreDot,
                                                        iconSize: 20,
                                                        backgroundColor:
                                                            Colors.blue.shade50,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      iconSize: 20,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      itemBuilder: (context) =>
                                                          [
                                                        const PopupMenuItem(
                                                          height: 30,
                                                          value: PopUpMenuType
                                                              .block,
                                                          child: PopUpMenuChild(
                                                              popUpMenuType:
                                                                  PopUpMenuType
                                                                      .block),
                                                        ),
                                                      ],
                                                      onSelected: (value) {
                                                        if (value ==
                                                            PopUpMenuType
                                                                .block) {
                                                          profileConnectionActionCubit
                                                              .toggleBlockUser(
                                                                  widget
                                                                      .userid);
                                                        }
                                                      },
                                                    );
                                                  },
                                                )
                                              : const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: const Color.fromRGBO(245, 245, 245, 1),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                              child: ProfileConnectionActionWidget(
                                neighboursId: neighboursProfile.id,
                                isOfficial: isOfficial,
                                isBlockedByYou: neighboursProfilePosts
                                    .profileDetailsModel.isBlockedByYou,
                                isBlockedByNeighbour:
                                    neighboursProfilePosts
                                        .profileDetailsModel
                                        .isBlockedByNeighbour,
                                allowOtherUserToSendMessage: neighboursProfilePosts.allowUserToSendMessage,
                                isFollowing: neighboursProfilePosts.isFollowing,
                                isFollowedByViewedUser: neighboursProfilePosts.isFollowedByViewedUser,
                                isFollowingViewedUser: neighboursProfilePosts.isFollowingViewedUser,
                                isConnectionRequestSender:
                                    connectionDetails
                                        .isConnectionRequestSender,
                                connectionStatus:
                                    connectionDetails.connectionStatus,
                                connectionId:
                                    connectionDetails.connectionId,
                                refreshProfileDetails: () =>
                                    neighboursProfileCubit
                                        .fetchNeighboursProfile(
                                            widget.userid),
                                onChatButtonPresses: () {
                                  GoRouter.of(context).pushNamed(
                                    ChatScreen.routeName,
                                    queryParameters: {
                                      "receiver_user_id":
                                          neighboursProfile.id
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(!isOfficial)
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        child: SnaplocalAchievements(
                          userId: widget.userid,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: ThemeDivider(height: 5)),
                    SliverToBoxAdapter(
                      child: ProfilePostViewTabWidget(
                        onTabChange: (postViewType) {
                          this.postViewType = postViewType;

                          //Fetch the posts based on the selected tab
                          neighboursPostsCubit.fetchSocialPosts(
                            postViewType,
                            userId: widget.userid,
                            showLoading: true,
                          );
                        },
                        tabViewBuilder: (tabController) => BlocBuilder<
                            NeighboursPostsCubit, NeighboursPostsState>(
                          builder: (context, neighboursPostsState) {
                            if (neighboursPostsState.dataLoading) {
                              return postViewType == PostViewType.photos ||
                                      postViewType == PostViewType.videos
                                  ? const SquareGridShimmerBuilder(gridCount: 3)
                                  : const PostListShimmer(scrollable: true);
                            } else {
                              return postViewType == PostViewType.photos ||
                                      postViewType == PostViewType.videos
                                  ? SocialPostGridBuilder(
                                      allowNavigation: false,
                                      socialPostsModel:
                                          neighboursPostsState.posts,
                                    )
                                  : SocialPostListBuilder(
                                      allowNavigation: false,
                                      socialPostsModel:
                                          neighboursPostsState.posts,
                                    );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ProfileDetailsWidgetShimmer(circleSize: 100),
              ProfileActionShimmer(),
            ],
          ),
        ),
        SizedBox(height: 20),
        PostListShimmer(scrollable: true),
      ],
    );
  }
}
