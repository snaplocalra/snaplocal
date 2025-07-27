import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/screen/share_post_details_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/models/route_navigation_model.dart';
import 'package:snap_local/common/utils/share/model/share_type.dart';

Future<void> handleNotificationNavigation(
  BuildContext context,
  RouteNavigationModel notificationTapNavigationModel,
) async {
  final routeName = notificationTapNavigationModel.screenRoute;
  final navigationId = notificationTapNavigationModel.navigationId;
  final socialPostNavigationDetails =
      notificationTapNavigationModel.socialPostNavigationDetailsModel;
  switch (notificationTapNavigationModel.screenRoute) {
    case "shared_social_post":
      if (navigationId != null && socialPostNavigationDetails != null) {
        String postId = navigationId;

        final sharePostLinkData = SharedPostDataModel(
          postId: postId,
          postType: socialPostNavigationDetails.postType,
          postFrom: socialPostNavigationDetails.postFrom,
          shareType: ShareType.general,
        );

        GoRouter.of(context).pushNamed(
          GeneralSharedSocialPostDetails.routeName,
          extra: sharePostLinkData,
        );
      }
      break;

    case "chat":
      if (navigationId != null) {
        OtherCommunicationChatNavigationDetailsModel?
            otherCommunicationChatNavigationDetailsModel =
            notificationTapNavigationModel
                .otherCommunicationChatNavigationDetailsModel;
        OtherCommunicationPost? otherCommunicationPost;

        if (otherCommunicationChatNavigationDetailsModel != null) {
          final otherCommunicationType =
              otherCommunicationChatNavigationDetailsModel
                  .otherCommunicationType;
          final id = otherCommunicationChatNavigationDetailsModel.id;
          otherCommunicationPost = OtherCommunicationPost.createTypeWise(
            id: id,
            displayName: "",
            otherCommunicationType: otherCommunicationType,
          );
        }

        String userId = navigationId;
        GoRouter.of(context).pushNamed(
          routeName,
          queryParameters: {'receiver_user_id': userId},
          extra: otherCommunicationPost,
        );
      }
      break;

    case "neighbours_profile_and_post":
      if (navigationId != null) {
        String neighbourId = navigationId;
        GoRouter.of(context).pushNamed(
          routeName,
          queryParameters: {'id': neighbourId},
        );
      }
      break;

    case "business_details":
      if (navigationId != null) {
        String businessId = navigationId;
        GoRouter.of(context).pushNamed(
          routeName,
          queryParameters: {'id': businessId},
        );
      }
      break;

    case "private_group_join_requests":
      if (navigationId != null) {
        String groupId = navigationId;
        GoRouter.of(context).pushNamed(
          routeName,
          queryParameters: {'group_id': groupId},
        );
      }
      break;

    case "job_details":
      if (navigationId != null) {
        String jobId = navigationId;
        GoRouter.of(context).pushNamed(
          routeName,
          pathParameters: {'id': jobId},
        );
      }
      break;

    case "hall_of_fame":
      GoRouter.of(context).pushNamed(
        routeName,
        queryParameters: {'navigate_to_winner_tab': true.toString()},
      );
      break;
  }
}
