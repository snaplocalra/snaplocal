import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_groups/home_local_groups_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_pages/home_local_pages_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_buy_sell/local_buy_sell_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_connections/local_connections_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_events/local_events_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_jobs/local_jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_news/local_news_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_offers/local_offers_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_events_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_groups_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_news_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_pages_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/buy_sell_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_connections_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_jobs_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/local_videos_section.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/local_widgets/offers_section.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_index_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:snap_local/utility/storage/cache/logic/cache_cubit.dart';

class SocialPostListBuilder extends StatefulWidget {
  const SocialPostListBuilder({
    super.key,
    this.socialPostsModel,
    this.hideEmptyPlaceHolder = false,
    this.socialPostList,
    this.physics,
    this.onPaginationDataFetch,
    this.visibilityDetectorKeyValue,
    this.padding,
    this.scrollController,
    this.allowNavigation = true,
    this.enableGroupHeaderView = true,
    this.closeReactionOnScroll = false,
    this.showBottomDivider = true,
    this.allowAction = true,
    this.onRemoveItemFromList,
    this.onRemoveByUnsaved,
    this.enableVisibilityPaginationDataCallBack = false,
    this.refreshParentData,
    this.hideBottomBarOnScroll = true,
    this.enableNewsPostAction = true,
  });

  final SocialPostsList? socialPostsModel;
  final bool hideEmptyPlaceHolder;
  final List<SocialPostModel>? socialPostList;
  final void Function()? onPaginationDataFetch;
  final void Function(int index)? onRemoveItemFromList;
  final void Function(int index)? onRemoveByUnsaved;
  final String? visibilityDetectorKeyValue;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;

  ///If true then onPaginationDataFetch will call if the bottom widget visible
  final bool enableVisibilityPaginationDataCallBack;
  final EdgeInsetsGeometry? padding;

  //Actions
  final bool allowNavigation;
  final bool enableGroupHeaderView;
  final bool closeReactionOnScroll;
  final bool showBottomDivider;
  final bool allowAction;

  final void Function()? refreshParentData;

  //Bottom bar visibility on scroll
  final bool hideBottomBarOnScroll;

  //News post action
  final bool enableNewsPostAction;

  @override
  State<SocialPostListBuilder> createState() => _SocialPostListBuilderState();
}

class _SocialPostListBuilderState extends State<SocialPostListBuilder> {
  bool get paginationEnabled => widget.socialPostsModel != null;
  List<SocialPostModel> logs = [];

  bool _validateWidget() {
    if (widget.socialPostList == null && widget.socialPostsModel == null) {
      throw ("No social media data model found");
    } else if (paginationEnabled &&
        (widget.enableVisibilityPaginationDataCallBack &&
            widget.visibilityDetectorKeyValue == null)) {
      throw ("Visibility Detector KeyValue not found");
    } else if (widget.enableVisibilityPaginationDataCallBack &&
        widget.onPaginationDataFetch == null) {
      throw ("When enableVisibilityPaginationDataCallBack is true then onPaginationDataFetch() showStarMark");
    } else {
      return true;
    }
  }

