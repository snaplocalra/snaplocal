import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/logic/block_controller/block_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/model/news_channel_block_handler.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/model/news_channel_overview_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/screen/channel_overview_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class ChannelHeadingView extends StatelessWidget {
  final NewsChannelInfoModel newsChannelInfo;

  const ChannelHeadingView({super.key, required this.newsChannelInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NetworkImageCircleAvatar(
          imageurl: newsChannelInfo.coverImage,
          radius: 30,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsChannelInfo.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "Posted on ${FormatDate.yMMMd(newsChannelInfo.createdAt)}",
              style: const TextStyle(
                color: Color.fromRGBO(35, 32, 31, 1),
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color.fromRGBO(215, 244, 254, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      newsChannelInfo.totalFollowers.formatNumber(),
                      style: TextStyle(
                        color: ApplicationColours.themeBlueColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      newsChannelInfo.totalFollowers <= 1
                          ? tr(LocaleKeys.follower)
                          : tr(LocaleKeys.followers),
                      style: TextStyle(
                        color: ApplicationColours.themeBlueColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        BlocBuilder<BlockControllerCubit, BlockControllerState>(
          builder: (context, blockControllerState) {
            return Row(
              children: [
                InkWell(
                  onTap: blockControllerState is BlockControllerLoading
                      ? null
                      : () {
                          context.read<BlockControllerCubit>().blockExcecute(
                              NewsChannelBlockHandler(newsChannelInfo.id));
                        },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ApplicationColours.themeBlueColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: blockControllerState is BlockControllerLoading
                        ? const ThemeSpinner(size: 25)
                        : Column(
                            children: [
                              SvgPicture.asset(
                                SVGAssetsImages.block,
                                height: 15,
                                width: 15,
                                colorFilter: ColorFilter.mode(
                                  ApplicationColours.themeBlueColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Text(
                                newsChannelInfo.blockedByYou
                                    ? tr(LocaleKeys.unBlock)
                                    : tr(LocaleKeys.block),
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: ApplicationColours.themeBlueColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: blockControllerState is BlockControllerLoading
                      ? null
                      : () {
                          context.read<ShareCubit>().generalShare(
                                context,
                                data: newsChannelInfo.id,
                                screenURL: ChannelOverViewScreen.routeName,
                                shareSubject: "Check out this news channel",
                              );
                        },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ApplicationColours.themeBlueColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          SVGAssetsImages.share,
                          height: 15,
                          width: 15,
                        ),
                        Text(
                          tr(LocaleKeys.share),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: ApplicationColours.themeBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
