// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/send_post_to_connections.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/share_post_link_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/share_repost_widget.dart';
import 'package:snap_local/utility/common/widgets/or_divider_widget.dart';

class SharePostDialog extends StatelessWidget {
  const SharePostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Repost post widget
            ShareRepostWidget(),

            //Send post as message
            SendPostToConnections(),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: ORDivider(
                textColor: Colors.grey,
                textFontSize: 12,
                dividerHeight: 10,
                dividerColor: Colors.grey,
              ),
            ),

            //Share link
            SharePostLinkWidget(),
          ],
        ),
      ),
    );
  }
}

class UpdateSocialPostDialog extends StatelessWidget {
  const UpdateSocialPostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: const ShareRepostWidget(isEditSharedPost: true),
      ),
    );
  }
}
