import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/action_dialog/post_action_dialog.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_action_permission.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';

class PostAction3DotButtonWidget {
  Widget build(BuildContext context, SocialPostModel socialPostModel) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<PostDetailsControllerCubit>()),
        BlocProvider.value(value: context.read<PostActionCubit>()),
        BlocProvider.value(value: context.read<ReportCubit>()),
        BlocProvider.value(value: context.read<ShowReactionCubit>()),
        //Hide cubit
        BlocProvider.value(value: context.read<HidePostCubit>())
      ],
      child: socialPostModel.isOwnPost
          ? OwnerPostActionDialog(
              showClosePoll: (socialPostModel is PollPostModel) &&
                  !(socialPostModel).pollsModel.disablePoll,
              groupPageInfoId: socialPostModel.groupPageInfo?.id,
              postId: socialPostModel.id,
              postFrom: socialPostModel.postFrom,
              postType: socialPostModel.postType,
              postCommentPermission: socialPostModel.postCommentPermission,
              postSharePermission: socialPostModel.postSharePermission,
              allowEdit: socialPostModel is AllowOwnPostEdit,
            )
          : UserPostActionDialog(
              postId: socialPostModel.id,
              groupPageInfoId: socialPostModel.groupPageInfo?.id,
              userId: socialPostModel.postUserInfo.userId,
              postFrom: socialPostModel.postFrom,
              postType: socialPostModel.postType,
            ),
    );
  }
}
