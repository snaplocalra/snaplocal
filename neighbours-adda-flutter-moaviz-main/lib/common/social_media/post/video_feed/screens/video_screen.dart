import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/post_reaction_details/post_reaction_details_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/post_reaction_details_model.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/video_feed/logic/video_feed_posts/video_feed_posts_cubit.dart';
import 'package:snap_local/common/social_media/post/video_feed/widgets/video_shimmer.dart';
import 'package:snap_local/common/social_media/post/video_feed/widgets/video_page_view_builder.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';
import 'package:snap_local/utility/storage/cache/logic/cache_cubit.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';

import '../../../../../bottom_bar/bottom_bar_modules/home/profile_fill_dialog/widget/show_profile_fill_dialog.dart';
import '../../master_post/model/post_type_enum.dart';
import '../../modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import '../../modules/social_post_reaction/repository/emoji_repository.dart';
import '../widgets/comment_sheet.dart';

class VideoScreen extends StatefulWidget {
  final int? index;
  const VideoScreen({super.key, this.index});

  static const routeName = 'video';
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();
  ShowReactionCubit showReactionCubit = ShowReactionCubit();
  ShareCubit shareCubit = ShareCubit();
  late PostReactionDetailsCubit postReactionDetailsCubit = PostReactionDetailsCubit(context.read<ReactionRepository>());
  late GiveReactionCubit giveReactionCubit = GiveReactionCubit(context.read<ReactionRepository>());

  DateTime? currentBackPressTime;

  //If the data is empty then stop the pagination call
  bool allowPagination = true;

  void _fetchVideoData() {
    context.read<VideoSocialPostsCubit>().fetchVideoPosts();
  }

  void _preloadNextVideos(int currentIndex) {
    final posts = context.read<VideoSocialPostsCubit>().state.feedPosts.socialPostList;
    final urlToThumbnailMap = <String, String?>{};

    // Preload next 3 videos
    for (int i = 1; i <= 3; i++) {
      final nextIndex = currentIndex + i;
      if (nextIndex < posts.length) {
        final post = posts[nextIndex];
        if (post.media.isNotEmpty && post.media.first.mediaType == 'video') {
          urlToThumbnailMap[post.media.first.mediaUrl] = post.media.first.thumbnail;
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

    //Initial Home data fetcher method called on the bottom bar
    _fetchVideoData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openCommentsBottomSheet({
    required SocialPostModel post,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentBottomSheet(
        post: post,
      ),
    );
  }

  // void onReact({
  //   required ReactionEmojiModel reactionEmoji,
  //   bool removeReaction = false,
  //   required bool isFirstReaction,
  //   required String postId,
  //   required PostFrom postFrom,
  //   required PostType postType,
  // }) async {
  //   //Close the reaction option widget
  //   await context
  //       .read<ShowReactionCubit>()
  //       .closeReactionEmojiOption()
  //       .whenComplete(() async {
  //     if (!removeReaction) {
  //       HapticFeedback.lightImpact();
  //       // context.read<ReactionAudioEffectControllerCubit>().playReactionSound();
  //     }
  //
  //     //Reaction call back to update on the UI
  //     context
  //         .read<PostDetailsControllerCubit>()
  //         .postStateUpdate(UpdateReactionState(
  //       removeReaction ? null : reactionEmoji,
  //       isFirstReaction,
  //     ));
  //
  //     //Api call
  //     await giveReactionCubit.givePostReaction(
  //       postId: postId,
  //       postFrom: postFrom,
  //       postType: postType,
  //       reactionId: reactionEmoji.id,
  //     );
  //   });
  // }


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
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: showReactionCubit),
            BlocProvider.value(value: postReactionDetailsCubit),
            BlocProvider.value(value: giveReactionCubit),
            BlocProvider.value(value: shareCubit),
          ],
          child: BlocBuilder<VideoSocialPostsCubit, VideoSocialPostsState>(
            builder: (context, videoPostsState) {
              final logs = videoPostsState.feedPosts.socialPostList;
              if (videoPostsState.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      videoPostsState.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              } else if (videoPostsState.dataLoading) {
                return const VideoPlayerItemShimmer();
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
        
                return SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: VideoPageViewBuilder(
                    index: widget.index,
                    hideEmptyPlaceHolder: true,
                    showBottomDivider: false,
                    enableVisibilityPaginationDataCallBack: true,
                    visibilityDetectorKeyValue: "home-feed-post-pagination-loading-key",
                    socialPostsModel: videoPostsState.feedPosts,
                    onPageChanged: (index) {
                      _preloadNextVideos(index);
                    },
                    // onCommentTap: (post) {
                    //   _openCommentsBottomSheet(
                    //     post: post,
                    //   );
                    // },
                    // onReact: (postDetails,reactionEmoji, removeReaction) {
                    //   // onReact(
                    //   //   reactionEmoji: reactionEmoji,
                    //   //   isFirstReaction: postDetails.reactionEmojiModel == null,
                    //   //   postId: postDetails.id,
                    //   //   postFrom: postDetails.postFrom,
                    //   //   postType: postDetails.postType,
                    //   //   removeReaction: removeReaction,
                    //   // );
                    // },
                    // onRemoveItemFromList: (index) {
                    //   context
                    //       .read<VideoSocialPostsCubit>()
                    //       .removePost(index);
                    // },
                    onPaginationDataFetch: () {
                      context
                          .read<VideoSocialPostsCubit>()
                          .fetchVideoPosts(loadMoreData: true);
                    },
                  ),
                );
            }
            },
          ),
        ),
      ),
    );
  }
}
