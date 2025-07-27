import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/refer_earn/screen/refer_earn_screen.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ProfileRewardsDisplayWidget extends StatelessWidget {
  final String rewardBatchImageUrl;
  final String rewardsPoints;
  final bool showReferEarn;
  const ProfileRewardsDisplayWidget({
    super.key,
    required this.rewardBatchImageUrl,
    required this.rewardsPoints,
    this.showReferEarn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: rewardBatchImageUrl,
          height: 25,
          width: 25,
          fit: BoxFit.scaleDown,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rewardsPoints.substring(
                0,
                rewardsPoints.length > 10 ? 10 : rewardsPoints.length,
              ),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              (rewardsPoints == "0" || rewardsPoints == "1")
                  ? tr(LocaleKeys.point)
                  : tr(LocaleKeys.points),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Visibility(
          visible: showReferEarn,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(ReferEarnScreen.routeName);
            },
            child: SvgPicture.asset(
              SVGAssetsImages.giftBox,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }
}
