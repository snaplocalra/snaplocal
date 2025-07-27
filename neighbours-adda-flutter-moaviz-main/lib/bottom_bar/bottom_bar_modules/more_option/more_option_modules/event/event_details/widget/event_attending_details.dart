import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/models/event_attending_model.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

import '../../../../../../../utility/constant/assets_images.dart';

class EventAttendingDetails extends StatelessWidget {
  final EventAttendingModel eventAttendingModel;
  const EventAttendingDetails({
    super.key,
    required this.eventAttendingModel,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        userProfileNavigation(
          context,
          userId: eventAttendingModel.userId,
          isOwner: eventAttendingModel.isViewingUser,
        );
      },
      child: Row(
        children: [
          NetworkImageCircleAvatar(
            radius: mqSize.width * 0.06,
            imageurl: eventAttendingModel.userImage,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          userProfileNavigation(
                            context,
                            userId: eventAttendingModel.userId,
                            isOwner: eventAttendingModel.isViewingUser,
                          );
                        },
                        child: Text(
                          eventAttendingModel.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    if(eventAttendingModel.isVerified==true)...[
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        SVGAssetsImages.greenTick,
                        height: 12,
                        width: 12,
                      ),
                    ],
                    Spacer(),
                    Visibility(
                      visible: eventAttendingModel.isEventHost,
                      child: Text(
                        " - ${tr(LocaleKeys.eventHost)}",
                        style: TextStyle(
                          color: ApplicationColours.themePinkColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                AddressWithLocationIconWidget(
                  address: eventAttendingModel.location.address,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
