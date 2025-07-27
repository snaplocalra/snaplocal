// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/group_post_profile_picture_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

import '../../../../../../../utility/constant/assets_images.dart';
import '../../../../master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'post_privacy_visibility_widget.dart';

class GroupPostHeadingWidget extends StatelessWidget {
  const GroupPostHeadingWidget({
    super.key,
    required this.onProfileTap,
    required this.groupPostPrivacy,
    required this.groupName,
    required this.address,
    required this.userImageUrl,
    required this.userName,
    required this.postType,
    this.userType,
    required this.createdAt,
    required this.groupImageUrl,
    required this.onGroupProfileTap,
    this.onPostTypeTap,
    required this.isVerified,
  });

  final String groupName;
  final PostVisibilityControlEnum groupPostPrivacy;
  final String address;
  final String groupImageUrl;
  final String userImageUrl;
  final String userName;
  final String postType;
  final String? userType;
  final DateTime createdAt;
  final bool isVerified;
  final void Function()? onProfileTap;
  final void Function()? onGroupProfileTap;
  final void Function()? onPostTypeTap;

  // final void Function(String pageId) onPageProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GroupPostProfilePictureWidget(
          groupImageUrl: groupImageUrl,
          userImageUrl: userImageUrl,
          onGroupImageTap: onGroupProfileTap,
          onUserImageTap: onProfileTap,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  //Profile navigation
                  onTap: onGroupProfileTap,
                  child: Row(
                    children: [
                      PostPrivacyVisibilityWidget(
                        postPrivacy: groupPostPrivacy,
                      ),
                      Text(
                        groupName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color.fromRGBO(113, 108, 108, 1),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onProfileTap,
                      ),
                      if (address.isNotEmpty) TextSpan(text: " . $address"),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  FormatDate.ddMMampm(createdAt),
                  style: const TextStyle(
                    color: Color.fromRGBO(113, 108, 108, 1),
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: onPostTypeTap,
                  child: Text(
                    postType,
                    style: TextStyle(
                      color: onPostTypeTap != null
                          ? ApplicationColours.themeBlueColor
                          : const Color.fromRGBO(113, 108, 108, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      decoration: onPostTypeTap != null
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
