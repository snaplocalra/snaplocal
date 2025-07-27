import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../bottom_bar/bottom_bar_modules/news/modules/news_post_details/screen/news_post_view_details_screen.dart';
import '../../../../../generated/codegen_loader.g.dart';
import '../../../../../home_route.dart';
import '../../../../../utility/constant/application_colours.dart';
import '../../../../../utility/constant/assets_images.dart';
import '../../../../../utility/router/check_current_route.dart';
import '../../../../utils/hide/logic/hide_post/hide_post_cubit.dart';
import '../../../../utils/post_action/logic/post_action/post_action_cubit.dart';
import '../../../../utils/report/logic/report/report_cubit.dart';
import '../../../../utils/share/logic/share/share_cubit.dart';
import '../../../../utils/share/model/share_type.dart';
import '../../../../utils/widgets/block_status.dart';
import '../../../../utils/widgets/svg_button_text_widget.dart';
import '../../../../utils/widgets/svg_button_widget.dart';
import '../../../create/create_social_post/screen/regular_post_screen.dart';
import '../../action_dialog/widgets/post_action_3_dot_button_widget.dart';
import '../../master_post/model/categories_view/news_post_model.dart';
import '../../master_post/model/post_action_permission.dart';
import '../../master_post/model/post_type_enum.dart';
import '../../master_post/model/social_post_model.dart';
import '../../modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import '../../modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import '../../modules/social_post_reaction/model/emoji_static_data.dart';
import '../../modules/social_post_reaction/model/reaction_emoji_model.dart';
import '../../modules/social_post_reaction/repository/emoji_repository.dart';
import '../../modules/social_post_reaction/widgets/post_reaction_details_dialog.dart';
import '../../modules/social_post_reaction/widgets/reaction_widget.dart';
import '../../post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import '../../post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import '../../post_details/models/post_from_enum.dart';
import '../../post_details/models/post_state_update/update_close_poll_state.dart';
import '../../post_details/models/post_state_update/update_comment_permission_state.dart';
import '../../post_details/models/post_state_update/update_reaction_state.dart';
import '../../post_details/models/post_state_update/update_share_permission_state.dart';
import '../../post_details/screens/post_details_view_screen.dart';
import '../../post_details/widgets/post_view/circular_counter.dart';
import '../../shared_social_post/model/share_post_data_model.dart';
import '../../shared_social_post/screen/share_post_details_screen.dart';
import 'comment_sheet.dart';

class VideoPlayerItem extends StatefulWidget {
  final void Function() onProfileTap;
  final String mediaUrl;
  final String views;
  final SocialPostModel post;

  const VideoPlayerItem({
    super.key, required this.onProfileTap, required this.mediaUrl, required this.views, required this.post,
  });

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late GiveReactionCubit giveReactionCubit = GiveReactionCubit(context.read<ReactionRepository>());
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  String views = "0";
  bool _hasReportedView = false;

  // Shared global mute state
  static bool _globalMuted = true;

  // Local override
  bool _localMuted = true;

