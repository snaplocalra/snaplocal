import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/profile_image_with_compliment_badge.dart';
import 'package:snap_local/common/utils/follower_list/screen/influencer_follower_list_screen.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_selection_strategy.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_type.dart';
import 'package:snap_local/profile/compliment_badge/widgets/compliment_dialog.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/profile/profile_level/widget/level_badge_widget.dart';
import 'package:snap_local/profile/widgets/direct_edit_photo_button.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_followers.dart';
import '../../common/utils/follower_list/screen/follower_list_screen.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final ProfileDetailsModel profileDetailsModel;
  final bool isOwnProfile;
  final bool isOfficial;
  const ProfileDetailsWidget({
    super.key,
    required this.profileDetailsModel,
    required this.isOwnProfile, required this.isOfficial,
  });

  @override
  Widget build(BuildContext context) {
    List<String> titles=profileDetailsModel.name.split(" ");
    final mqSize = MediaQuery.sizeOf(context);

    final knownLanguages = profileDetailsModel.languageKnownList.languages
        .map((e) => e.name)
        .join(',');

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: 300,
            child: Stack(
              children: [
                //Cover Image
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showImageViewer(
                          context,
                          CachedNetworkImageProvider(
                            profileDetailsModel.coverImage,
                          ),
                          swipeDismissible: true,
                          doubleTapZoomable: true,
                          backgroundColor: Colors.black,
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: profileDetailsModel.coverImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // if (isOwnProfile)
                    //   const Positioned(
                    //     right: 12,
                    //     top: 100,
                    //     child: DirectEditPhotoButton(
                    //       isCoverPic: true,
                    //     ),
                    //   )
                  ],
                ),
      
                Positioned(
                  bottom: 2,
                  left: 0,
                  child: SizedBox(
                    width: mqSize.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              //Profile Image
                              GestureDetector(
                                onTap: () {
                                  showImageViewer(
                                    context,
                                    CachedNetworkImageProvider(
                                      profileDetailsModel.profileImage,
                                    ),
                                    swipeDismissible: true,
                                    doubleTapZoomable: true,
                                    backgroundColor: Colors.black,
                                  );
                                },
                                child: ProfileImageWithComplimentBadge(
                                  profileImage: profileDetailsModel.profileImage,
                                  complimentBadgeModel: isOfficial?null:profileDetailsModel.complimentBadgeModel,
                                  showBadgeName: true,
                                ),
                              ),
      
                              //Edit Button
                              if (isOwnProfile)
                                const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: DirectEditPhotoButton(
                                    isCoverPic: false,
                                  ),
                                ),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, 15),
                            child: LevelBadgeWidget(
                              showName: true,
                              userId: profileDetailsModel.id,
                              isOfficialUser: isOfficial,
                              levelBadgeModel:
                                  profileDetailsModel.levelBadgeModel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Compliment Badge
                if(!isOfficial)...[
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => ComplimentDialog(
                          userId: profileDetailsModel.id,
                          complimentType: isOwnProfile
                              ? OwnProfileCompliment(
                            dialogHeadingText:
                            "Select badge to add to your profile",
                            selectionStrategy:
                            SingleComplimentBadgeSelectionStrategy(),
                          )
                              : SendCompliment(
                            dialogHeadingText: "Compliment with this badge",
                            receiverId: profileDetailsModel.id,
                            selectionStrategy:
                            MultiSelectComplimentBadgeSelectionStrategy(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //svg image
                        SvgPicture.asset(
                          isOwnProfile
                              ? SVGAssetsImages.edit
                              : SVGAssetsImages.giveCompliment,
                          height: isOwnProfile ? 15 : 25,
                          width: isOwnProfile ? 15 : 25,
                          colorFilter: ColorFilter.mode(
                            ApplicationColours.themeBlueColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          isOwnProfile
                              ? "Badges from Locals"
                              : "Give Compliment",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: ApplicationColours.themeBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ComplimentView(
                      userId: profileDetailsModel.id,
                      complimentType: isOwnProfile
                          ? OwnProfileCompliment(
                        dialogHeadingText:
                        "Select badge to add to your profile",
                        selectionStrategy:
                        SingleComplimentBadgeSelectionStrategy(),
                      )
                          : SendCompliment(
                        dialogHeadingText: "Compliment with this badge",
                        receiverId: profileDetailsModel.id,
                        selectionStrategy:
                        MultiSelectComplimentBadgeSelectionStrategy(),
                      ),
                    ),
                  ),
                ],
      
                Padding(
                  padding: EdgeInsets.only(top: isOfficial?8:2),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      //Name
                      if(isOfficial)
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            for(int i=0;i<titles.length;i++)
                              TextSpan(
                                text: "${titles[i]}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: i%2==0?ApplicationColours.themeBlueColor:ApplicationColours.themePinkColor,
                                ),
                              ),
                          ],
                        ),
                      )
                      else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profileDetailsModel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if(profileDetailsModel.isVerified==true)...[
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
                      if(!isOfficial)
                      Visibility(
                        visible: profileDetailsModel.gender.isGenderAvalable,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              profileDetailsModel.gender.svgIcon,
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
                      if(profileDetailsModel.levelBadgeModel.isVerified==true)...[
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
                //followers count
                  Padding(
                  padding: const EdgeInsets.only(top: 2.0,bottom: 2),
                  child: InkWell(
                    onTap: () {
                      // final pageFollowers = PageFollowers(
                      //   profileSettingsModel: context.read<ProfileSettingsCubit>().state.profileSettingsModel!,
                      //   isPageAdmin: pageProfileDetails.isPageAdmin,
                      //   pageName: pageProfileDetails.name,
                      //   isVerified: pageProfileDetails.isVerified,
                      //   category: pageProfileDetails.category.selectedCategories.map((e) => e.name).join(","),
                      //   followerCount: pageProfileDetails.totalFollowers,
                      //   descrption: pageProfileDetails.description,
                      //   showFollower: pageProfileDetails.showFollower || pageProfileDetails.isPageAdmin,
                      // );
      
                      GoRouter.of(context).pushNamed(
                        InfluencerFollowerListScreen.routeName,
                        queryParameters: {
                          'id': profileDetailsModel.id,
                        },
                      );
                    },
      
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffecf1ff),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
                        child: Text(
                          '${profileDetailsModel.followersCount} ${profileDetailsModel.followersCount! > 1 ? 'Followers' : 'Follower'}',
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
                //location
                if (profileDetailsModel.location != null)
                  AddressWithLocationIconWidget(
                    hideIcon: isOfficial,
                    address: isOfficial?"Stay connected with your community":profileDetailsModel.location!.address,
                  ),
      
                //Bio
                Visibility(
                  visible: profileDetailsModel.bio.isNotEmpty,
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
                          text: profileDetailsModel.bio,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
      
                //Occupation
                Visibility(
                  visible: profileDetailsModel.occupation.isNotEmpty,
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
                          text: profileDetailsModel.occupation,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
      
                //Workplace
                Visibility(
                  visible: profileDetailsModel.workPlace.isNotEmpty,
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
                          text: profileDetailsModel.workPlace,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
      
                //Languages Known
                Visibility(
                  visible: knownLanguages.isNotEmpty,
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
                          text: knownLanguages,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
