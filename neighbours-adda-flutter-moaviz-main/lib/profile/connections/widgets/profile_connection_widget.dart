import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_screen.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/profile/connections/logic/profile_connection/profile_connection_cubit.dart';
import 'package:snap_local/profile/connections/logic/profile_connection_action/profile_connection_action_cubit.dart';
import 'package:snap_local/profile/connections/models/profile_connection_type.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ProfileConnectionWidget extends StatefulWidget {
  const ProfileConnectionWidget({
    super.key,
    required this.requestedUserId,
    required this.connectionId,
    required this.name,
    required this.imageUrl,
    required this.connectionType,
    this.address,
    required this.isVerified,
  });

  final String name;
  final String requestedUserId;
  final String connectionId;
  final String imageUrl;
  final String? address;
  final bool isVerified;

  final ProfileConnectionType connectionType;

  @override
  State<ProfileConnectionWidget> createState() =>
      _ProfileConnectionWidgetState();
}

class _ProfileConnectionWidgetState extends State<ProfileConnectionWidget> {
  late ProfileConnectionActionCubit profileConnectionActionCubit;

  @override
  void initState() {
    super.initState();

    profileConnectionActionCubit = ProfileConnectionActionCubit(
      connectionRepository: ProfileConnectionRepository(),
    );
  }

  @override
  void didUpdateWidget(covariant ProfileConnectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //On widget update stop the loading if running from the previous widget.
    profileConnectionActionCubit.stopLoading();
  }

  @override
  void dispose() {
    super.dispose();
    profileConnectionActionCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: profileConnectionActionCubit,
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(
            NeighboursProfileAndPostsScreen.routeName,
            queryParameters: {'id': widget.requestedUserId},
            extra: profileConnectionActionCubit,
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
                            child: Row(
                              children: [
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                if(widget.isVerified==true)...[
                                  const SizedBox(width: 2),
                                  SvgPicture.asset(
                                    SVGAssetsImages.greenTick,
                                    height: 12,
                                    width: 12,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (widget.address != null)
                            AddressWithLocationIconWidget(
                              address: widget.address!,
                            ),
                        ],
                      ),
                    ),
                    BlocConsumer<ProfileConnectionActionCubit,
                        ProfileConnectionActionState>(
                      listener: (context, connectionState) {
                        if (connectionState.isRequestSuccess) {
                          context
                              .read<ProfileConnectionsCubit>()
                              .refreshDataModelOnAction(
                                  connectionType: widget.connectionType);
                        }
                      },
                      builder: (context, connectionState) {
                        return connectionState.isLoading
                            ? SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              )
                            : widget.connectionType ==
                                    ProfileConnectionType.myConnections
                                ? GestureDetector(
                                    onTap: () {
                                      GoRouter.of(context).pushNamed(
                                          ChatScreen.routeName,
                                          queryParameters: {
                                            "receiver_user_id":
                                                widget.requestedUserId
                                          });
                                    },
                                    child: SvgPicture.asset(
                                      SVGAssetsImages.connectionchat,
                                      fit: BoxFit.fitWidth,
                                      height: 35,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: connectionState.isLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<
                                                          ProfileConnectionActionCubit>()
                                                      .acceptConnection(
                                                        connectionId:
                                                            widget.connectionId,
                                                        neighboursId: widget
                                                            .requestedUserId,
                                                      );
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
                                                          ProfileConnectionActionCubit>()
                                                      .rejectConnection(
                                                        connectionId:
                                                            widget.connectionId,
                                                        neighboursId: widget
                                                            .requestedUserId,
                                                      );
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
