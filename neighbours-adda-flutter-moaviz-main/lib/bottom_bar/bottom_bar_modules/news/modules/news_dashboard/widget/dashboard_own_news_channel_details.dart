import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/model/manage_news_channel_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/screen/create_news_channel_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/square_button.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class DashboardOwnNewsChannelDetails extends StatelessWidget {
  const DashboardOwnNewsChannelDetails({
    super.key,
    required this.newsChannelInfo,
  });

  final ManageNewsChannelModel newsChannelInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          NetworkImageCircleAvatar(
            imageurl: newsChannelInfo.coverImageUrl!,
            radius: 22,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              newsChannelInfo.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SquareButton(
            svgSize: 18,
            buttonTextSize: 11,
            svgAsset: SVGAssetsImages.edit,
            svgColor: Colors.white,
            buttonText: tr(LocaleKeys.edit),
            textColor: Colors.white,
            decoration: BoxDecoration(
              color: ApplicationColours.themeBlueColor,
              border: Border.all(
                color: ApplicationColours.themeBlueColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            onTap: () {
              GoRouter.of(context).pushNamed(
                CreateNewsChannelScreen.routeName,
                extra: newsChannelInfo,
              );
            },
          ),
        ],
      ),
    );
  }
}
