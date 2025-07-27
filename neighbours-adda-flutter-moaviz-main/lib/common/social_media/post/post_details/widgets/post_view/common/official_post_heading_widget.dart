// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_privacy_visibility_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/profile_image_with_compliment_badge.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

import '../../../../master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';

class OfficialPostHeadingWidget extends StatelessWidget {
  const OfficialPostHeadingWidget({
    super.key,
    this.onProfileTap,
    required this.postPrivacy,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.postType,
    required this.createdAt,
    this.titleSuffix,
    this.onPostTypeTap,
    this.complimentBadgeModel,
  });

  final List<String> title;
  final Widget? titleSuffix;
  final PostVisibilityControlEnum postPrivacy;
  final String address;
  final String imageUrl;
  final String postType;
  final DateTime createdAt;
  final void Function()? onProfileTap;
  final void Function()? onPostTypeTap;
  final ComplimentBadgeModel? complimentBadgeModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          //Profile navigation
          onTap: onProfileTap,
          child: ProfileImageWithComplimentBadge(
            shapeSize: 45,
            profileImage: imageUrl,
            complimentBadgeModel: complimentBadgeModel,
            borderWidth: 0,
            badgeTextSize: 3,
            badgeBgHeight: 10,
            opacityBoxSize: 1.5,
            maxBoxCount: 4,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  //Profile navigation
                  onTap: onProfileTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PostPrivacyVisibilityWidget(postPrivacy: postPrivacy),
                      const SizedBox(width: 2),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            for(int i=0;i<title.length;i++)
                              TextSpan(
                                text: title[i],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: i%2==0?ApplicationColours.themeBlueColor:ApplicationColours.themePinkColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Text(
                      //   title,
                      //   style: const TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        SVGAssetsImages.greenTick,
                        height: 12,
                        width: 12,
                      )
                    ],
                  ),
                ),
                // RichText(
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 2,
                //   text: TextSpan(
                //     style: const TextStyle(
                //       color: Color.fromRGBO(113, 108, 108, 1),
                //       fontSize: 10.5,
                //       fontWeight: FontWeight.w400,
                //     ),
                //     children: [
                //       if (address.isNotEmpty) TextSpan(text: address),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 2),
                Text(
                  FormatDate.ddMMampm(createdAt),
                  style: const TextStyle(
                    color: Color.fromRGBO(113, 108, 108, 1),
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // GestureDetector(
                //   onTap: onPostTypeTap,
                //   child: Text(
                //     postType,
                //     style: TextStyle(
                //       color: onPostTypeTap != null
                //           ? ApplicationColours.themeBlueColor
                //           : const Color.fromRGBO(113, 108, 108, 1),
                //       fontSize: 10,
                //       fontWeight: FontWeight.w400,
                //       decoration: onPostTypeTap != null
                //           ? TextDecoration.underline
                //           : null,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        if (titleSuffix != null)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: titleSuffix!,
          ),
      ],
    );
  }
}
