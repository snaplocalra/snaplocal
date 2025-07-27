import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/compliment_badge/widgets/complimented_by_users_dialog.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class ComplimentBadgeWidget extends StatelessWidget {
  const ComplimentBadgeWidget({
    super.key,
    required this.badge,
    required this.userId,
  });

  final ComplimentBadgeModel badge;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: badge.isSelected
              ? badge.isNewSelection
                  ? ApplicationColours.themeLightPinkColor
                  : Colors.blue
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge image
          SvgPicture.network(
            badge.image,
            height: 45,
            width: 45,
            fit: BoxFit.cover,
          ),
          // Badge name
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          //badge count
          if (badge is ComplimentBadgeSender &&
              (badge as ComplimentBadgeSender).count > 0)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ComplimentedByUsersDialog(
                    userId: userId,
                    badgeId: badge.id,
                  ),
                );
              },
              child: AbsorbPointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.network(
                      ReactionNetworkImages.like,
                      height: 10,
                      width: 10,
                    ),
                    const SizedBox(width: 2),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.white,
                      child: Text(
                        (badge as ComplimentBadgeSender).count.formatNumber(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: ApplicationColours.themeBlueColor,
                        ),
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

class ComplimentBadgeViewWidget extends StatelessWidget {
  const ComplimentBadgeViewWidget({
    super.key,
    required this.badge,
    required this.userId,
  });

  final ComplimentBadgeModel badge;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.isAssigned?1:0.3,
      child: Container(
        // padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 3),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(
        //     color: badge.isSelected
        //         ? badge.isNewSelection
        //             ? ApplicationColours.themeLightPinkColor
        //             : Colors.blue
        //         : Colors.transparent,
        //     width: 2,
        //   ),
        //   // boxShadow: [
        //   //   BoxShadow(
        //   //     color: Colors.grey.shade500,
        //   //     spreadRadius: 0,
        //   //     blurRadius: 0,
        //   //     offset: const Offset(0, 3), // changes the position of the shadow
        //   //   ),
        //   // ],
        // ),
        child: SvgPicture.network(
          badge.image,
          height: 34,
          width: 34,
          fit: BoxFit.fill,
        ),
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.all(5),
    //   decoration: BoxDecoration(
    //     color: Colors.grey.shade300,
    //     borderRadius: BorderRadius.circular(10),
    //     border: Border.all(
    //       color: badge.isSelected
    //           ? badge.isNewSelection
    //               ? ApplicationColours.themeLightPinkColor
    //               : Colors.blue
    //           : Colors.transparent,
    //       width: 2,
    //     ),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.shade500,
    //         spreadRadius: 0,
    //         blurRadius: 0,
    //         offset: const Offset(0, 3), // changes the position of the shadow
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       // Badge image
    //       SvgPicture.network(
    //         badge.image,
    //         height: 45,
    //         width: 45,
    //         fit: BoxFit.cover,
    //       ),
    //       // Badge name
    //       FittedBox(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 5),
    //           child: Text(
    //             badge.name,
    //             textAlign: TextAlign.center,
    //             style: const TextStyle(
    //               fontSize: 11,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ),
    //       ),
    //
    //       //badge count
    //       if (badge is ComplimentBadgeSender &&
    //           (badge as ComplimentBadgeSender).count > 0)
    //         GestureDetector(
    //           onTap: () {
    //             showDialog(
    //               context: context,
    //               builder: (context) => ComplimentedByUsersDialog(
    //                 userId: userId,
    //                 badgeId: badge.id,
    //               ),
    //             );
    //           },
    //           child: AbsorbPointer(
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 SvgPicture.network(
    //                   ReactionNetworkImages.like,
    //                   height: 10,
    //                   width: 10,
    //                 ),
    //                 const SizedBox(width: 2),
    //                 CircleAvatar(
    //                   radius: 8,
    //                   backgroundColor: Colors.white,
    //                   child: Text(
    //                     (badge as ComplimentBadgeSender).count.formatNumber(),
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 11,
    //                       fontWeight: FontWeight.w500,
    //                       color: ApplicationColours.themeBlueColor,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}
