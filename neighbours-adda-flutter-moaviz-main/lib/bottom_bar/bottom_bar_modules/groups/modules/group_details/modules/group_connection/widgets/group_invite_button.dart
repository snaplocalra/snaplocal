import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class GroupInviteButton extends StatelessWidget {
  const GroupInviteButton({
    super.key,
    required this.buttonHeight,
    required this.groupId,
  });

  final double buttonHeight;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ConnectionActionButton(
      height: buttonHeight,
      buttonName: LocaleKeys.invite,
      onPressed: () {
        context.read<ShareCubit>().generalShare(
              context,
              data: groupId,
              screenURL: GroupDetailsScreen.routeName,
              shareSubject: 'Invite to join group',
            );
      },
    );
  }
}