  @override
  void initState() {
    super.initState();
    views=widget.views;
    // Ensure all videos start muted initially
    _localMuted = _globalMuted;

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.mediaUrl),
    )..initialize().then((_) {
      setState(() {
        _isInitialized = true;
        _isPlaying = true;
      });
      _controller.play();
      _controller.setLooping(true);
      _controller.setVolume(_localMuted ? 0 : 1);
      _controller.addListener(_videoProgressListener); // Start view check
    });
  }

  void _videoProgressListener() {
    if (!_hasReportedView &&
        _controller.value.isInitialized &&
        _controller.value.position.inSeconds >= 3) {
      _hasReportedView = true;
      // if(int.tryParse(views)!=null){
      //   views=(int.tryParse(views)!+1).toString();
      // }
      setState(() {});
      onViewVideo(post: widget.post, postId: widget.post.id, postType: widget.post.postType);
    }
  }

  void _toggleMute() {
    setState(() {
      if (_localMuted) {
        // Unmuting this video => unmute all
        _globalMuted = false;
        _localMuted = false;
        _syncAllVolumes(unmute: true);
      } else {
        // Muting this video only
        _localMuted = true;
        _controller.setVolume(0);
      }
    });
  }


  void _syncAllVolumes({required bool unmute}) {
    // You need to use some global video manager if multiple instances are involved
    // For now, we're just updating global state
    _controller.setVolume(unmute ? 1 : 0);
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

  void onReact({
    required ReactionEmojiModel reactionEmoji,
    bool removeReaction = false,
    required bool isFirstReaction,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    //Close the reaction option widget
    await context
        .read<ShowReactionCubit>()
        .closeReactionEmojiOption()
        .whenComplete(() async {
      if (!removeReaction) {
        HapticFeedback.lightImpact();
        // context.read<ReactionAudioEffectControllerCubit>().playReactionSound();
      }

      //Reaction call back to update on the UI
      context
          .read<PostDetailsControllerCubit>()
          .postStateUpdate(UpdateReactionState(
        removeReaction ? null : reactionEmoji,
        isFirstReaction,
      ));

      //Api call
      await giveReactionCubit.givePostReaction(
        postId: postId,
        postFrom: postFrom,
        postType: postType,
        reactionId: reactionEmoji.id,
      );
    });
  }

  void onViewVideo({
    required SocialPostModel post,
    required String postId,
    required PostType postType,
  }) async {
    // context
    //     .read<PostDetailsControllerCubit>()
    //     .postStateUpdate(UpdatePostState(
    //   post
    // ));

    //Api call
    context
        .read<PostActionCubit>()
        .viewSocialPost(
      postId: postId,
      postType: postType,
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

  void removeFromList() {
    context.read<CommentViewControllerCubit>().disableCommentView();
    context.read<ShowReactionCubit>().closeReactionEmojiOption();
    context.read<PostDetailsControllerCubit>().removeItemFromList();
  }

  void openPostDetails(SocialPostModel postDetails) {
    ///////////////////////////
    //Close the reaction option widget if the user touch the post widget
    context
        .read<ShowReactionCubit>()
        .closeReactionEmojiOption()
        .whenComplete(() {
      if (mounted) {
        //Navigate to the shared post details screen to
        //load the post details with new state
        final sharePostLinkData = SharedPostDataModel(
          postId: postDetails.id,
          postType: postDetails.postType,
          postFrom: postDetails.postFrom,
          shareType: ShareType.general,
        );

        GoRouter.of(context).pushNamed(
          GeneralSharedSocialPostDetails.routeName,
          extra: sharePostLinkData,
        );
      } else {
        //Navigate to the post details screen
        navigateToPostDetails(postDetails);
      }
    });
  }

  void navigateToPostDetails(SocialPostModel postDetails) {
    if (postDetails is NewsPostModel) {
      GoRouter.of(context).pushNamed(
        NewsPostViewDetailsScreen.routeName,
        queryParameters: {"id": postDetails.id},
        extra: {
          'postDetailsControllerCubit':
          context.read<PostDetailsControllerCubit>(),
          'showReactionCubit': context.read<ShowReactionCubit>(),
          'postActionCubit': context.read<PostActionCubit>(),
          'reportCubit': context.read<ReportCubit>(),
          'commentViewControllerCubit':
          context.read<CommentViewControllerCubit>(),
          'hidePostCubit': context.read<HidePostCubit>(),
        },
      ).then((value) {
        //This is a temporary solution to close the post details screen and
        //run the fetch data function in the parent screen

      });
    } else {
      GoRouter.of(context).pushNamed(
        PostDetailsViewScreen.routeName,
        extra: <String, dynamic>{
          "reportCubit": context.read<ReportCubit>(),
          "postActionCubit": context.read<PostActionCubit>(),
          "postDetailsControllerCubit":
          context.read<PostDetailsControllerCubit>(),
          "showReactionCubit": context.read<ShowReactionCubit>(),
          "commentViewControllerCubit":
          context.read<CommentViewControllerCubit>(),
          "hidePostCubit": context.read<HidePostCubit>(),
        },
      ).then((value) {
        //This is a temporary solution to close the post details screen and
        //run the fetch data function in the parent screen

      });
    }
  }





  @override
  void dispose() {
    _controller.removeListener(_videoProgressListener);
    _controller.dispose();
    super.dispose();
  }

  final int followersCount= 0;


  @override
  Widget build(BuildContext context) {

    String getLastTwoCommaWords(String? address) {
      if (address == null || address.trim().isEmpty) return '';
      final parts = address.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final count = parts.length;
      if (count >= 2) {
        return '${parts[count - 2]}, ${parts[count - 1]}';
      } else {
        return parts.last;
      }
    }

    return MultiBlocProvider(
      providers: [BlocProvider.value(value: giveReactionCubit)],
      child: BlocBuilder<PostDetailsControllerCubit, PostDetailsControllerState>(
        builder: (context, postDetailsState) {
          final postDetails = postDetailsState.socialPostModel;

          final hidePost = postDetails.groupPageInfo != null &&
              (postDetails.groupPageInfo!.blockedByAdmin ||
                  postDetails.groupPageInfo!.blockedByUser)
              ? true
              : false;

          return hidePost
              ? Center(
            child: BlockStatus(
              //page block status
              blockedByAdmin: postDetails.groupPageInfo!.blockedByAdmin,
              blockedByUser: postDetails.groupPageInfo!.blockedByUser,
              isAdmin: postDetails.groupPageInfo!.postAdmin,
              blockedByPageAdminMessage:
              tr(LocaleKeys.thisPostIsNotAvailable),
              blockedByUserMessage: tr(LocaleKeys.youcantviewthispost),
            ),
          )
              : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  _isPlaying = false;
                } else {
                  _controller.play();
                  _isPlaying = true;
                }
              });
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cached thumbnail as background
                CachedNetworkImage(
                  imageUrl: postDetails.media.first.thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.black), // Hide default placeholder
                  errorWidget: (context, url, error) => Container(color: Colors.black),
                ),

                // Show loading indicator above thumbnail while initializing video
                if (!_isInitialized)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ApplicationColours.themePinkColor),
                    ),
                  ),

                // Show video player when initialized
                if (_isInitialized)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),

                // Play/Pause button in center
                // Show play icon ONLY when paused
                if (!_isPlaying && _isInitialized)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                    ),
                  ),

                Stack(
                  children: [
                    // Close button at top-right
                    Positioned(
                      top: 40,
                      left: 20,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(); // or trigger a callback
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white,size: 20),
                            ),
                          ),
                          SizedBox(height: 25,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(5),
                              ),
                            child: Row(
                              children: [
                                const Icon(Icons.remove_red_eye, color: Colors.white,size: 20),
                                SizedBox(width: 5,),
                                Text(
                                  views,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 40,
                      right: 20,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _toggleMute,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _localMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: BlocListener<HidePostCubit, HidePostState>(
                              listener: (context, hidePostState) {
                                if (hidePostState.requestLoading) {
                                  removeFromList();
                                }
                              },
                              child: BlocListener<ReportCubit, ReportState>(
                                listener: (context, reportState) {
                                  //Remove item from list if report success
                                  if (reportState.requestSuccess) {
                                    removeFromList();
                                  }
                                },
                                child: BlocListener<PostActionCubit, PostActionState>(
                                  listener: (context, postActionState) {
                                    if (postActionState.isClosePollRequestLoading) {
                                      context
                                          .read<PostDetailsControllerCubit>()
                                          .postStateUpdate(UpdateClosePollState(true));
                                    } else if (postActionState.isDeleteRequestLoading) {
                                      removeFromList();
                                    } else if (postActionState.isChangeShareRequestFailed) {
                                      //On failer reverse the status
                                      context
                                          .read<PostDetailsControllerCubit>()
                                          .postStateUpdate(UpdateSharePermissionState(
                                        postDetails.postSharePermission.opposite,
                                      ));
                                    } else if (postActionState
                                        .isChangeCommentRequestFailed) {
                                      //On failer reverse the status
                                      context
                                          .read<PostDetailsControllerCubit>()
                                          .postStateUpdate(UpdateCommentPermissionState(
                                        postDetails.postCommentPermission.opposite,
                                      ));
                                    }
                                  },
                                  child: SvgButtonWidget(
                                    svgImage: SVGAssetsImages.moreDot,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => PostAction3DotButtonWidget()
                                            .build(context, postDetails),
                                      );
                                    },
                                    svgSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom UI with user, caption, icons
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Positioned(
                    //     right: 20,
                    //     child: Container(
                    //       padding: const EdgeInsets.all(6),
                    //       decoration: BoxDecoration(
                    //           color: Colors.black54, // Semi-transparent black background
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           // reactionEmojiModel == null ?
                    //           Column(
                    //             children: [
                    //               SvgButtonTextWidget(
                    //                 onLongPress: () {
                    //                   // context.read<ShowReactionCubit>().showReactionEmojiOption(
                    //                   //   objectId: widget.post.id,
                    //                   // );
                    //                   showDialog(
                    //                     context: context,
                    //                     builder: (context) => PostReactionDetailsDialog(
                    //                       postType: widget.post.postType,
                    //                       postId: widget.post.id,
                    //                       postFrom: widget.post.postFrom,
                    //                     ),
                    //                   );
                    //                 },
                    //                 onTap: () {
                    //                   context
                    //                       .read<ShowReactionCubit>()
                    //                       .showReactionEmojiOption(objectId: widget.post.id);
                    //                 },
                    //                 svgImage: SVGAssetsImages.like,
                    //                 svgColorFilter: ColorFilter.mode(
                    //                   ApplicationColours.themePinkColor,
                    //                   BlendMode.srcIn,
                    //                 ),
                    //                 svgHeight: 30,
                    //                 svgWidth: 30,
                    //               ),
                    //               const SizedBox(height: 2),
                    //               Visibility(
                    //                 visible: widget.post.postReactionDetailsModel?.reactionCount != 0,
                    //                 child: CircularCounter(
                    //                   number: widget.post.postReactionDetailsModel?.reactionCount ?? 0,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //
                    //           //     : GestureDetector(
                    //           //   onLongPress: () {
                    //           //     context
                    //           //         .read<ShowReactionCubit>()
                    //           //         .showReactionEmojiOption(objectId: postId);
                    //           //   },
                    //           //   onTap: () async {
                    //           //     onReact.call(reactionEmojiModel!, true);
                    //           //   },
                    //           //   child: AbsorbPointer(
                    //           //     child: ConstrainedBox(
                    //           //       constraints: const BoxConstraints(maxHeight: 20),
                    //           //       child: FittedBox(
                    //           //         child: Row(
                    //           //           mainAxisAlignment: MainAxisAlignment.center,
                    //           //           mainAxisSize: MainAxisSize.min,
                    //           //           children: [
                    //           //             SvgPicture.network(
                    //           //               reactionEmojiModel!.imageUrl,
                    //           //               height: 20,
                    //           //               width: 20,
                    //           //             ),
                    //           //             const SizedBox(width: 4),
                    //           //             Text(
                    //           //               reactionEmojiModel!.name,
                    //           //               style: TextStyle(
                    //           //                 fontWeight: FontWeight.w500,
                    //           //                 color: reactionEmojiModel!.nameColor,
                    //           //               ),
                    //           //             ),
                    //           //           ],
                    //           //         ),
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //           // Text(
                    //           //   "${widget.post.postReactionDetailsModel?.reactionCount ?? "0"}",
                    //           //   style: const TextStyle(color: Colors.white),
                    //           // ),
                    //           const SizedBox(height: 10),
                    //           if(widget.post.postCommentPermission.allowComment)...[
                    //             Column(
                    //               children: [
                    //                 SvgButtonTextWidget(
                    //                   onTap: () {
                    //                     widget.onCommentTap(widget.post);
                    //                   },
                    //                   svgImage: SVGAssetsImages.homecomment,
                    //                   svgHeight: 30,
                    //                   svgWidth: 30,
                    //                   svgColorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    //                 ),
                    //                 SizedBox(height: 2,),
                    //                 Visibility(
                    //                   visible: widget.post.commentCount >= 1,
                    //                   child: CircularCounter(number: widget.post.commentCount),
                    //                 ),
                    //               ],
                    //             ),
                    //             const SizedBox(height: 10),
                    //           ],
                    //           if (widget.post.postSharePermission.allowShare)...[
                    //             SvgButtonTextWidget(
                    //               svgImage: SVGAssetsImages.whatsapp,
                    //               svgHeight: 25,
                    //               svgWidth: 25,
                    //               onTap: () async {
                    //                 //Post details
                    //                 // final postModel = context
                    //                 //     .read<PostDetailsControllerCubit>()
                    //                 //     .state
                    //                 //     .socialPostModel;
                    //
                    //                 final sharePostLinkData = SharedPostDataModel(
                    //                   postId: widget.post.id,
                    //                   postType: widget.post.postType,
                    //                   postFrom: widget.post.postFrom,
                    //                   shareType: ShareType.deepLink,
                    //                 );
                    //
                    //                 await context.read<ShareCubit>().shareOnWhatsApp(
                    //                   context,
                    //                   jsonData: sharePostLinkData.toJson(),
                    //                   screenURL:
                    //                   SharedSocialPostDetailsByLink.routeName,
                    //                   isEncrypted: true,
                    //                 );
                    //               },
                    //             ),
                    //             const SizedBox(height: 10),
                    //           ],
                    //           // Text(
                    //           //   widget.post.commentCount.toString(),
                    //           //   style: const TextStyle(color: Colors.white),
                    //           // ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: (){
                                  GoRouter.of(context).pushNamed(
                                      RegularPostScreen.routeName,
                                      extra: {
                                        'postType': PostType.general,
                                      });
                                },
                                child: Container(
                                  height: 32,
                                  width: 100,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black54, // Semi-transparent black background
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Post Video",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: SvgPicture.asset(
                                          SVGAssetsImages.postIcon,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                          height: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black54, // Semi-transparent black background
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // reactionEmojiModel == null ?
                                    // Column(
                                    //   children: [
                                    //     SvgButtonTextWidget(
                                    //       onLongPress: () {
                                    //         // context.read<ShowReactionCubit>().showReactionEmojiOption(
                                    //         //   objectId: widget.post.id,
                                    //         // );
                                    //         showDialog(
                                    //           context: context,
                                    //           builder: (context) => PostReactionDetailsDialog(
                                    //             postType: postDetails.postType,
                                    //             postId: postDetails.id,
                                    //             postFrom: postDetails.postFrom,
                                    //           ),
                                    //         );
                                    //       },
                                    //       onTap: () {
                                    //         context
                                    //             .read<ShowReactionCubit>()
                                    //             .showReactionEmojiOption(objectId: postDetails.id);
                                    //       },
                                    //       svgImage: SVGAssetsImages.like,
                                    //       svgColorFilter: ColorFilter.mode(
                                    //         ApplicationColours.themePinkColor,
                                    //         BlendMode.srcIn,
                                    //       ),
                                    //       svgHeight: 35,
                                    //       svgWidth: 35,
                                    //     ),
                                    //     const SizedBox(height: 3),
                                    //     Visibility(
                                    //       visible: postDetails.postReactionDetailsModel?.reactionCount != 0,
                                    //       child: CircularCounter(
                                    //         number: postDetails.postReactionDetailsModel?.reactionCount ?? 0,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Column(
                                      children: [
                                        if(postDetails.reactionEmojiModel != null)
                                          GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 7.0,right: 7,top: 5),
                                              child: SizedBox(
                                                height: 30,
                                                child: SvgPicture.network(
                                                  ReactionNetworkImages.like,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => PostReactionDetailsDialog(
                                                  postType: postDetails.postType,
                                                  postId: postDetails.id,
                                                  postFrom: postDetails.postFrom,
                                                ),
                                              );
                                            },
                                            onTap: () {
                                              if (postDetails.reactionEmojiModel == null) {
                                                // Default like reaction if no reaction exists
                                                final defaultReaction = ReactionEmojiList.fromMap(emojiData)
                                                    .reactionEmojiList
                                                    .first;
                                                onReact(
                                                  reactionEmoji: defaultReaction,
                                                  isFirstReaction: postDetails.reactionEmojiModel==null,
                                                  postId: postDetails.id,
                                                  postFrom: postDetails.postFrom,
                                                  postType: postDetails.postType,
                                                  removeReaction: false,
                                                );
                                              } else {
                                                // Remove reaction if already exists
                                                onReact(
                                                  reactionEmoji: postDetails.reactionEmojiModel!,
                                                  isFirstReaction: postDetails.reactionEmojiModel==null,
                                                  postId: postDetails.id,
                                                  postFrom: postDetails.postFrom,
                                                  postType: postDetails.postType,
                                                  removeReaction: true,
                                                );
                                              }
                                            },
                                          )
                                        else
                                          GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: SizedBox(
                                                height: 35,
                                                child: SvgPicture.asset(
                                                  SVGAssetsImages.like,
                                                  fit: BoxFit.fill,
                                                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn,),
                                                ),
                                              ),
                                            ),
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => PostReactionDetailsDialog(
                                                  postType: postDetails.postType,
                                                  postId: postDetails.id,
                                                  postFrom: postDetails.postFrom,
                                                ),
                                              );
                                            },
                                            onTap: () {
                                              if (postDetails.reactionEmojiModel == null) {
                                                // Default like reaction if no reaction exists
                                                final defaultReaction = ReactionEmojiList.fromMap(emojiData)
                                                    .reactionEmojiList
                                                    .first;
                                                onReact(
                                                  reactionEmoji: defaultReaction,
                                                  isFirstReaction: postDetails.reactionEmojiModel==null,
                                                  postId: postDetails.id,
                                                  postFrom: postDetails.postFrom,
                                                  postType: postDetails.postType,
                                                  removeReaction: false,
                                                );
                                              } else {
                                                // Remove reaction if already exists
                                                onReact(
                                                  reactionEmoji: postDetails.reactionEmojiModel!,
                                                  isFirstReaction: postDetails.reactionEmojiModel==null,
                                                  postId: postDetails.id,
                                                  postFrom: postDetails.postFrom,
                                                  postType: postDetails.postType,
                                                  removeReaction: true,
                                                );
                                              }
                                            },
                                          ),
                                        // SizedBox(
                                        //   height: 30,
                                        //   width: 30,
                                        //   child: SvgButtonTextWidget(
                                        //     svgImage: SVGAssetsImages.like,
                                        //     svgHeight: 35,
                                        //     svgWidth: 35,
                                        //     svgColorFilter: ColorFilter.mode(
                                        //       postDetails.reactionEmojiModel != null
                                        //           ? ApplicationColours.themePinkColor
                                        //           : Colors.white,
                                        //       BlendMode.srcIn,
                                        //     ),
                                        //     onLongPress: () {
                                        //       showDialog(
                                        //         context: context,
                                        //         builder: (context) => PostReactionDetailsDialog(
                                        //           postType: postDetails.postType,
                                        //           postId: postDetails.id,
                                        //           postFrom: postDetails.postFrom,
                                        //         ),
                                        //       );
                                        //     },
                                        //     onTap: () {
                                        //       if (postDetails.reactionEmojiModel == null) {
                                        //         // Default like reaction if no reaction exists
                                        //         final defaultReaction = ReactionEmojiList.fromMap(emojiData)
                                        //             .reactionEmojiList
                                        //             .first;
                                        //         onReact(
                                        //           reactionEmoji: defaultReaction,
                                        //           isFirstReaction: postDetails.reactionEmojiModel==null,
                                        //           postId: postDetails.id,
                                        //           postFrom: postDetails.postFrom,
                                        //           postType: postDetails.postType,
                                        //           removeReaction: false,
                                        //         );
                                        //       } else {
                                        //         // Remove reaction if already exists
                                        //         onReact(
                                        //           reactionEmoji: postDetails.reactionEmojiModel!,
                                        //           isFirstReaction: postDetails.reactionEmojiModel==null,
                                        //           postId: postDetails.id,
                                        //           postFrom: postDetails.postFrom,
                                        //           postType: postDetails.postType,
                                        //           removeReaction: true,
                                        //         );
                                        //       }
                                        //     },
                                        //   ),
                                        // ),
                                        const SizedBox(height: 6),
                                        Visibility(
                                          visible: postDetails.postReactionDetailsModel?.reactionCount != 0,
                                          child: CircularCounter(
                                            number: postDetails.postReactionDetailsModel?.reactionCount ?? 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    if(postDetails.postCommentPermission.allowComment)...[
                                      Column(
                                        children: [
                                          SvgButtonTextWidget(
                                            onTap: () {
                                              _openCommentsBottomSheet(post: postDetails);
                                            },
                                            svgImage: SVGAssetsImages.homecomment,
                                            svgHeight: 35,
                                            svgWidth: 35,
                                            svgColorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                          ),
                                          SizedBox(height: 5,),
                                          Visibility(
                                            visible: postDetails.commentCount >= 1,
                                            child: CircularCounter(number: postDetails.commentCount),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                    if (postDetails.postSharePermission.allowShare)...[
                                      SvgButtonTextWidget(
                                        svgImage: SVGAssetsImages.whatsapp,
                                        svgHeight: 30,
                                        svgWidth: 30,
                                        onTap: () async {
                                          //Post details
                                          // final postModel = context
                                          //     .read<PostDetailsControllerCubit>()
                                          //     .state
                                          //     .socialPostModel;

                                          final sharePostLinkData = SharedPostDataModel(
                                            postId: postDetails.id,
                                            postType: postDetails.postType,
                                            postFrom: postDetails.postFrom,
                                            shareType: ShareType.deepLink,
                                          );

                                          await context.read<ShareCubit>().shareOnWhatsApp(
                                            context,
                                            jsonData: sharePostLinkData.toJson(),
                                            screenURL:
                                            SharedSocialPostDetailsByLink.routeName,
                                            isEncrypted: true,
                                          );
                                        },
                                      ),
                                    ],
                                    // Text(
                                    //   widget.post.commentCount.toString(),
                                    //   style: const TextStyle(color: Colors.white),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: widget.onProfileTap,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(postDetails.postUserInfo.userImage),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: postDetails.postUserInfo.userName.length*8.2>120?120:postDetails.postUserInfo.userName.length*8.2,
                                          child: Text(
                                            postDetails.postUserInfo.userName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if(postDetails.postUserInfo.isVerified==true)...[
                                          const SizedBox(width: 5),
                                          SvgPicture.asset(
                                            SVGAssetsImages.greenTick,
                                            height: 12,
                                            width: 12,
                                          ),
                                        ],
                                        SizedBox(width: 8,),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.black54, // Semi-transparent black background
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_sharp,color: Colors.white,size: 12,),
                                        Text(
                                          "${getLastTwoCommaWords(postDetails.postLocation.address)} | ${tr(postDetails.postType.displayText)}",
                                          style: const TextStyle(color: Colors.white, fontSize: 10),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap:() => openPostDetails(postDetails),
                            child: Text(
                              postDetails.caption ?? "",
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<ShowReactionCubit, ShowReactionState>(
                      builder: (context, showReactionState) {
                        return Visibility(
                          visible: showReactionState.showEmojiOption && showReactionState.objectId == postDetails.id,
                          child: ReactionWidget(
                            postId: postDetails.id,
                            onReact: (reaction) async {
                              onReact(
                                reactionEmoji: reaction,
                                isFirstReaction: postDetails.reactionEmojiModel == null,
                                postId: postDetails.id,
                                postFrom: postDetails.postFrom,
                                postType: postDetails.postType,
                                removeReaction: false,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ) ,
              ],
            ),
          );
        },
      ),
    );
  }
}


