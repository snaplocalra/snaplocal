import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/logic/group_details/group_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/group_connection_action/group_connection_action_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/private_group_join_requests/private_group_join_requests_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/screens/private_group_join_request_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/widgets/group_invite_button.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/screen/create_or_update_group_details_screen.dart';
import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/widgets/group_chat_action_widget.dart';

class GroupConnectionActionWidget extends StatefulWidget {
  const GroupConnectionActionWidget({
    super.key,
    this.isExitGroupLoading = false,
    this.isSendRequestLoading = false,
    required this.groupId,
    this.groupIndex,
    required this.isGroupOwner,
    required this.connectionStatus,
    required this.groupProfileDetailsModel,
    required this.requestSuccessCallback,
  });

  final bool isExitGroupLoading;
  final bool isSendRequestLoading;
  final String groupId;
  final int? groupIndex;
  final bool isGroupOwner;
  final ConnectionStatus connectionStatus;
  final GroupProfileDetailsModel groupProfileDetailsModel;
  final void Function() requestSuccessCallback;

  @override
  State<GroupConnectionActionWidget> createState() =>
      _GroupConnectionActionWidgetState();
}

class _GroupConnectionActionWidgetState
    extends State<GroupConnectionActionWidget> {
  late GroupConnectionActionCubit groupConnectionActionCubit =
      GroupConnectionActionCubit(
    groupListCubit: context.read<GroupListCubit>(),
    groupIndex: widget.groupIndex,
    groupConnectionRepository: context.read<GroupConnectionRepository>(),
  );

  //Private group join requests cubit
  late PrivateGroupJoinRequestsCubit privateGroupJoinRequestsCubit =
      PrivateGroupJoinRequestsCubit(context.read<GroupConnectionRepository>())
        ..fetchPrivateGroupJoinRequets(groupId: widget.groupId);

  @override
  void didUpdateWidget(covariant GroupConnectionActionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    groupConnectionActionCubit.stopLoading();
  }

  final double buttonHeight = 30;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: groupConnectionActionCubit),
        BlocProvider.value(value: privateGroupJoinRequestsCubit),
      ],
      child:
          BlocConsumer<GroupConnectionActionCubit, GroupConnectionActionState>(
        listener: (context, groupConnectionActionState) {
          if (mounted) {
            if (groupConnectionActionState.isRequestSuccess) {
              widget.requestSuccessCallback.call();
            }
          }
        },
        builder: (context, groupConnectionActionState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Normal user buttons
              Visibility(
                visible: !widget.isGroupOwner,
                child: widget.connectionStatus == ConnectionStatus.notConnected
                    ?
                    //Group Join Button
                    ConnectionActionButton(
                        height: buttonHeight,
                        backgroundColor: ApplicationColours.themeBlueColor,
                        buttonName: LocaleKeys.join,
                        showLoadingSpinner: groupConnectionActionState
                            .isSendAndRemoveGroupJoinRequestLoading,
                        onPressed: () {
                          context
                              .read<GroupConnectionActionCubit>()
                              .sendAndCancelGroupJoinRequest(widget.groupId);
                        },
                      )
                    : widget.connectionStatus == ConnectionStatus.connected
                        ? Expanded(
                            child: Row(
                              children: [
                                
                                //Group Invite Button
                                GroupInviteButton(
                                  buttonHeight: buttonHeight,
                                  groupId: widget.groupId,
                                ),
                                //Group Exit Button
                                ConnectionActionButton(
                                  height: buttonHeight,
                                  buttonName: LocaleKeys.exit,
                                  backgroundColor: Colors.red,
                                  showLoadingSpinner: groupConnectionActionState
                                      .isExitGroupRequestLoading,
                                  onPressed: () async {
                                    await showConfirmationDialog(
                                      context,
                                      confirmationButtonText:
                                          tr(LocaleKeys.exit),
                                      message:
                                          "Are you sure you want to exit this group?",
                                    ).then((allow) {
                                      if (allow != null &&
                                          allow &&
                                          context.mounted) {
                                        context
                                            .read<GroupConnectionActionCubit>()
                                            .exitGroupJoinRequest(
                                                widget.groupId);
                                      }
                                    });
                                  },
                                ),
                                //Group Chat Button
                                GroupChatActionWidget(
                                  groupId: widget.groupId,
                                  isGroupMember: true,
                                ),
                              ],
                            ),
                          )
                        :
                        //If the connection is in pending
                        //Group Join cancel Button
                        ConnectionActionButton(
                            height: buttonHeight,
                            buttonName: LocaleKeys.cancelRequest,
                            showLoadingSpinner: groupConnectionActionState
                                .isSendAndRemoveGroupJoinRequestLoading,
                            onPressed: () {
                              context
                                  .read<GroupConnectionActionCubit>()
                                  .sendAndCancelGroupJoinRequest(
                                      widget.groupId);
                            },
                          ),
              ),
              //Group owner buttons
              Visibility(
                visible: widget.isGroupOwner,
                child: Expanded(
                  child: Row(
                    children: [
                      //Group Invite Button
                      GroupInviteButton(
                        buttonHeight: buttonHeight,
                        groupId: widget.groupId,
                      ),
                      //Group Edit Button
                      ConnectionActionButton(
                        height: buttonHeight,
                        buttonName: LocaleKeys.editGroup,
                        foregroundColor: Colors.black,
                        backgroundColor: const Color.fromRGBO(233, 236, 239, 1),
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(
                                CreateOrUpdateGroupDetailsScreen.routeName,
                                extra: widget.groupProfileDetailsModel,
                              )
                              .whenComplete(() => context
                                  .read<GroupDetailsCubit>()
                                  .fetchGroupDetails(groupId: widget.groupId));
                        },
                      ),
                      BlocBuilder<PrivateGroupJoinRequestsCubit,
                          PrivateGroupJoinRequestsState>(
                        builder: (context, privateGroupJoinRequestsState) {
                          if (privateGroupJoinRequestsState
                                  .groupConnectionListAvailable &&
                              privateGroupJoinRequestsState
                                  .groupConnectionListModel!.data.isNotEmpty) {
                            return ConnectionActionButton(
                              height: 30,
                              buttonName: tr(LocaleKeys.requests),
                              onPressed: () {
                                GoRouter.of(context)
                                    .pushNamed(
                                      PrivateGroupJoinRequestScreen.routeName,
                                      queryParameters: {
                                        'group_id': widget.groupId
                                      },
                                      extra: context.read<
                                          PrivateGroupJoinRequestsCubit>(),
                                    )
                                    .whenComplete(() => context
                                        .read<PrivateGroupJoinRequestsCubit>()
                                        .fetchPrivateGroupJoinRequets(
                                          groupId: widget.groupId,
                                        ));
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
