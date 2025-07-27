import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';

import '../../../../profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import '../../../../profile/profile_details/own_profile/screen/own_profile_screen.dart';
import '../../../../utility/common/widgets/shimmer_widget.dart';

class ProfileAvatar extends StatefulWidget {
  final void Function()? onDataFetchCallBack;
  const ProfileAvatar({super.key, this.onDataFetchCallBack});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageProfileDetailsBloc, ManageProfileDetailsState>(
      builder: (context, profileState) {
        final profileDetails = profileState.profileDetailsModel;
        return (profileState.dataLoading)
            ? const OctagonWidget(
                shapeSize: 40,
                child: ShimmerWidget(
                  height: 30,
                  width: 30,
                  shapeBorder: CircleBorder(),
                ),
              )
            : !profileState.isProfileDetailsAvailable
                ? const OctagonWidget(
                    shapeSize: 40,
                    child: SizedBox(
                      height: 30,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(OwnProfilePostsScreen.routeName)
                          .whenComplete(() {
                        if (mounted) {
                          if (widget.onDataFetchCallBack != null) {
                            widget.onDataFetchCallBack!.call();
                          }
                        }
                      });
                    },
                    child: OctagonWidget(
                      shapeSize: 40,
                      child: CachedNetworkImage(
                        imageUrl: profileDetails!.profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
      },
    );
  }
}
