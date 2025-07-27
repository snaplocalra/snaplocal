import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

import '../../../../../../../../utility/constant/assets_images.dart';

class PageDetailWidget extends StatelessWidget {
  final double horizontalPadding;
  final String pageName;
  final String category;
  final int followerCount;
  final String description;
  final bool showFollower;
  final bool isVerified;
  final VoidCallback? onTap;

  const PageDetailWidget({
    super.key,
    required this.horizontalPadding,
    required this.pageName,
    required this.category,
    required this.followerCount,
    required this.description,
    required this.showFollower,
    required this.isVerified,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                pageName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
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
          RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              children: [
                // TextSpan(
                //   text: category,
                //   style: TextStyle(
                //     color: ApplicationColours.themeBlueColor,
                //     fontSize: 12,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                if(category!="")
                WidgetSpan(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffecf1ff),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
                      child: Text(
                        category,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ApplicationColours.themeBlueColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                if (showFollower)
                  WidgetSpan(
                    child: Padding(
                      padding: category!=""? EdgeInsets.only(left: 5.0):EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: onTap,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffecf1ff),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
                            child: Text(
                              '$followerCount ${followerCount > 1 ? 'Followers' : 'Follower'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: ApplicationColours.themeBlueColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
