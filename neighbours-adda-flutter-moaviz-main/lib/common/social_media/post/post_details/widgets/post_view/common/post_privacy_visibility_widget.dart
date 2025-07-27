import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_privacy_control/post_privacy_control_cubit.dart';
import 'package:snap_local/utility/common/widgets/custom_tool_tip.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PostPrivacyVisibilityWidget extends StatelessWidget {
  final PostVisibilityControlEnum postPrivacy;
  const PostPrivacyVisibilityWidget({
    super.key,
    required this.postPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return CustomToolTip(
      triggerMode: TooltipTriggerMode.tap,
      message: "Visible to ${tr(postPrivacy.displayName)}",
      child: SvgPicture.asset(
        postPrivacy.svgPath,
        height: 18,
        width: 18,
        colorFilter: ColorFilter.mode(
          ApplicationColours.themeBlueColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
