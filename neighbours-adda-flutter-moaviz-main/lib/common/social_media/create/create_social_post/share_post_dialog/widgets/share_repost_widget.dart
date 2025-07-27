// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/logic/post_preview_view/post_preview_view_cubit.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/logic/share_the_post/share_the_post_cubit.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/model/share_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/repository/share_the_post_repository.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/share_post_dialog_profile.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/post_privacy_controller_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/shared_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_post_state.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';

class ShareRepostWidget extends StatefulWidget {
  final bool isEditSharedPost;
  const ShareRepostWidget({
    super.key,
    this.isEditSharedPost = false,
  });

  @override
  State<ShareRepostWidget> createState() => _ShareRepostWidgetState();
}

class _ShareRepostWidgetState extends State<ShareRepostWidget> {
  //Caption text controller
  final captionTextController = TextEditingController();

  final postPreviewViewCubit = PostPreviewViewCubit();

  //Profile details
  late ProfileDetailsModel profileDetails =
      context.read<ManageProfileDetailsBloc>().state.profileDetailsModel!;

  //Post details
  late SocialPostModel postModel =
      context.read<PostDetailsControllerCubit>().state.socialPostModel;

  late ShareThePostCubit shareThePostCubit =
      ShareThePostCubit(ShareThePostRepository());

  ///Update the data on parent widget on post update
  void updatePostController() {
    final sharedPostModel = context
        .read<PostDetailsControllerCubit>()
        .state
        .socialPostModel as SharedPostModel;
    context.read<PostDetailsControllerCubit>().postStateUpdate(UpdatePostState(
        sharedPostModel.copyWith(caption: captionTextController.text)));
  }

  //Post visibility
  PostVisibilityControlEnum postVisibilityPermission =
      PostVisibilityControlEnum.public;

  @override
  void initState() {
    super.initState();
    if (widget.isEditSharedPost) {
      final sharedPostModel = postModel as SharedPostModel;
      captionTextController.text = sharedPostModel.caption;
    }
  }

  @override
  void dispose() {
    captionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: postPreviewViewCubit),
        BlocProvider.value(value: shareThePostCubit),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profile details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SharePostDialogProfileWidget(
                  image: profileDetails.profileImage,
                  name: profileDetails.name,
                  address: profileDetails.location?.address,
                ),
              ),
              BlocProvider(
                create: (context) =>
                    PostVisibilityControlCubit(postVisibilityPermission),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: PostVisibilityControlWidget(
                    onPostVisibilitySelection:
                        (PostVisibilityControlEnum postVisibilityPermission) {
                      this.postVisibilityPermission = postVisibilityPermission;
                    },
                  ),
                ),
              )
            ],
          ),

          //Share the post
          BlocConsumer<ShareThePostCubit, ShareThePostState>(
            listener: (context, shareThePostState) {
              if (shareThePostState.isRequestSuccess) {
                //Update the post controller
                if (widget.isEditSharedPost) {
                  updatePostController();
                }
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                }
              }
            },
            builder: (context, shareThePostState) {
              //Post visibility
              return BlocBuilder<PostPreviewViewCubit, PostPreviewViewState>(
                builder: (context, postPreviewViewState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: postPreviewViewState.visibility
                              ?
                              //Post details
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      //max height limit
                                      maxHeight: 200,
                                    ),
                                    child: SingleChildScrollView(
                                      child: PostViewWidget(
                                        key: ValueKey(postModel.id),
                                        enableGroupHeaderView: false,
                                        allowNavigation: false,
                                        allowPostDetailsOpen: false,
                                        isSharedView: true,
                                        enableNewsPostAction: false,

                                        //Disable poll vote and event "view more" button
                                        enableSpecialActivity: false,
                                      ),
                                    ),
                                  ),
                                )
                              :
                              //Share post caption
                              ThemeTextFormField(
                                  enabled:
                                      !shareThePostState.isRequestProcessing,
                                  controller: captionTextController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Color.fromRGBO(104, 107, 116, 0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  textFieldPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 6,
                                  minLines: 3,
                                  maxLength: TextFieldInputLength
                                      .additionalTextMaxLength,
                                  hint: "Say something about this post...",
                                  fillColor: Colors.grey.shade100,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThemeElevatedButton(
                                buttonName: widget.isEditSharedPost
                                    ? "Upate Post"
                                    : "Share & Post",
                                onPressed: () {
                                  final inAppSharePostDataModel =
                                      InAppSharePostDataModel(
                                    postId: postModel.id,
                                    postType: postModel.postType,
                                    postFrom: postModel.postFrom,
                                    caption: captionTextController.text.trim(),
                                    visibilityPermission:
                                        postVisibilityPermission,

                                    //Static
                                    commentPermission:
                                        PostCommentPermission.enable,
                                    sharePermission: PostSharePermission.allow,
                                  );

                                  if (widget.isEditSharedPost) {
                                    //Update the post
                                    context
                                        .read<ShareThePostCubit>()
                                        .updateSharedPost(
                                            inAppSharePostDataModel);
                                  } else {
                                    //Share the post
                                    context
                                        .read<ShareThePostCubit>()
                                        .shareThePost(inAppSharePostDataModel);
                                  }
                                },
                                width: 120,
                                height: 30,
                                textFontSize: 12,
                                padding: EdgeInsets.zero,
                                showLoadingSpinner:
                                    shareThePostState.isRequestProcessing,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<PostPreviewViewCubit>()
                                      .toogleVisibility(
                                          postPreviewViewState.visibility);
                                },
                                child: Text(
                                  postPreviewViewState.visibility
                                      ? "HIDE PREVIEW"
                                      : "POST PREVIEW",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
