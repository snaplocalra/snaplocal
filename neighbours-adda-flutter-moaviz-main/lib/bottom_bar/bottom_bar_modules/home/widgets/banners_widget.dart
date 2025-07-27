import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/home_banners_model.dart';
import 'package:snap_local/common/utils/local_notification/helper/notification_tap_navigation.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';

class BannersWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final List<HomeBannerModel> bannersList;
  const BannersWidget({
    super.key,
    required this.bannersList,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final logs = bannersList;
    return Visibility(
      visible: bannersList.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.transparent,
        height: height ?? 150,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 5),
          scrollDirection: Axis.horizontal,
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final banner = logs[index];
            return GestureDetector(
              onTap: () {
                if (banner.routeNavigationModel != null) {
                  //In application screen navigation
                  handleNotificationNavigation(
                      context, banner.routeNavigationModel!);
                } else if (banner.hyperLink != null) {
                  //open url for webview
                  UrlLauncher().openWebsite(banner.hyperLink!);
                }
              },
              child: BannerImageWidget(
                imageUrl: banner.image,
                width: width,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BannerImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;

  const BannerImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          cacheKey: imageUrl,
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          height: 150,
          width: width,
        ),
      ),
    );
  }
}
