import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../utility/constant/assets_images.dart';

class GroupDetailWidget extends StatelessWidget {
  final double horizontalPadding;
  final String groupName;
  final String groupPrivacyType;
  final String category;
  final int followerCount;
  final String description;
  final bool showFollower;
  final bool isVerified;
  final VoidCallback? onTap;
  const GroupDetailWidget({
    super.key,
    required this.horizontalPadding,
    required this.groupName,
    required this.groupPrivacyType,
    required this.category,
    required this.followerCount,
    required this.description,
    required this.isVerified,
    required this.showFollower,
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
                groupName,
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
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: tr(groupPrivacyType),
                      ),
                      TextSpan(
                        text:
                        " $category Group. ",
                      ),
                      if(showFollower)
                        WidgetSpan(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(
                                    0xffecf1ff),
                                borderRadius:
                                BorderRadius
                                    .circular(2)),
                            padding:
                            const EdgeInsetsDirectional
                                .symmetric(
                              horizontal: 4,
                            ),
                            child: GestureDetector(
                              onTap:onTap,
                              child: RichText(
                                text: TextSpan(
                                  style:
                                  const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$followerCount',
                                      style:
                                      const TextStyle(
                                        color: Color(0xff001968),
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: followerCount > 1
                                          ? " members"
                                          : " member",
                                      style: const TextStyle(
                                          color: Color(
                                              0xff001968)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      // TextSpan(
                      //   text: groupProfileDetails
                      //               .totalMembers <=
                      //           1
                      //       ? 'member'
                      //       : 'members',
                      // ),
                    ],
                  ),
                ),
                Visibility(
                  visible: description.isNotEmpty,
                  child: Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
