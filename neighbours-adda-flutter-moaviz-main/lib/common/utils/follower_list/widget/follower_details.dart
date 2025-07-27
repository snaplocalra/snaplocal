import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/action_dialog_widget.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../model/follower_list_model.dart';

class FollowerDetails extends StatelessWidget {
  final FollowerModel followerModel;
  final bool isAdmin;
  final bool isBlockByAdmin;
  final void Function()? onBlockUser;
  const FollowerDetails({
    super.key,
    required this.followerModel,
    required this.isAdmin,
    required this.isBlockByAdmin,
    this.onBlockUser,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        userProfileNavigation(
          context,
          userId: followerModel.userId,
          isOwner: followerModel.isViewingUser,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Opacity(
              opacity: (isAdmin && isBlockByAdmin) ? 0.5 : 1,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  NetworkImageCircleAvatar(
                    radius: mqSize.width * 0.06,
                    imageurl: followerModel.userImage,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    userProfileNavigation(
                                      context,
                                      userId: followerModel.userId,
                                      isOwner: followerModel.isViewingUser,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        followerModel.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if(followerModel.isVerified==true)...[
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
                              ),
                            ),
                          ],
                        ),
                        AddressWithLocationIconWidget(
                          address: followerModel.location.address,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //show the button if the user is admin and the follower is not admin
          if (isAdmin && !followerModel.isAdmin)
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                showDialog(
                  context: context,
                  builder: (dialogContext) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //block user
                          ActionDialogOption(
                            showdivider: false,
                            svgImage: SVGAssetsImages.block,
                            title: isBlockByAdmin
                                ? tr(LocaleKeys.unBlock)
                                : tr(LocaleKeys.block),
                            subtitle: isBlockByAdmin
                                // "You can unblock this user"
                                ? tr(LocaleKeys.youcanunblockthisuser)
                                // "You can block this user",
                                : tr(LocaleKeys.youcanblockthisuser),
                            onTap: () async {
                              await showConfirmationDialog(
                                dialogContext,
                                confirmationButtonText: isBlockByAdmin
                                    ? tr(LocaleKeys.unBlock)
                                    : tr(LocaleKeys.block),
                                message: isBlockByAdmin
                                    // 'Are you sure you want to permanently unblock this user?'
                                    ? tr(LocaleKeys
                                        .areyousureyouwanttopermanentlyunblockthisuser)
                                    // 'Are you sure you want to permanently block this user?',
                                    : tr(LocaleKeys
                                        .areyousureyouwanttopermanentlyblockthisuser),
                              ).then((allow) {
                                if (allow != null && allow) {
                                  //block the user

                                  onBlockUser?.call();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert, size: 18),
            ),
        ],
      ),
    );
  }
}
