import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/group_chat_screen.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class GroupChatActionWidget extends StatelessWidget {
  const GroupChatActionWidget({
    super.key,
    required this.groupId,
    required this.isGroupMember,
  });

  final String groupId;
  final bool isGroupMember;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isGroupMember,
      child: ConnectionActionButton(
        height: 30,
        buttonName: LocaleKeys.chat,
        backgroundColor: ApplicationColours.themeBlueColor,
        onPressed: () {
          // TODO: Implement navigation to group chat screen
          GoRouter.of(context).pushNamed(
            GroupChatScreen.routeName,
            extra: {
              'groupName': 'BTM Pet lovers Group',
              'groupType': 'Public Community Group · BTM',
              'memberCount': 1050,
              'groupImageUrl': 'https://your-image-url.com/image.jpg',
            },
          );
        },
      ),
    );
  }
}
