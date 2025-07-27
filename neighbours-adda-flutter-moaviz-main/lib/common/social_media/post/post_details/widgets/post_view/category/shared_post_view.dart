import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/shared_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_heading_with_action.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_view_bottom_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/utility/common/read_more/widget/read_more_text.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SharedPostView extends StatelessWidget {
  final SharedPostModel sharedPostModel;
  final bool verticalPostView, enableGroupHeaderView, isSharedView;

  final void Function()? onComment;
  final void Function(ReactionEmojiModel, bool) onReact;
  const SharedPostView({
    super.key,

    ///true when the post view in the post share dialog
    this.isSharedView = false,
    required this.sharedPostModel,
    this.verticalPostView = false,
    required this.onReact,
    required this.onComment,
    required this.enableGroupHeaderView,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    final postReactionDetails = sharedPostModel.postReactionDetailsModel;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Post header
          PostHeadingWithActions(
            postDetails: sharedPostModel,
            verticalPostView: verticalPostView,
            enableGroupHeaderView: enableGroupHeaderView,
            isSharedView: isSharedView,
          ),

          //Body
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Post Caption
                  Visibility(
                    visible: sharedPostModel.caption.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ReadMoreText(
                        sharedPostModel.caption,
                        readMoreText: tr(LocaleKeys.readMore),
                        readLessText: tr(LocaleKeys.readLess),
                        style: const TextStyle(
                          color: Color.fromRGBO(52, 45, 45, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  //Nested post view
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => PostDetailsControllerCubit(
                          socialPostModel: sharedPostModel.sharedPost,
                        ),
                      ),
                      //Post Action cubit
                      BlocProvider(
                        create: (context) =>
                            PostActionCubit(PostActionRepository()),
                      ),

                      //comment view controller
                      BlocProvider(
                        create: (context) => CommentViewControllerCubit(),
                      ),

                      //Hide post cubit
                      BlocProvider(
                        create: (context) => HidePostCubit(
                          HidePostRepository(),
                        ),
                      ),
                    ],
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: PostViewWidget(
                        key: ValueKey(sharedPostModel.sharedPost.id),
                        isSharedView: true,
                        allowNavigation: true,
                        allowPostDetailsOpen: true,
                      ),
                    ),
                  ),

                  //Post bottom details
                  if (!isSharedView)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: PostViewBottomWidget(
                        verticalPostView: verticalPostView,
                        allowComment:
                            sharedPostModel.postCommentPermission.allowComment,
                        allowShare:
                            sharedPostModel.postSharePermission.allowShare,
                        onCommentTap: onComment,
                        postId: sharedPostModel.id,
                        postType: sharedPostModel.postType,
                        shareCount: sharedPostModel.shareCount,
                        commentCount: sharedPostModel.commentCount,
                        reactionEmojiModel: sharedPostModel.reactionEmojiModel,
                        postFrom: sharedPostModel.postFrom,
                        postReactionDetails: postReactionDetails,
                        onReact: onReact,
                      ),
                    ),
                ],
              ),

              //Reaction box
              if (!isSharedView)
                BlocBuilder<ShowReactionCubit, ShowReactionState>(
                  builder: (context, showReactionState) {
                    return Visibility(
                      visible: showReactionState.showEmojiOption &&
                          showReactionState.objectId == sharedPostModel.id,
                      child: Positioned(
                        bottom: mqSize.height * 0.02,
                        right: 0,
                        left: 0,
                        child: ReactionWidget(
                          postId: sharedPostModel.id,
                          onReact: (reaction) async {
                            onReact.call(reaction, false);
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
