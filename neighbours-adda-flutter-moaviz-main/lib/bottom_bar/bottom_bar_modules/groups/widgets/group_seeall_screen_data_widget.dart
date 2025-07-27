import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/widgets/group_list_tile_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class GroupSeeAllScreenDataWidget extends StatelessWidget {
  const GroupSeeAllScreenDataWidget({
    super.key,
    required this.groupList,
    required this.header,
    required this.isLastPage,
    required this.onLoadMore,
  });

  final String header;
  final bool isLastPage;
  final List<GroupModel> groupList;
  final void Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ApplicationColours.themeBlueColor,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: groupList.length + 1,
            itemBuilder: (BuildContext context, index) {
              if (index < groupList.length) {
                final groupDetails = groupList[index];
                return GroupListTileWidget(
                  key: ValueKey(groupDetails.groupId),
                  groupName: groupDetails.groupName,
                  groupDescription: groupDetails.groupDescription,
                  groupId: groupDetails.groupId,
                  groupImageUrl: groupDetails.groupImage,
                  unSeenPostCount: groupDetails.unseenPostCount,
                  isJoined: groupDetails.isJoined,
                  isGroupAdmin: groupDetails.isGroupAdmin,
                  isVerified: groupDetails.isVerified,
                  onGroupJoinExit: (isJoined) {
                    //Update the group details
                    groupDetails.isJoined = isJoined;

                    //Refresh the group list
                    context.read<GroupListCubit>().refreshState();
                  },
                );
              } else {
                if (isLastPage) {
                  return const SizedBox.shrink();
                } else {
                  return TextButton(
                    onPressed: onLoadMore,
                    child: Text(
                      "Load More",
                      style: TextStyle(
                        color: ApplicationColours.themePinkColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
