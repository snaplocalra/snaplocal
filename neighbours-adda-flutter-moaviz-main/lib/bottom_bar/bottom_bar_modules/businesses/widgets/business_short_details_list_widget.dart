import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/screen/business_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class BusinessShortDetailsListWidget extends StatelessWidget {
  final String businessId;
  final String businessName;
  final String businessAddress;
  final String businessCategory;
  final NetworkMediaModel businessMedia;
  final String distance;
  final double? ratings;

  const BusinessShortDetailsListWidget({
    super.key,
    required this.businessId,
    required this.businessName,
    required this.businessAddress,
    required this.businessCategory,
    required this.distance,
    required this.businessMedia,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    const borderRadius = Radius.circular(10);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(BusinessDetailsScreen.routeName,
            queryParameters: {'id': businessId});
      },
      child: AbsorbPointer(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(borderRadius),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(borderRadius),
                        child: CachedNetworkImage(
                          cacheKey: businessMedia.mediaUrl,
                          imageUrl: businessMedia.mediaUrl,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      if (ratings != null)
                        Positioned(
                          top: mqSize.height * 0.015,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(229, 88, 25, 1),
                              borderRadius:
                                  BorderRadius.horizontal(right: borderRadius),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  ratings.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            businessName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: AddressWithLocationIconWidget(
                                      address: businessAddress,
                                      iconSize: 13,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                RouteWithDistance(
                                  distance: distance,
                                  iconSize: 13,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            businessCategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ApplicationColours.themeBlueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const ThemeDivider(thickness: 2),
            ],
          ),
        ),
      ),
    );
  }
}
