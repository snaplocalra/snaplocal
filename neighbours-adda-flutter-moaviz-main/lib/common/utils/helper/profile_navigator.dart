import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/profile/profile_details/own_profile/screen/own_profile_screen.dart';

Future<void> userProfileNavigation(
  BuildContext context, {
  required String userId,
  required bool isOwner,
}) async {
  //On profile image tap
  if (isOwner) {
    //If the post is user own post, then open the own posts and profile
    await GoRouter.of(context).pushNamed(OwnProfilePostsScreen.routeName);
  } else {
    //Else then open the Neighbours posts and profile
    await GoRouter.of(context).pushNamed(
      NeighboursProfileAndPostsScreen.routeName,
      queryParameters: {'id': userId},
    );
  }
}
