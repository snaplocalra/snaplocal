import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/action_dialog_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_actions/comment_actions_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_controller/comment_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/logic/comment_reaction_box_hide_controller/comment_reaction_box_hide_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/comment_model.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/temp_comment_index_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/emoji_static_data.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/widgets/reaction_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/svg_button_text_widget.dart';
import 'package:snap_local/utility/common/read_more/widget/read_more_text.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.commentModel,
    required this.postId,
    required this.parentCommentId,
    required this.postFrom,
    required this.postType,
    this.childCommentId,
    this.onReplyTap,
    required this.parentCommentIndex,
    this.childCommentIndex,
  });

  final CommentModel commentModel;
  final void Function(String userName)? onReplyTap;

  //Comment reaction requirements
  final String postId;
  final String parentCommentId;
  final String? childCommentId;
  final int parentCommentIndex;
  final int? childCommentIndex;
  final PostFrom postFrom;
  final PostType postType;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late GiveReactionCubit giveReactionCubit =
      GiveReactionCubit(context.read<ReactionRepository>());

  late PostDetailsControllerCubit postDetailsControllerCubit =
      context.read<PostDetailsControllerCubit>();

  Future<void> onReact({
    required ReactionEmojiModel reactionEmoji,
    bool removeReaction = false,
    bool isFirstReaction = false,
  }) async {
    //Close the reaction option widget
    await context
        .read<ShowReactionCubit>()
        .closeReactionEmojiOption()
        .whenComplete(() async {
      if (!removeReaction) {
        HapticFeedback.lightImpact();
        //   context.read<ReactionAudioEffectControllerCubit>().playReactionSound();
      }

      //Reaction call back to update on the UI
      context.read<CommentControllerCubit>().updateReaction(
            removeReaction ? null : reactionEmoji,
            isFirstReaction: isFirstReaction,
            parentCommentIndex: widget.parentCommentIndex,
            childCommentIndex: widget.childCommentIndex,
          );

      await giveReactionCubit.givePostCommentReaction(
        postId: widget.postId,
        postFrom: widget.postFrom,
        postType: widget.postType,
        parentCommentId: widget.parentCommentId,
        childCommentId: widget.childCommentId,
        reactionId: reactionEmoji.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final reactionEmojiListModel = ReactionEmojiList.fromMap(emojiData);

    return BlocListener<ReportCubit, ReportState>(
      listener: (context, reportState) {
        if (reportState.requestSuccess) {
          //remove the comment from the list
          context.read<CommentActionsCubit>().removeCommentFromList(
                tempCommentIndexModel: TempCommentIndexModel(
                  parentCommentIndex: widget.parentCommentIndex,
                  childCommentIndex: widget.childCommentIndex,
                ),
              );
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: giveReactionCubit),
        ],
        child: BlocListener<CommentReactionBoxHideControllerCubit,
            CommentReactionBoxHideControllerState>(
          listener: (context, commentReactionBoxHideControllerState) {
            if (!commentReactionBoxHideControllerState.visible) {
              context.read<ShowReactionCubit>().closeReactionEmojiOption();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                decoration: BoxDecoration(
                  color: const Color(0xffeef2ff),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //User profile image
                            GestureDetector(
                              onTap: () {
                                userProfileNavigation(
                                  context,
                                  userId: widget
                                      .commentModel.commentedByUserDetails.id,
                                  isOwner: widget.commentModel.isOwnComment,
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 2, right: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                ),
                                child: NetworkImageCircleAvatar(
                                  imageurl: widget.commentModel
                                      .commentedByUserDetails.image,
                                  radius: 20,
                                ),
                              ),
                            ),

                            //User name, location, time
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      userProfileNavigation(
                                        context,
                                        userId: widget.commentModel
                                            .commentedByUserDetails.id,
                                        isOwner:
                                            widget.commentModel.isOwnComment,
                                      );
                                    },
                                    child: Text(
                                      widget.commentModel.commentedByUserDetails
                                          .name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.commentModel
                                              .commentedByUserDetails.address,
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                113, 108, 108, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          FormatDate.ddMMampm(
                                              widget.commentModel.createdTime),
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                113, 108, 108, 1),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //EDIT, DELETE, HIDE, REPORT comment
                            BlocBuilder<CommentActionsCubit,
                                CommentActionsState>(
                              builder: (context, commentActionsState) {
                                return IconButton(
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (widget.commentModel.allowEdit)
                                                //edit comment
                                                ActionDialogOption(
                                                  showdivider: true,
                                                  svgImage:
                                                      SVGAssetsImages.edit,
                                                  title: tr(LocaleKeys.edit),
                                                  subtitle:
                                                      "You can edit this comment",
                                                  onTap: () {
                                                    String existingComment =
                                                        widget.commentModel
                                                            .comment;

                                                    //show the edit comment dialog
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (dialogContext) =>
                                                                Dialog(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                      10,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(tr(
                                                                            LocaleKeys.editComment)),
                                                                        const SizedBox(
                                                                            height:
                                                                                10),
                                                                        ThemeTextFormField(
                                                                          minLines:
                                                                              1,
                                                                          maxLines:
                                                                              6,
                                                                          textCapitalization:
                                                                              TextCapitalization.sentences,
                                                                          initialValue:
                                                                              existingComment,
                                                                          hint:
                                                                              tr(LocaleKeys.writeYourComment),
                                                                          hintStyle:
                                                                              const TextStyle(fontSize: 12),
                                                                          style:
                                                                              const TextStyle(fontSize: 12),
                                                                          onChanged:
                                                                              (value) {
                                                                            existingComment =
                                                                                value;
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                10),
                                                                        ThemeElevatedButton(
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          height:
                                                                              40,
                                                                          textFontSize:
                                                                              12,
                                                                          onPressed:
                                                                              () {
                                                                            //update the comment on ui
                                                                            context.read<CommentControllerCubit>().updateCommentInList(
                                                                                  commentModel: widget.commentModel.copyWith(
                                                                                    comment: existingComment,
                                                                                    editedComment: true,
                                                                                  ),
                                                                                  tempCommentIndexModel: TempCommentIndexModel(
                                                                                    parentCommentIndex: widget.parentCommentIndex,
                                                                                    childCommentIndex: widget.childCommentIndex,
                                                                                  ),
                                                                                );

                                                                            //edit the comment
                                                                            context.read<CommentActionsCubit>().editComment(
                                                                                  postId: widget.postId,
                                                                                  postType: widget.postType,
                                                                                  parentCommentId: widget.parentCommentId,
                                                                                  childCommentId: widget.childCommentId,
                                                                                  postFrom: widget.postFrom,
                                                                                  comment: existingComment,
                                                                                );

                                                                            //close the dialog
                                                                            Navigator.pop(dialogContext);
                                                                          },
                                                                          buttonName:
                                                                              tr(LocaleKeys.update),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ));
                                                  },
                                                ),
                                              if (widget
                                                  .commentModel.allowDelete)
                                                //delete comment
                                                ActionDialogOption(
                                                  showdivider: false,
                                                  svgImage:
                                                      SVGAssetsImages.delete,
                                                  title: tr(LocaleKeys.delete),
                                                  subtitle:
                                                      "You can delete this comment",
                                                  onTap: () async {
                                                    await showConfirmationDialog(
                                                      dialogContext,
                                                      confirmationButtonText:
                                                          tr(LocaleKeys.delete),
                                                      message:
                                                          'Are you sure you want to permanently remove this comment?',
                                                    ).then((allowDelete) {
                                                      if (allowDelete != null &&
                                                          allowDelete &&
                                                          context.mounted) {
                                                        context
                                                            .read<
                                                                CommentActionsCubit>()
                                                            .deleteComment(
                                                              postId:
                                                                  widget.postId,
                                                              postType: widget
                                                                  .postType,
                                                              parentCommentId:
                                                                  widget
                                                                      .parentCommentId,
                                                              childCommentId: widget
                                                                  .childCommentId,
                                                              postFrom: widget
                                                                  .postFrom,
                                                              tempCommentIndexModel:
                                                                  TempCommentIndexModel(
                                                                parentCommentIndex:
                                                                    widget
                                                                        .parentCommentIndex,
                                                                childCommentIndex:
                                                                    widget
                                                                        .childCommentIndex,
                                                              ),
                                                            );
                                                      }
                                                    });
                                                  },
                                                ),

                                              //If current user is the owner of the comment then
                                              //do not show the hide option
                                              if (!widget
                                                  .commentModel.isOwnComment)
                                                //Hide comment
                                                ActionDialogOption(
                                                  svgImage:
                                                      SVGAssetsImages.eyeClose,
                                                  iconSize: 20,
                                                  title: tr(LocaleKeys.hide),
                                                  subtitle: tr(LocaleKeys
                                                      .youcanhidethiscomment),
                                                  onTap: () async {
                                                    await showConfirmationDialog(
                                                      dialogContext,
                                                      confirmationButtonText:
                                                          tr(LocaleKeys.hide),
                                                      message: tr(LocaleKeys
                                                          .areyousureyouwanttohidethiscomment),
                                                    ).then((allowHide) {
                                                      if (allowHide != null &&
                                                          allowHide &&
                                                          context.mounted) {
                                                        context
                                                            .read<
                                                                CommentActionsCubit>()
                                                            .hideComment(
                                                              postId:
                                                                  widget.postId,
                                                              postType: widget
                                                                  .postType,
                                                              parentCommentId:
                                                                  widget
                                                                      .parentCommentId,
                                                              childCommentId: widget
                                                                  .childCommentId,
                                                              postFrom: widget
                                                                  .postFrom,
                                                              tempCommentIndexModel:
                                                                  TempCommentIndexModel(
                                                                parentCommentIndex:
                                                                    widget
                                                                        .parentCommentIndex,
                                                                childCommentIndex:
                                                                    widget
                                                                        .childCommentIndex,
                                                              ),
                                                            );
                                                      }
                                                    });
                                                  },
                                                ),

                                              //Report comment
                                              if (!widget
                                                  .commentModel.isOwnComment)
                                                ActionDialogOption(
                                                  showdivider: false,
                                                  svgImage:
                                                      SVGAssetsImages.report,
                                                  title: tr(LocaleKeys.report),
                                                  subtitle:
                                                      "You can report this comment",
                                                  onTap: () async {
                                                    GoRouter.of(context)
                                                        .pushNamed(
                                                      ReportScreen.routeName,
                                                      extra:
                                                          CommentReportPayload(
                                                        parentCommentId: widget
                                                            .parentCommentId,
                                                        childCommentId: widget
                                                            .childCommentId,
                                                        postId: widget.postId,
                                                        postFrom:
                                                            widget.postFrom,
                                                        postType:
                                                            widget.postType,
                                                        reportCubit:
                                                            context.read<
                                                                ReportCubit>(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.more_vert, size: 18),
                                );
                              },
                            ),
                          ],
                        ),
                        //show edited comment text if edited
                        if (widget.commentModel.editedComment)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 5),
                            child: Text(
                              tr(LocaleKeys.edited),
                              style: const TextStyle(
                                color: Color.fromRGBO(113, 108, 108, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          decoration: BoxDecoration(
                            color: const Color(0xffeef2ff),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ReadMoreText(
                            widget.commentModel.comment,
                            readMoreText: tr(LocaleKeys.readMore),
                            readLessText: tr(LocaleKeys.readLess),
                            style: const TextStyle(
                              color: Color.fromRGBO(52, 45, 45, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Reaction box
                    BlocBuilder<ShowReactionCubit, ShowReactionState>(
                      builder: (context, showReactionState) {
                        return Visibility(
                          visible: showReactionState.showEmojiOption &&
                              showReactionState.objectId ==
                                  widget.commentModel.id,
                          child: Positioned(
                            bottom: 10,
                            right: 0,
                            left: -10,
                            child: ReactionWidget(
                              postId: widget.commentModel.id,
                              onReact: (reaction) async {
                                onReact(reactionEmoji: reaction);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 5),
                child: Row(
                  children: [
                    widget.commentModel.reactionEmojiModel == null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SvgButtonTextWidget(
                              onLongPress: () {
                                context
                                    .read<ShowReactionCubit>()
                                    .showReactionEmojiOption(
                                        objectId: widget.commentModel.id);
                              },
                              onTap: () {
                                //Here in the list the 1st element is the LIKE reaction coming from the server.
                                final likeReaction = reactionEmojiListModel
                                    .reactionEmojiList.first;
                                onReact(
                                  reactionEmoji: likeReaction,
                                  isFirstReaction: true,
                                );
                              },
                              svgImage: SVGAssetsImages.like,
                              svgHeight: 20,
                              svgWidth: 20,
                              text: tr(LocaleKeys.react),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onLongPress: () {
                                context
                                    .read<ShowReactionCubit>()
                                    .showReactionEmojiOption(
                                        objectId: widget.commentModel.id);
                              },
                              onTap: () async {
                                onReact(
                                  reactionEmoji:
                                      widget.commentModel.reactionEmojiModel!,
                                  removeReaction: true,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.network(
                                    widget.commentModel.reactionEmojiModel!
                                        .imageUrl,
                                    height: 15,
                                    width: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget
                                        .commentModel.reactionEmojiModel!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: widget.commentModel
                                          .reactionEmojiModel!.nameColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SvgButtonTextWidget(
                      onTap: widget.onReplyTap == null
                          ? null
                          : () {
                              widget.onReplyTap!.call(widget
                                  .commentModel.commentedByUserDetails.name);
                            },
                      text: "Reply",
                      svgImage: SVGAssetsImages.reply,
                      svgHeight: 12,
                      svgWidth: 12,
                    ),
                  ],
                ),
              ),

              //Reply comments
              if (widget.commentModel.reply != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4),
                    shrinkWrap: true,
                    itemCount: widget.commentModel.reply!.length,
                    itemBuilder: (context, index) {
                      final replyCommentModel =
                          widget.commentModel.reply![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CommentWidget(
                          commentModel: replyCommentModel,
                          //The reply comment of a child comment will come under the parent comment
                          onReplyTap: widget.onReplyTap,

                          //reaction requirements
                          postId: widget.postId,
                          parentCommentId: widget.parentCommentId,
                          parentCommentIndex: widget.parentCommentIndex,
                          childCommentId: replyCommentModel.id,
                          childCommentIndex: index,
                          postFrom: widget.postFrom,
                          postType: widget.postType,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
