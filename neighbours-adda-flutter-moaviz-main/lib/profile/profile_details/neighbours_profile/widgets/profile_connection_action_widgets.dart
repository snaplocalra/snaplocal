import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/conntection_action_button_v2.dart';
import 'package:snap_local/profile/connections/logic/profile_connection_action/profile_connection_action_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../common/utils/widgets/svg_button_widget.dart';
import '../../../../utility/constant/assets_images.dart';

class ProfileConnectionActionWidget extends StatelessWidget {
  const ProfileConnectionActionWidget({
    super.key,
    required this.isOfficial,
    required this.isBlockedByYou,
    required this.isBlockedByNeighbour,
    required this.connectionStatus,
    this.connectionId,
    required this.neighboursId,
    required this.isConnectionRequestSender,
    required this.onChatButtonPresses,
    required this.allowOtherUserToSendMessage,
    required this.isFollowing,
    required this.refreshProfileDetails,
    required this.isFollowingViewedUser,
    required this.isFollowedByViewedUser,
  });

  final bool isOfficial;
  final bool isBlockedByYou;
  final bool isBlockedByNeighbour;
  final bool allowOtherUserToSendMessage;
  final bool isFollowing;
  final bool isFollowingViewedUser;
  final bool isFollowedByViewedUser;
  final String? connectionId;
  final String neighboursId;
  final bool isConnectionRequestSender;
  final ConnectionStatus connectionStatus;
  final void Function() onChatButtonPresses;
  final void Function() refreshProfileDetails;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileConnectionActionCubit,
        ProfileConnectionActionState>(
      listener: (context, profileConnectionActionState) {
        if (profileConnectionActionState.isRequestSuccess ||
            profileConnectionActionState.toggleBlockRequestSuccess||
        profileConnectionActionState.isFollowingSuccess) {
          refreshProfileDetails.call();
        }
      },
      builder: (context, profileConnectionActionState) {
        return profileConnectionActionState.toggleBlockLoading
            ? SpinKitWave(
                color: ApplicationColours.themeBlueColor,
                size: 20,
              )
            : isBlockedByYou
                ?
                //UnBlock Button
                ConnectionActionButtonV2(
                    textFontSize: 10,
                    buttonName: tr(LocaleKeys.unBlock),
                    onPressed: () {
                      context
                          .read<ProfileConnectionActionCubit>()
                          .toggleBlockUser(neighboursId);
                    },
                    backgroundColor: ApplicationColours.themeBlueColor,
                    showLoadingSpinner:
                        profileConnectionActionState.toggleBlockLoading,
                  )
                : isBlockedByNeighbour
                    ? const SizedBox.shrink()
                    : (connectionId != null &&
                            !isConnectionRequestSender &&
                            connectionStatus == ConnectionStatus.requestPending)
                        ? Row(
                            children: [
                              //Connection Accept Button
                              ConnectionActionButtonV2(
                                buttonName: LocaleKeys.accept,
                                disableButton: profileConnectionActionState
                                    .isRejectConnectionLoading,
                                showLoadingSpinner: profileConnectionActionState
                                    .isAcceptConnectionLoading,
                                onPressed: () {
                                  context
                                      .read<ProfileConnectionActionCubit>()
                                      .acceptConnection(
                                        connectionId: connectionId!,
                                        neighboursId: neighboursId,
                                      );
                                },
                              ),

                              //Connection Reject Button
                              ConnectionActionButtonV2(
                                buttonName: LocaleKeys.decline,
                                disableButton: profileConnectionActionState
                                    .isAcceptConnectionLoading,
                                backgroundColor:
                                    ApplicationColours.themeLightPinkColor,
                                showLoadingSpinner: profileConnectionActionState
                                    .isRejectConnectionLoading,
                                onPressed: () {
                                  context
                                      .read<ProfileConnectionActionCubit>()
                                      .rejectConnection(
                                        connectionId: connectionId!,
                                        neighboursId: neighboursId,
                                      );
                                },
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              //Connect and Disconnect Buttons
                              if(!isOfficial)
                              connectionStatus ==
                                          ConnectionStatus.notConnected ||
                                      connectionStatus ==
                                          ConnectionStatus.requestPending
                                  ?
                                  //Connect Button
                                  ConnectionActionButtonV2(
                                      backgroundColor: connectionStatus ==
                                              ConnectionStatus.requestPending
                                          ? ApplicationColours
                                              .themeLightPinkColor
                                          : null,
                                      buttonName: connectionStatus ==
                                              ConnectionStatus.notConnected
                                          ? LocaleKeys.connect
                                          : LocaleKeys.cancelRequest,
                                      showLoadingSpinner:
                                          profileConnectionActionState
                                              .isSendConnectionRequestLoading,
                                      onPressed: () {
                                        context
                                            .read<
                                                ProfileConnectionActionCubit>()
                                            .sendConnectionRequest(
                                                neighboursId);
                                      },
                                    )
                                  : //Disconnect Button
                                  ConnectionActionButtonV2(
                                      buttonName: LocaleKeys.disconnect,
                                      backgroundColor: ApplicationColours.themeLightPinkColor,
                                      showLoadingSpinner:
                                          profileConnectionActionState
                                              .isRejectConnectionLoading,
                                      onPressed: () {
                                        context
                                            .read<
                                                ProfileConnectionActionCubit>()
                                            .rejectConnection(
                                              connectionId: connectionId!,
                                              neighboursId: neighboursId,
                                            );
                                      },
                                    ),

                              // Follow and Unfollow Buttons
                              isOfficial?
                              ConnectionActionButtonV2(
                                buttonName: isFollowing?LocaleKeys.unFollow: LocaleKeys.follow,
                                showLoadingSpinner: profileConnectionActionState.isFollowingLoading,
                                onPressed: () {
                                    context.read<
                                      ProfileConnectionActionCubit>()
                                      .followUnfollowOfficialAccount(neighboursId);
                                },
                              ):
                              ConnectionActionButtonV2(
                                buttonName: isFollowingViewedUser?LocaleKeys.unFollow:isFollowedByViewedUser?"Follow Back":LocaleKeys.follow,
                                showLoadingSpinner: profileConnectionActionState.isFollowingLoading,
                                onPressed: () {
                                  context.read<
                                      ProfileConnectionActionCubit>()
                                      .followUnfollowInfluencerAccount(neighboursId);
                                },
                              ),

                              Visibility(
                                visible: allowOtherUserToSendMessage,
                                child: InkWell(
                                  onTap: onChatButtonPresses,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.shade200,
                                      shape: BoxShape.circle,
                                      border: Border(
                                          bottom: BorderSide(width: 2,color: Colors.blueAccent.shade400,),
                                          left: BorderSide(width: 0.5,color: Colors.blueAccent.shade400,),
                                          right: BorderSide(width: 0.5,color: Colors.blueAccent.shade400,)
                                      )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: SvgButtonWidget(
                                        svgImage: SVGAssetsImages.homechat,
                                        svgColorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                        svgSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 80,),
                              
                              //Chat Button
                              //   Visibility(
                              //     visible: allowOtherUserToSendMessage,
                              //     child: ConnectionActionButtonV2(
                              //       buttonName: LocaleKeys.chat,
                              //       onPressed: onChatButtonPresses,
                              //     ),
                              //   ),
                            ],
                          );
      },
    );
  }
}
