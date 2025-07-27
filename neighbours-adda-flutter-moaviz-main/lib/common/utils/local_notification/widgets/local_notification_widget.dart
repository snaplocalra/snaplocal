import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snap_local/common/utils/local_notification/model/local_notification_model.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/local_notification/helper/notification_tap_navigation.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class LocalNotificationWidget extends StatelessWidget {
  final LocalNotificationModel localNotificationModel;
  const LocalNotificationWidget({
    super.key,
    required this.localNotificationModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final navigationModel =
            localNotificationModel.notificationTapNavigationModel;
        if (navigationModel != null) {
          await handleNotificationNavigation(context, navigationModel);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageCircleAvatar(
            radius: 22,
            imageurl: localNotificationModel.image,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localNotificationModel.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  localNotificationModel.timming,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color.fromRGBO(141, 135, 137, 1),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: ThemeDivider(thickness: 2),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
