import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PageInviteButton extends StatelessWidget {
  const PageInviteButton({
    super.key,
    required this.buttonHeight,
    required this.pageId,
  });

  final double buttonHeight;
  final String pageId;

  @override
  Widget build(BuildContext context) {
    return ConnectionActionButton(
      prefixSvg: SVGAssetsImages.invite,
      height: buttonHeight,
      buttonName: LocaleKeys.invite,
      onPressed: () {
        context.read<ShareCubit>().generalShare(
              context,
              data: pageId,
              screenURL: PageDetailsScreen.routeName,
              shareSubject: 'Invite to join page',
            );
      },
    );
  }
}

// class PageAnalyticsButton extends StatelessWidget {
//   const PageAnalyticsButton({
//     super.key,
//     required this.buttonHeight,
//     required this.pageId,
//     this.backgroundColor,
//     this.foregroundColor,
//   });

//   final double buttonHeight;
//   final String pageId;
//   final Color? backgroundColor;
//   final Color? foregroundColor;

//   @override
  // Widget build(BuildContext context) {
    // return ConnectionActionButton(
    //   height: buttonHeight,
    //   buttonName: "Analytics",
    //   backgroundColor: backgroundColor ?? ApplicationColours.themeBlueColor,
    //   foregroundColor: foregroundColor ?? Colors.white,
    //   onPressed: () {
    //     print("heree");
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const PageAnalyticsScreen()),
    //     );
      // },
  //   );
  // }
// }
