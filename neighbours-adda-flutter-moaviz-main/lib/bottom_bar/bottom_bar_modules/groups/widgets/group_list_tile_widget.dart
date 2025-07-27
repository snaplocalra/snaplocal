import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/group_connection_action/group_connection_action_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/unseen_post_count_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../utility/constant/assets_images.dart';

class GroupListTileWidget extends StatelessWidget {
  const GroupListTileWidget({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupIndex,
    required this.groupImageUrl,
    required this.groupDescription,
    required this.unSeenPostCount,
    required this.isJoined,
    required this.isGroupAdmin,
    required this.isVerified,
    this.onGroupJoinExit,
  });

  final String groupId;
  final String groupName;
  final int? groupIndex;
  final String groupImageUrl;
  final String groupDescription;
  final int unSeenPostCount;
  final bool isJoined;
  final bool isVerified;
  final bool isGroupAdmin;
  final void Function(bool isJoined)? onGroupJoinExit;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => GroupConnectionActionCubit(
        groupConnectionRepository: context.read<GroupConnectionRepository>(),
        groupListCubit: context.read<GroupListCubit>(),
        groupIndex: groupIndex,
      ),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(
            GroupDetailsScreen.routeName,
            queryParameters: {'id': groupId},
            extra: groupIndex,
          );
        },
        child: AbsorbPointer(
          absorbing: !(!isGroupAdmin && onGroupJoinExit != null),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImageCircleAvatar(
                  radius: mqSize.width * 0.06,
                  imageurl: groupImageUrl,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      groupName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if(isVerified==true)...[
                                      const SizedBox(width: 2),
                                      SvgPicture.asset(
                                        SVGAssetsImages.greenTick,
                                        height: 12,
                                        width: 12,
                                      ),
                                    ],
                                  ],
                                ),
                                Visibility(
                                  visible: groupDescription.isNotEmpty,
                                  child: Text(
                                    groupDescription,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UnSeenCountWidget(unSeenPostCount: unSeenPostCount),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          )
                        ],
                      ),
                      if (!isGroupAdmin && onGroupJoinExit != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            width: mqSize.width * 0.3,
                            child: Row(children: [
                              BlocConsumer<GroupConnectionActionCubit,
                                  GroupConnectionActionState>(
                                listener:
                                    (context, groupConnectionActionState) {
                                  if (groupConnectionActionState
                                      .isRequestSuccess) {
                                    context
                                        .read<GroupConnectionActionCubit>()
                                        .stopLoading();
                                  }
                                },
                                builder: (context, groupConnectionActionState) {
                                  return ConnectionActionButton(
                                    height: 30,
                                    foregroundColor:
                                        isJoined ? Colors.black : Colors.white,
                                    backgroundColor: isJoined
                                        ? const Color.fromRGBO(233, 236, 239, 1)
                                        : ApplicationColours.themeBlueColor,
                                    buttonName: isJoined
                                        ? LocaleKeys.exit
                                        : LocaleKeys.join,
                                    onPressed: () async {
                                      await showConfirmationDialog(
                                        context,
                                        confirmationButtonText: isJoined
                                            ? tr(LocaleKeys.exit)
                                            : tr(LocaleKeys.join),
                                        confirmationButtonColor: isJoined
                                            ? Colors.red
                                            : ApplicationColours.themeBlueColor,
                                        message:
                                            "Are you sure you want to ${isJoined ? 'exit' : 'join'} this group?",
                                      ).then((allow) {
                                        if (allow != null &&
                                            allow &&
                                            context.mounted) {
                                          if (isJoined) {
                                            //Leave the group
                                            context
                                                .read<
                                                    GroupConnectionActionCubit>()
                                                .exitGroupJoinRequest(groupId);
                                          } else {
                                            //Send the request to join the group
                                            context
                                                .read<
                                                    GroupConnectionActionCubit>()
                                                .sendAndCancelGroupJoinRequest(
                                                    groupId);
                                          }

                                          //Update the group details locally
                                          onGroupJoinExit!.call(!isJoined);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ]),
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Divider(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
