import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/market_places/interested_people_list/model/interested_people_model.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';

import '../../../../utility/constant/assets_images.dart';

class InterestedPeopleDetails extends StatelessWidget {
  final InterestedPeopleModel interestedPeopleModel;
  const InterestedPeopleDetails({
    super.key,
    required this.interestedPeopleModel,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        userProfileNavigation(
          context,
          userId: interestedPeopleModel.userId,
          isOwner: interestedPeopleModel.isViewingUser,
        );
      },
      child: Row(
        children: [
          NetworkImageCircleAvatar(
            radius: mqSize.width * 0.06,
            imageurl: interestedPeopleModel.userImage,
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
                            userId: interestedPeopleModel.userId,
                            isOwner: interestedPeopleModel.isViewingUser,
                          );
                        },
                        child: Text(
                          interestedPeopleModel.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    if(interestedPeopleModel.isVerified==true)...[
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        SVGAssetsImages.greenTick,
                        height: 12,
                        width: 12,
                      ),
                    ],
                  ],
                ),
                AddressWithLocationIconWidget(
                  address: interestedPeopleModel.location.address,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
