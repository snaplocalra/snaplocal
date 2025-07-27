import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/compliment_badge/widgets/opicity_boxes_widget.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ProfileImageWithComplimentBadge extends StatelessWidget {
  const ProfileImageWithComplimentBadge({
    super.key,
    required this.profileImage,
    required this.complimentBadgeModel,
    this.shapeSize = 120,
    this.borderWidth = 5,
    this.badgeBgHeight = 30,
    this.badgeTextSize = 6.5,
    this.opacityBoxSize = 2.5,
    this.showBadgeName = false,
    this.maxBoxCount = 8,
  });

  final double shapeSize;
  final double borderWidth;
  final String profileImage;
  final double badgeBgHeight;
  final double badgeTextSize;
  final double opacityBoxSize;
  final int maxBoxCount;
  final bool showBadgeName;
  final ComplimentBadgeModel? complimentBadgeModel;

  @override
  Widget build(BuildContext context) {
    return OctagonWidget(
      shapeSize: shapeSize,
      borderWidth: borderWidth,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: profileImage,
              fit: BoxFit.cover,
            ),
          ),

          // compliement badge
          if (complimentBadgeModel != null && (complimentBadgeModel!.count > 0 || showBadgeName))
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: badgeBgHeight,
                alignment: Alignment.center,
                color: ApplicationColours.themeBlueColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //badge count
                    FittedBox(
                      child: OpacityBoxesWidget(
                        count: complimentBadgeModel?.count??0,
                        boxSize: opacityBoxSize,
                        maxCount: maxBoxCount,
                      ),
                    ),

                    //Badge name
                    if (showBadgeName)
                      Text(
                        complimentBadgeModel!.name,
                        style: TextStyle(
                          fontSize: badgeTextSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
