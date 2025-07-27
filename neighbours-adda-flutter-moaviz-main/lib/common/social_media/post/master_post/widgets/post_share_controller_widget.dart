import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_setting_display.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_setting_option_display.dart';

class PostShareControlWidget extends StatefulWidget {
  const PostShareControlWidget({
    super.key,
    required this.onPostSharePermissionSelection,
  });

  final void Function(PostSharePermission postShare)
      onPostSharePermissionSelection;

  @override
  State<PostShareControlWidget> createState() => _PostShareControlWidgetState();
}

class _PostShareControlWidgetState extends State<PostShareControlWidget> {
  static final postShareControlList = [
    PostSharePermission.allow,
    PostSharePermission.restrict,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostShareControlCubit, PostShareControlState>(
      builder: (context, postShareControlState) {
        final selectedPostSharePermission =
            postShareControlState.postShareControlEnum;

        //Call the function to update with the parent widget
        widget.onPostSharePermissionSelection.call(selectedPostSharePermission);
        ////
        return PopupMenuButton<PostSharePermission>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          itemBuilder: (context) =>
              List.generate(postShareControlList.length, (index) {
            final postShareOption = postShareControlList[index];
            return PopupMenuItem(
              value: postShareOption,
              height: 30,
              child: PostSettingOptionDisplay(
                svgPath: postShareControlList[index].svgPath,
                name: postShareControlList[index].displayName,
                isSelected: postShareOption == selectedPostSharePermission,
              ),
            );
          }),
          onSelected: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<PostShareControlCubit>().changeSharePermission(value);
          },
          child: PostSettingDisplay(
            name: selectedPostSharePermission.displayName,
            svgPath: selectedPostSharePermission.svgPath,
            // name: "Shares",
            fontSize: 8,
            iconSize: 15,
          ),
        );
      },
    );
  }
}
