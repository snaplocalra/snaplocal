import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_banners/home_banners_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_feed_posts/home_feed_posts_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/profile_fill_dialog/widget/show_profile_fill_dialog.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/banner_shimmer.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/banners_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/home_create_post_widget.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/regular_post_screen.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_icon_widget.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
import 'package:snap_local/common/utils/local_notification/widgets/notification_bell.dart';
import 'package:snap_local/common/utils/widgets/application_name_header.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';
import 'package:snap_local/utility/storage/cache/logic/cache_cubit.dart';
import 'package:snap_local/utility/storage/cache/manager/media_cache_manager.dart';

import '../../../../common/social_media/post/video_feed/screens/video_screen.dart';
import '../../../../tutorial_screens/home_tutorial_screen.dart';
import '../../../../utility/constant/application_colours.dart';
import '../../../../utility/tools/theme_divider.dart';
import '../widgets/profile_avatar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();
  final GlobalKey _videoFabKey = GlobalKey();
  Offset position = Offset.zero; // Will set later in initState

  DateTime? currentBackPressTime;

  //If the data is empty then stop the pagination call
  bool allowPagination = true;

  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  final homePostScrollController = ScrollController();

  void _fetchHomeData() {
    context.read<HomeBannersCubit>().fetchHomeBanners();
    context.read<HomeSocialPostsCubit>().fetchHomeSocialPosts();
  }

  // Add method to preload media from posts
  void _preloadPostMedia(List<dynamic> posts) {
    final urlToThumbnailMap = <String, String?>{};

    for (final post in posts) {
      if (post.media != null && post.media.isNotEmpty) {
        for (final media in post.media) {
          if (media.mediaType == 'video' && media.mediaUrl.isNotEmpty) {
            urlToThumbnailMap[media.mediaUrl] = media.thumbnailUrl;
          }
        }
      }
    }

    if (urlToThumbnailMap.isNotEmpty) {
      context.read<CacheCubit>().preloadUrls(urlToThumbnailMap);
    }
  }

  @override
  void initState() {
    super.initState();

    final mq = WidgetsBinding.instance.window.physicalSize /
        WidgetsBinding.instance.window.devicePixelRatio;

    position = Offset(
      mq.width - 55 - 10,
      mq.height - 55 - 100,
    );

    _fetchHomeData();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize cache first
      await context.read<CacheCubit>().initializeCache();
      
      homePostScrollController.position.isScrollingNotifier.addListener(() {
        showReactionCubit.closeReactionEmojiOption();
      });

      ManageBottomBarVisibilityOnScroll(context)
          .init(homePostScrollController);

      final profileDetails =
          context.read<ManageProfileDetailsBloc>().state.profileDetailsModel;

      if (profileDetails != null && profileDetails.showCompleteProfile) {
        Future.delayed(const Duration(minutes: 1), () async {
          if (mounted) {
            await showProfileFillDialog(context);
          }
        });
      }

      context.read<ProfileSettingsCubit>().stream.listen((state) {
        if (state.isProfileSettingModelAvailable) {
          if (mounted) {
            _fetchHomeData();
          }
        }
      });

      final prefs = await SharedPreferences.getInstance();
      final hasSeenTutorial = prefs.getBool('hasSeenHomeTutorial') ?? false;

      if (!hasSeenTutorial) {
        await Future.delayed(const Duration(seconds: 5));
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeTutorialScreen(),
            ),
          );
          await prefs.setBool('hasSeenHomeTutorial', true);
        }
      }

      // Listen to posts and preload media
      context.read<HomeSocialPostsCubit>().stream.listen((state) {
        if (state.feedPosts.socialPostList.isNotEmpty) {
          _preloadPostMedia(state.feedPosts.socialPostList);
        }
      });
    });
  }


  @override
  void dispose() {
    homePostScrollController.dispose();
    super.dispose();
  }

  Future<void> _resetScrollToTop() async {
    await scrollAnimateTo(
      scrollController: homePostScrollController,
      offset: 0,
    );
  }

  void onPopInvoked() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: tr(LocaleKeys.backAgainToExit));
      return;
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.of(context).size;
    return BlocListener<BottomBarNavigatorCubit, BottomBarNavigatorState>(
      listener: (context, bottomBarNavigationState) async {
        if (bottomBarNavigationState.isLoading &&
            bottomBarNavigationState.currentSelectedScreenIndex == 0) {
          _fetchHomeData();
          await _resetScrollToTop();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: showReactionCubit),
        ],
        child: LanguageChangeBuilder(builder: (context, _) {
          return Scaffold(
            body: NestedScrollView(
              controller: homePostScrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  backgroundColor: Colors.white,
                  floating: true,
                  snap: true,
                  toolbarHeight: mqSize.height * 0.085,
                  titleSpacing: 5,
                  title: Row(
                    children: [
                      ProfileAvatar(
                        onDataFetchCallBack: () {
                          _fetchHomeData();
                        },
                      ),
                      const SizedBox(width: 5),
                      const ApplicationNameHeader(),
                    ],
                  ),
                  actions: [
                    Center(
                      child: Row(
                        children: [
                          const NotificationBell(),
                          const ChatIconWidget(),
                          // Add cache status indicator
                          BlocBuilder<CacheCubit, CacheState>(
                            builder: (context, cacheState) {
                              if (cacheState.cacheStats.isNotEmpty) {
                                final usagePercentage = cacheState.cacheStats['usagePercentage'] as double;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Show cache stats dialog
                                      _showCacheStatsDialog(context, cacheState.cacheStats);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: usagePercentage > 80 
                                            ? Colors.red.withOpacity(0.7)
                                            : Colors.blue.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.storage,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(mqSize.height * 0.045),
                    child: Column(
                      children: [
                        const ThemeDivider(thickness: 2, height: 2),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: HomeCreatePostWidget(
                              key: _addressWithLocateMeKey,
                              searchBoxHint:
                                  LocaleKeys.whatsHappeningNeighbor,
                              onDataFetchCallBack: () {
                                _fetchHomeData();
                              },
                              onCreatePost: () {
                                GoRouter.of(context).pushNamed(
                                    RegularPostScreen.routeName,
                                    extra: {
                                      'postType': PostType.general,
                                    })
                                    .whenComplete(() {
                                  if (mounted) {
                                    _fetchHomeData();
                                  }
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                ),
              ],
              body: RefreshIndicator.adaptive(
                onRefresh: () async => _fetchHomeData(),
                child: ListView(
                  padding: EdgeInsets.only(bottom: mqSize.height * 0.02),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // //Video Button
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 10, vertical: 10),
                    //   child: ThemeElevatedButton(
                    //     buttonName: "Video Section",
                    //     onPressed: () async {
                    //       GoRouter.of(context).pushNamed(
                    //         VideoScreen.routeName,
                    //       );
                    //     },
                    //   ),
                    // ),

                    //Top banner
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: BlocBuilder<HomeBannersCubit, HomeBannersState>(
                        builder: (context, homeBannersState) {
                          if (homeBannersState.isTopBannersDataLoading) {
                            return const BannerShimmer(
                                bannerShimmerWidth: 0.36);
                          } else {
                            // return const Text('Home page banners');
                            return BannersWidget(
                              bannersList:
                                  homeBannersState.homeBanners.topBannersList,
                              width: 120,
                              height: 120,
                            );
                          }
                        },
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) => const HomeScreenNew(),
                    //     ),
                    //     );
                    //   },
                    //   child: const Text('View New Layouts'),
                    // ),
                    // const SizedBox(height: 8),
                    //Feed posts
                    BlocBuilder<HomeSocialPostsCubit, HomeSocialPostsState>(
                      builder: (context, homePostsState) {
                        final logs = homePostsState.feedPosts.socialPostList;
                        if (homePostsState.error != null) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                homePostsState.error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        } else if (homePostsState.dataLoading) {
                          return const PostListShimmer();
                        } else if (logs.isEmpty) {
                          allowPagination = false;
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: EmptyDataPlaceHolder(
                              emptyDataType: EmptyDataType.post,
                            ),
                          );
                        } else {
                          allowPagination = true;
                          return SocialPostListBuilder(
                            hideEmptyPlaceHolder: true,
                            showBottomDivider: false,
                            enableVisibilityPaginationDataCallBack: true,
                            visibilityDetectorKeyValue:
                                "home-feed-post-pagination-loading-key",
                            socialPostsModel: homePostsState.feedPosts,
                            onRemoveItemFromList: (index) {
                              context
                                  .read<HomeSocialPostsCubit>()
                                  .removePost(index);
                            },
                            onPaginationDataFetch: () {
                              context
                                  .read<HomeSocialPostsCubit>()
                                  .fetchHomeSocialPosts(loadMoreData: true);
                            },
                          );
                        }
                      },
                    ),

                    //Bottom banner
                    BlocBuilder<HomeBannersCubit, HomeBannersState>(
                      builder: (context, homeBannersState) {
                        if (homeBannersState.isBottomBannersDataLoading) {
                          return const BannerShimmer(bannerShimmerWidth: 0.9);
                        } else {
                          return BannersWidget(
                            bannersList: homeBannersState
                                .homeBanners.bottomBannersList,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

            ),

            floatingActionButton: Builder(
              builder: (context) {
                final mq = MediaQuery.of(context).size;
                return Stack(
                  children: [
                    Positioned(
                      left: position.dx,
                      top: position.dy,
                      child: Draggable(
                        feedback: _buildFAB(),
                        childWhenDragging: const SizedBox(),
                        onDragEnd: (details) {
                          final renderBox = context.findRenderObject() as RenderBox;
                          final localOffset = renderBox.globalToLocal(details.offset);

                          setState(() {
                            final dx = localOffset.dx.clamp(10.0, mq.width - 55 - 10);
                            final dy = localOffset.dy.clamp(100.0, mq.height - 55 - 100);
                            position = Offset(dx, dy);
                          });
                        },
                        child: Showcase(
                          key: _videoFabKey,
                          title: 'Video Section',
                          description: 'Watch neighborhood videos here',
                          child: _buildFAB(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _showCacheStatsDialog(BuildContext context, Map<String, dynamic> stats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Files: ${stats['totalFiles']}'),
            Text('Size: ${(stats['totalSize'] / (1024 * 1024)).toStringAsFixed(1)} MB'),
            Text('Usage: ${stats['usagePercentage'].toStringAsFixed(1)}%'),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: stats['usagePercentage'] / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                stats['usagePercentage'] > 80 ? Colors.red : Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CacheCubit>().clearCache();
              Navigator.of(context).pop();
            },
            child: const Text('Clear Cache'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () async {
          GoRouter.of(context).pushNamed(VideoScreen.routeName);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => TestTutorialScreen()),
          // );
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: ApplicationColours.themeBlueColor,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
          ),
          child: const Icon(Icons.play_arrow_outlined, color: Colors.white, size: 30),
        ),
      ),
    );
  }

}

// import 'dart:ui';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_banners/home_banners_cubit.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_feed_posts/home_feed_posts_cubit.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/home/profile_fill_dialog/widget/show_profile_fill_dialog.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/banner_shimmer.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/banners_widget.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/home_create_post_widget.dart';
// import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
// import 'package:snap_local/common/social_media/create/create_social_post/screen/regular_post_screen.dart';
// import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
// import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
// import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
// import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
// import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
// import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
// import 'package:snap_local/common/utils/firebase_chat/widget/chat_icon_widget.dart';
// import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
// import 'package:snap_local/common/utils/local_notification/widgets/notification_bell.dart';
// import 'package:snap_local/common/utils/widgets/application_name_header.dart';
// import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
// import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
// import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// import 'package:snap_local/utility/localization/widget/localization_builder.dart';
// import 'package:snap_local/utility/tools/scroll_animate.dart';
//
// import '../../../../common/social_media/post/video_feed/screens/video_screen.dart';
// import '../../../../utility/constant/application_colours.dart';
// import '../../../../utility/tools/theme_divider.dart';
// import '../widgets/profile_avatar_widget.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   static const routeName = 'home';
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey _addressWithLocateMeKey = GlobalKey();
//   Offset position = Offset.zero; // Will set later in initState
//
//   DateTime? currentBackPressTime;
//
//   //If the data is empty then stop the pagination call
//   bool allowPagination = true;
//   bool _showTutorial = false;
//
//   ShowReactionCubit showReactionCubit = ShowReactionCubit();
//
//   final homePostScrollController = ScrollController();
//
//   void _fetchHomeData() {
//     context.read<HomeBannersCubit>().fetchHomeBanners();
//     context.read<HomeSocialPostsCubit>().fetchHomeSocialPosts();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkFirstTime();
//     final mq = WidgetsBinding.instance.window.physicalSize /
//         WidgetsBinding.instance.window.devicePixelRatio;
//
//     position = Offset(
//       mq.width - 55 - 10, // width of FAB + margin
//       mq.height - 55 - 100, // height of FAB + bottom margin
//     );   //Initial Home data fetcher method called on the bottom bar
//     _fetchHomeData();
//
//     //Listening for the scrolling speed
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       homePostScrollController.position.isScrollingNotifier.addListener(() {
//         //When scrolling ensure that, the reaction option is close
//         showReactionCubit.closeReactionEmojiOption();
//       });
//
//       //Manage the bottom bar visibility on scroll
//       ManageBottomBarVisibilityOnScroll(context).init(homePostScrollController);
//
//       //Get the profile details
//       final profileDetails =
//           context.read<ManageProfileDetailsBloc>().state.profileDetailsModel;
//
//       //Check if the profile details are available and the known languages are empty
//       if (profileDetails != null && profileDetails.showCompleteProfile) {
//         //After 10 seconds of the app launch, show the profile fill dialog
//         Future.delayed(const Duration(minutes: 1), () async {
//           if (mounted) {
//             await showProfileFillDialog(context);
//           }
//         });
//       }
//
//       //Listening for the profile settings change and fetch data accordingly
//       context.read<ProfileSettingsCubit>().stream.listen((state) {
//         if (state.isProfileSettingModelAvailable) {
//           if (mounted) {
//             //Fetch home data
//             _fetchHomeData();
//           }
//         }
//       });
//     });
//   }
//
//
//   Future<void> _checkFirstTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isFirstTime = prefs.getBool('seenTestTutorial') ?? true;
//
//     //if (isFirstTime) {
//     await Future.delayed(Duration(seconds: 5));
//     setState(() {
//       _showTutorial = true;
//     });
//     prefs.setBool('seenTestTutorial', false);
//     // }
//   }
//
//   void _dismissTutorial() {
//     setState(() {
//       _showTutorial = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     homePostScrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _resetScrollToTop() async {
//     await scrollAnimateTo(
//       scrollController: homePostScrollController,
//       offset: 0,
//     );
//   }
//
//   void onPopInvoked() {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       Fluttertoast.showToast(msg: tr(LocaleKeys.backAgainToExit));
//       return;
//     }
//     SystemNavigator.pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mqSize = MediaQuery.of(context).size;
//     return BlocListener<BottomBarNavigatorCubit, BottomBarNavigatorState>(
//       listener: (context, bottomBarNavigationState) async {
//         if (bottomBarNavigationState.isLoading &&
//             bottomBarNavigationState.currentSelectedScreenIndex == 0) {
//           _fetchHomeData();
//           await _resetScrollToTop();
//         }
//       },
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: showReactionCubit),
//         ],
//         child: LanguageChangeBuilder(builder: (context, _) {
//           return Scaffold(
//             body: Stack(
//               children: [
//                 NestedScrollView(
//                   controller: homePostScrollController,
//                   headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                     SliverAppBar(
//                       systemOverlayStyle: const SystemUiOverlayStyle(
//                         statusBarColor: Colors.white,
//                         statusBarIconBrightness: Brightness.dark,
//                       ),
//                       backgroundColor: Colors.white,
//                       floating: true,
//                       snap: true,
//                       toolbarHeight: mqSize.height * 0.085,
//                       titleSpacing: 5,
//                       title: Row(
//                         children: [
//                           ProfileAvatar(
//                             onDataFetchCallBack: () {
//                               _fetchHomeData();
//                             },
//                           ),
//                           const SizedBox(width: 5),
//                           const ApplicationNameHeader(),
//                         ],
//                       ),
//                       actions: const [
//                         Center(
//                           child: Row(
//                             children: [NotificationBell(), ChatIconWidget()],
//                           ),
//                         )
//                       ],
//                       bottom: PreferredSize(
//                         preferredSize: Size.fromHeight(mqSize.height * 0.045),
//                         child: Column(
//                           children: [
//                             const ThemeDivider(thickness: 2, height: 2),
//                             Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 child: HomeCreatePostWidget(
//                                   key: _addressWithLocateMeKey,
//                                   searchBoxHint:
//                                   LocaleKeys.whatsHappeningNeighbor,
//                                   onDataFetchCallBack: () {
//                                     _fetchHomeData();
//                                   },
//                                   onCreatePost: () {
//                                     GoRouter.of(context).pushNamed(
//                                         RegularPostScreen.routeName,
//                                         extra: {
//                                           'postType': PostType.general,
//                                         }).whenComplete(() {
//                                       if (mounted) {
//                                         _fetchHomeData();
//                                       }
//                                     });
//                                   },
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                   body: RefreshIndicator.adaptive(
//                     onRefresh: () async => _fetchHomeData(),
//                     child: ListView(
//                       padding: EdgeInsets.only(bottom: mqSize.height * 0.02),
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         // //Video Button
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(
//                         //       horizontal: 10, vertical: 10),
//                         //   child: ThemeElevatedButton(
//                         //     buttonName: "Video Section",
//                         //     onPressed: () async {
//                         //       GoRouter.of(context).pushNamed(
//                         //         VideoScreen.routeName,
//                         //       );
//                         //     },
//                         //   ),
//                         // ),
//
//                         //Top banner
//                         SizedBox(height: 10,),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 2),
//                           child: BlocBuilder<HomeBannersCubit, HomeBannersState>(
//                             builder: (context, homeBannersState) {
//                               if (homeBannersState.isTopBannersDataLoading) {
//                                 return const BannerShimmer(
//                                     bannerShimmerWidth: 0.36);
//                               } else {
//                                 // return const Text('Home page banners');
//                                 return BannersWidget(
//                                   bannersList:
//                                   homeBannersState.homeBanners.topBannersList,
//                                   width: 120,
//                                   height: 120,
//                                 );
//                               }
//                             },
//                           ),
//                         },
//                         // ElevatedButton(
//                         //   onPressed: () {
//                         //     Navigator.of(context).push(
//                         //     MaterialPageRoute(
//                         //       builder: (context) => const HomeScreenNew(),