// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_setting_display.dart';
import 'package:snap_local/common/social_media/post/master_post/widgets/post_setting_option_display.dart';

class PostVisibilityControlWidget extends StatefulWidget {
  const PostVisibilityControlWidget({
    super.key,
    required this.onPostVisibilitySelection,
  });

  final void Function(PostVisibilityControlEnum postVisibility)
      onPostVisibilitySelection;

  @override
  State<PostVisibilityControlWidget> createState() =>
      _PostVisibilityControlWidgetState();
}

class _PostVisibilityControlWidgetState
    extends State<PostVisibilityControlWidget> {
  static final postVisibilityOptionList = [
    PostVisibilityControlEnum.public,
    PostVisibilityControlEnum.connections,
    PostVisibilityControlEnum.connectionGroups,
    PostVisibilityControlEnum.private,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostVisibilityControlCubit, PostVisibilityControlState>(
      builder: (context, postVisibilityState) {
        final selectedPostVisibility =
            postVisibilityState.postVisibilityControlEnum;

        //Call the function to update with the parent widget
        widget.onPostVisibilitySelection.call(selectedPostVisibility);
        ////
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: PopupMenuButton<PostVisibilityControlEnum>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            itemBuilder: (context) =>
                List.generate(postVisibilityOptionList.length, (index) {
              final postVisibility = postVisibilityOptionList[index];
              return PopupMenuItem(
                value: postVisibility,
                height: 30,
                child: PostSettingOptionDisplay(
                  svgPath: postVisibilityOptionList[index].svgPath,
                  name: postVisibilityOptionList[index].displayName,
                  isSelected: postVisibility == selectedPostVisibility,
                ),
              );
            }),
            onSelected: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
              context
                  .read<PostVisibilityControlCubit>()
                  .changePostVisibility(value);
            },
            child: PostSettingDisplay(
              svgPath: selectedPostVisibility.svgPath,
              name: selectedPostVisibility.displayName,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}
