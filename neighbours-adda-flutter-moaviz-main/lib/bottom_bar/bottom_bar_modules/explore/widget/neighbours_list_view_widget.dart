import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/profile/widgets/profile_details_display_widget.dart';

class NeighboursListView extends StatelessWidget {
  const NeighboursListView({
    super.key,
    required this.homeSearchScrollController,
    required this.neighboursList,
    this.listPadding,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  final ScrollController homeSearchScrollController;
  final List<ProfileDetailsModel> neighboursList;
  final EdgeInsetsGeometry? listPadding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: listPadding,
      controller: homeSearchScrollController,
      physics: physics,
      itemCount: neighboursList.length,
      itemBuilder: (BuildContext context, index) {
        final neighboursDetails = neighboursList[index];

        return Container(
          key: ValueKey(neighboursDetails.id),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Add border radius here
          ),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(
                NeighboursProfileAndPostsScreen.routeName,
                queryParameters: {'id': neighboursDetails.id},
              );
            },
            child: AbsorbPointer(
              child: ProfileDisplayWidget(
                profileImage: neighboursDetails.profileImage,
                profileImageRadius: 45,
                name: neighboursDetails.name,
                location: neighboursDetails.location!.address,
                bio: neighboursDetails.bio,
                occupation: neighboursDetails.occupation,
                workPlace: neighboursDetails.workPlace,
                isVerified: neighboursDetails.isVerified,
                languagesKnown: neighboursDetails.languageKnownList.languages
                    .map((e) => e.name)
                    .join(','),
                gender: neighboursDetails.gender,
              ),
            ),
          ),
        );
      },
    );
  }
}
