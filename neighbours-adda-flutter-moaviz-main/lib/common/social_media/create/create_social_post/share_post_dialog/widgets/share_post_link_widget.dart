import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/screen/share_post_details_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/share/model/share_type.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SharePostLinkWidget extends StatelessWidget {
  const SharePostLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      builder: (context, shareState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: shareState.requestLoading
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr(LocaleKeys.preparingLink),
                          style: TextStyle(
                            color: ApplicationColours.themeBlueColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ThemeSpinner(
                          size: 30,
                          color: ApplicationColours.themeBlueColor,
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: shareState.requestLoading
                        ? null
                        : () {
                            //Vibrate device
                            HapticFeedback.lightImpact();

                            //Post details
                            late SocialPostModel postModel = context
                                .read<PostDetailsControllerCubit>()
                                .state
                                .socialPostModel;

                            final sharePostLinkData = SharedPostDataModel(
                              postId: postModel.id,
                              postType: postModel.postType,
                              postFrom: postModel.postFrom,
                              shareType: ShareType.deepLink,
                            );

                            //Open share
                            context.read<ShareCubit>().encryptionShare(
                                  context,
                                  jsonData: sharePostLinkData.toJson(),
                                  screenURL:
                                      SharedSocialPostDetailsByLink.routeName,
                                  shareSubject: tr(LocaleKeys.sharePost),
                                );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr(LocaleKeys.spread),
                            style: TextStyle(
                              color: ApplicationColours.themeBlueColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.adaptive.share,
                            color: ApplicationColours.themeBlueColor,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
