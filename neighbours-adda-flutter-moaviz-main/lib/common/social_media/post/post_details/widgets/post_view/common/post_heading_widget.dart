// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_privacy_visibility_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/profile_image_with_compliment_badge.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/profile_level/model/level_badge_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

import '../../../../../../../utility/constant/assets_images.dart';
import '../../../../master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';

class PostHeadingWidget extends StatelessWidget {
  const PostHeadingWidget({
    super.key,
    this.onProfileTap,
    required this.postPrivacy,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.postType,
    this.userType,
    required this.createdAt,
    required this.isVerified,
    this.titleSuffix,
    this.onPostTypeTap,
    this.complimentBadgeModel,
    this.levelBadgeModel,
  });

  final String title;
  final Widget? titleSuffix;
  final PostVisibilityControlEnum postPrivacy;
  final String address;
  final String imageUrl;
  final String postType;
  final String? userType;
  final DateTime createdAt;
  final void Function()? onProfileTap;
  final void Function()? onPostTypeTap;
  final ComplimentBadgeModel? complimentBadgeModel;
  final LevelBadgeModel? levelBadgeModel;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    List<String> titles=title.split(" ");
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
                      if(userType=="official")...[
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              for(int i=0;i<titles.length;i++)
                                TextSpan(
                                  text: titles[i],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: i%2==0?ApplicationColours.themeBlueColor:ApplicationColours.themePinkColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 2),
                        SvgPicture.asset(
                          SVGAssetsImages.greenTick,
                          height: 12,
                          width: 12,
                        ),
                      ]
                      else
                      Row(
                        children: [
                          Text(
                            title,
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
                    ],
                  ),
                ),
                if(userType!="official")
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
                        if (address.isNotEmpty) TextSpan(text: address),
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
                if(userType!="official")
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
        if (titleSuffix != null)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: titleSuffix!,
          ),
      ],
    );
  }
}
