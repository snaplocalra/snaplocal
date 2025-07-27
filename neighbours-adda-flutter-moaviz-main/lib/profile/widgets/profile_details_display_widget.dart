// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../utility/constant/assets_images.dart';

class ProfileDisplayWidget extends StatelessWidget {
  final String? profileImage;
  final String? coverImage;
  final double profileImageRadius;
  final String name;
  final String? location;
  final String bio;
  final String languagesKnown;
  final String occupation;
  final String workPlace;
  final bool isVerified;
  final GenderEnum gender;
  final Widget? profileEditButton;
  const ProfileDisplayWidget({
    super.key,
    required this.profileImage,
    this.coverImage,
    this.profileImageRadius = 55,
    required this.name,
    required this.location,
    required this.bio,
    required this.languagesKnown,
    required this.gender,
    required this.occupation,
    required this.workPlace,
    required this.isVerified,
    this.profileEditButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            //Profile Image
            profileImage != null
                ? GestureDetector(
                    onTap: () {
                      showImageViewer(
                        context,
                        CachedNetworkImageProvider(profileImage!),
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                        backgroundColor: Colors.black,
                      );
                    },
                    child: NetworkImageCircleAvatar(
                      radius: profileImageRadius,
                      imageurl: profileImage!,
                    ),
                  )
                : CircleAvatar(
                    radius: profileImageRadius,
                    child: Text(
                      name[0],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),

            //Edit Button
            if (profileEditButton != null)
              Positioned(
                right: 0,
                top: 0,
                child: profileEditButton!,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  //Name
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
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

                  //Gender
                  Visibility(
                    visible: gender.isGenderAvalable,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: const Color.fromRGBO(0, 25, 104, 0.2),
                        child: SvgPicture.asset(
                          gender.svgIcon,
                          fit: BoxFit.fitWidth,
                          height: 22,
                          width: 22,
                          colorFilter: ColorFilter.mode(
                            ApplicationColours.themeBlueColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //Bio
              if (location != null)
                AddressWithLocationIconWidget(address: location!),
              Visibility(
                visible: bio.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: RichText(
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                        text: "${tr(LocaleKeys.bio)}: ",
                        style: TextStyle(
                          color: ApplicationColours.themeBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: bio,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              //Occupation
              Visibility(
                visible: occupation.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Occupation: ",
                        style: TextStyle(
                          color: ApplicationColours.themeBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: occupation,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              //Workplace
              Visibility(
                visible: workPlace.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Workplace: ",
                        style: TextStyle(
                          color: ApplicationColours.themeBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: workPlace,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              //Languages Known
              Visibility(
                visible: languagesKnown.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "${tr(LocaleKeys.languagesKnown)}: ",
                        style: TextStyle(
                          color: ApplicationColours.themeBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: languagesKnown,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
