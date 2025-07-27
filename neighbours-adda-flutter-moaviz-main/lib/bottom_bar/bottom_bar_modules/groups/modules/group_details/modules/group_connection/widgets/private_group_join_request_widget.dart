import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/group_connection_action/group_connection_action_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/private_group_join_requests/private_group_join_requests_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';

class PrivateGroupJoinRequestWidget extends StatefulWidget {
  const PrivateGroupJoinRequestWidget({
    super.key,
    required this.requestedUserId,
    required this.connectionId,
    required this.groupId,
    required this.name,
    required this.imageUrl,
    this.address,
  });

  final String name;
  final String requestedUserId;
  final String connectionId;
  final String groupId;
  final String imageUrl;
  final String? address;

  @override
  State<PrivateGroupJoinRequestWidget> createState() =>
      _PrivateGroupJoinRequestWidgetState();
}

class _PrivateGroupJoinRequestWidgetState
    extends State<PrivateGroupJoinRequestWidget> {
  late GroupConnectionActionCubit groupConnectionActionCubit;

  @override
  void initState() {
    super.initState();
    groupConnectionActionCubit = GroupConnectionActionCubit(
      groupConnectionRepository: context.read<GroupConnectionRepository>(),
      groupListCubit: context.read<GroupListCubit>(),
    );
  }

  @override
  void didUpdateWidget(covariant PrivateGroupJoinRequestWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //On widget update stop the loading if running from the previous widget.
    groupConnectionActionCubit.stopLoading();
  }

  @override
  void dispose() {
    super.dispose();
    groupConnectionActionCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: groupConnectionActionCubit,
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(
            NeighboursProfileAndPostsScreen.routeName,
            queryParameters: {'id': widget.requestedUserId},
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
          child: Row(
            children: [
              NetworkImageCircleAvatar(
                radius: mqSize.width * 0.06,
                imageurl: widget.imageUrl,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                            ),
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (widget.address != null)
                            AddressWithLocationIconWidget(
                              address: widget.address!,
                            ),
                        ],
                      ),
                    ),
                    BlocConsumer<GroupConnectionActionCubit,
                        GroupConnectionActionState>(
                      listener: (context, connectionState) {
                        if (connectionState.isRequestSuccess) {
                          context
                              .read<PrivateGroupJoinRequestsCubit>()
                              .fetchPrivateGroupJoinRequets(
                                  groupId: widget.groupId);
                        }
                      },
                      builder: (context, connectionState) {
                        return connectionState.isLoading
                            ? SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: connectionState.isLoading
                                          ? null
                                          : () {
                                              context
                                                  .read<
                                                      GroupConnectionActionCubit>()
                                                  .acceptConnection(
                                                      widget.connectionId);
                                            },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              204, 251, 201, 1),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: connectionState.isLoading
                                          ? null
                                          : () {
                                              context
                                                  .read<
                                                      GroupConnectionActionCubit>()
                                                  .rejectJoinRequest(
                                                      widget.connectionId);
                                            },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255, 226, 226, 1),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          FeatherIcons.x,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