  void assignDataModel() {
    if (_validateWidget()) {
      if (widget.socialPostList != null) {
        logs = widget.socialPostList!;
      } else if (widget.socialPostsModel != null) {
        logs = widget.socialPostsModel!.socialPostList;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    assignDataModel();

    if (widget.hideBottomBarOnScroll) {
      //Manage the bottom bar visibility on scroll
      ManageBottomBarVisibilityOnScroll(context).init(widget.scrollController);
    }
  }

  void _preloadNextVideos(int currentIndex) {
    final urlsToPreload = <String, String?>{};
    // Preload next 3 videos
    for (int i = 1; i <= 3; i++) {
      final nextIndex = currentIndex + i;
      if (nextIndex < logs.length) {
        final post = logs[nextIndex];
        if (post.media.isNotEmpty && post.media.first.mediaType == 'video') {
          final url = post.media.first.mediaUrl;
          final thumbnail = post.media.first.thumbnail;
          if (url.isNotEmpty) {
            urlsToPreload[url] = thumbnail;
          }
        }
      }
    }
    if (urlsToPreload.isNotEmpty) {
      context.read<CacheCubit>().preloadUrls(urlsToPreload);
    }
  }

  @override
  void didUpdateWidget(covariant SocialPostListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      assignDataModel();
    }
  }

  Widget _buildExtraWidget(int index) {
    if (widget.socialPostsModel == null) {
      return _buildPostWidget(index);
    }

    // Find the matching rule for the current index
    final matchingRule = widget.socialPostsModel!.postIndexList.firstWhere(
      (rule) => rule.displayIndex == index.toString(),
      orElse: () => PostIndexModel(postType: "group", displayIndex: "-1"),
    );

    // If no matching rule found, just return the post widget
    if (matchingRule.displayIndex == "-1") {
      return _buildPostWidget(index);
    }

    // Return the appropriate widget based on post type
    switch (matchingRule.postType) {
      case "group":
        return Column(
          children: [
            const LocalGroupsSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );
      case "buy_sell":
        return Column(
              children: [
                const BuyAndSellSection(),
                const SizedBox(height: 16),
                _buildPostWidget(index),
              ],
            );
      case "page":
        return Column(
          children: [
            const LocalPagesSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );
      case "job":
        return Column(
          children: [
            const LocalJobsSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );
      case "offers":
        return Column(
          children: [
            const OffersNearYouSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );
      case "connections":
        return Column(
          children: [
            const ConnectionsSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );
      case "event":
        return Column(
          children: [
            const LocalEventsSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );

      case "news":
        return Column(
          children: [
            const LocalNewsSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );

      case "video":
        return Column(
          children: [
            const LocalVideosSection(),
            const SizedBox(height: 16),
            _buildPostWidget(index),
          ],
        );

      default:
        return _buildPostWidget(index);
    }
  }

  Widget demoWidget() {
    // Show all sections in one column
    return Column(
      children: [
        // Groups Section
        // VisibilityDetector(
        //   key: const Key('local_groups_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<HomeLocalGroupsCubit>().fetchHomeLocalGroups();
        //     }
        //   },
        //   child: const LocalGroupsSection(),
        // ),
        // const SizedBox(height: 16),

        // // Buy & Sell Section
        // VisibilityDetector(
        //   key: const Key('buy_sell_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<LocalBuyAndSellCubit>().fetchLocalBuyAndSellItems();
        //     }
        //   },
        //   child: const BuyAndSellSection(),
        // ),
        // const SizedBox(height: 16),

        // // Pages Section
        // VisibilityDetector(
        //   key: const Key('local_pages_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<HomeLocalPagesCubit>().fetchHomeLocalPages();
        //     }
        //   },
        //   child: const LocalPagesSection(),
        // ),
        // const SizedBox(height: 16),

        // // Jobs Section
        // VisibilityDetector(
        //   key: const Key('local_jobs_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<LocalJobsCubit>().fetchLocalJobs();
        //     }
        //   },
        //   child: const LocalJobsSection(),
        // ),
        // const SizedBox(height: 16),

        // // Offers Section
        // VisibilityDetector(
        //   key: const Key('local_offers_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<LocalOffersCubit>().fetchLocalOffers();
        //     }
        //   },
        //   child: const OffersNearYouSection(),
        // ),
        // const SizedBox(height: 16),

        // Connections Section
        // const ConnectionsSection(),
        // const SizedBox(height: 16),

        // LocalEventsSection(),
        // const SizedBox(height: 16),

        LocalNewsSection(),
        const SizedBox(height: 16),
        // // Events Section
        // VisibilityDetector(
        //   key: const Key('local_events_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<LocalEventsCubit>().fetchLocalEvents();
        //     }
        //   },
        //   child: const LocalEventsSection(),
        // ),
        // const SizedBox(height: 16),

        // // News Section
        // VisibilityDetector(
        //   key: const Key('local_news_section'),
        //   onVisibilityChanged: (visibilityInfo) {
        //     var visiblePercentage = visibilityInfo.visibleFraction * 100;
        //     if (visiblePercentage >= 60) {
        //       context.read<LocalNewsCubit>().fetchLocalNews();
        //     }
        //   },
        //   child: const LocalNewsSection(),
        // ),
        // const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPostWidget(int index) {
    return Column(
      children: [
        Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 2),
          child: PostViewWidget(
            enableGroupHeaderView: widget.enableGroupHeaderView,
            allowNavigation: widget.allowNavigation,
            allowPostDetailsOpen: true,
            refreshParentData: widget.refreshParentData,
            enableNewsPostAction: widget.enableNewsPostAction,
          ),
        ),
        Visibility(
          visible: widget.showBottomDivider,
          child: const ThemeDivider(height: 2, thickness: 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return (logs.isEmpty)
        ? widget.hideEmptyPlaceHolder
            ? const SizedBox.shrink()
            : const Center(
                child: EmptyDataPlaceHolder(
                  emptyDataType: EmptyDataType.post,
                ),
              )
        : ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: widget.physics ?? const NeverScrollableScrollPhysics(),
            itemCount: paginationEnabled ? logs.length + 1 : logs.length,
            itemBuilder: (context, index) {
              if (!paginationEnabled || index < logs.length) {
                // Trigger preloading for next videos
                _preloadNextVideos(index);

                //Post details
                final postDetails = logs[index];

                //Post Action cubit
                final postActionCubit = PostActionCubit(PostActionRepository());

                final postDetailsControllerCubit = PostDetailsControllerCubit(socialPostModel: postDetails);

                //Report cubit
                final reportCubit = ReportCubit(ReportRepository());

                //comment view controller cubit
                final commentViewControllerCubit = CommentViewControllerCubit();

                //Hide post cubit
                final HidePostCubit hidePostCubit =
                    HidePostCubit(HidePostRepository());

                return MultiBlocProvider(
                  key: ValueKey(postDetails.id),
                  providers: [
                    BlocProvider.value(value: postDetailsControllerCubit),
                    BlocProvider.value(value: postActionCubit),
                    BlocProvider.value(value: reportCubit),
                    BlocProvider.value(value: commentViewControllerCubit),
                    BlocProvider.value(value: hidePostCubit),
                  ],
                  child: Builder(builder: (context) {
                    return BlocListener<PostDetailsControllerCubit,
                        PostDetailsControllerState>(
                      listener: (context, postDetailsControllerState) {
                        if (postDetailsControllerState.removeItemFromList) {
                          widget.onRemoveItemFromList?.call(index);
                        } else if (postDetailsControllerState.removeByUnsaved) {
                          widget.onRemoveByUnsaved?.call(index);
                        }
                      },
                      child: _buildExtraWidget(index),
                      // child: Column(children: [
                      //   index == 0 ? demoWidget() : _buildPostWidget(index),
                      // ]),
                    );
                  }),
                );
              } else {
                if (widget.socialPostsModel!.paginationModel.isLastPage) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: SizedBox.shrink(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: widget.enableVisibilityPaginationDataCallBack
                        ? VisibilityDetector(
                            key: Key(widget.visibilityDetectorKeyValue!),
                            onVisibilityChanged: (visibilityInfo) {
                              var visiblePercentage =
                                  visibilityInfo.visibleFraction * 100;
                              if (visiblePercentage >= 60) {
                                if (widget.onPaginationDataFetch != null) {
                                  widget.onPaginationDataFetch!.call();
                                }
                              }
                            },
                            child: const ThemeSpinner(size: 40),
                          )
                        : const ThemeSpinner(size: 40),
                  );
                }
              }
            },
          );
  }
}
