import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_setting_display.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_setting_option_display.dart';

class PostCommentControlWidget extends StatefulWidget {
  const PostCommentControlWidget({
    super.key,
    required this.onPostCommentPermissionSelection,
  });

  final void Function(PostCommentPermission postCommentPermission)
      onPostCommentPermissionSelection;

  @override
  State<PostCommentControlWidget> createState() =>
      _PostCommentControlWidgetState();
}

class _PostCommentControlWidgetState extends State<PostCommentControlWidget> {
  final postCommentControlList = [
    PostCommentPermission.enable,
    PostCommentPermission.disable,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCommentControlCubit, PostCommentControlState>(
      builder: (context, postCommentControlState) {
        final selectedPostCommentPermission =
            postCommentControlState.postCommentControlEnum;

        //Call the function to update with the parent widget
        widget.onPostCommentPermissionSelection
            .call(selectedPostCommentPermission);
        ////
        return PopupMenuButton<PostCommentPermission>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          itemBuilder: (context) =>
              List.generate(postCommentControlList.length, (index) {
            final postCommentOption = postCommentControlList[index];
            return PopupMenuItem(
              value: postCommentOption,
              height: 30,
              child: PostSettingOptionDisplay(
                svgPath: postCommentControlList[index].svgPath,
                name: postCommentControlList[index].displayName,
                isSelected: postCommentOption == selectedPostCommentPermission,
              ),
            );
          }),
          onSelected: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            context
                .read<PostCommentControlCubit>()
                .changeCommentPermission(value);
          },
          child: PostSettingDisplay(
            svgPath: selectedPostCommentPermission.svgPath,
            name: selectedPostCommentPermission.displayName,
            fontSize: 8,
            iconSize: 15,
          ),
        );
      },
    );
  }
}
