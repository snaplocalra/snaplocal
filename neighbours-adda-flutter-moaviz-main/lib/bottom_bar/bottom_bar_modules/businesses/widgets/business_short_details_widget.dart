import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/screen/business_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class BusinessShortDetailsWidget extends StatelessWidget {
  final String businessId;
  final String businessName;
  final String businessAddress;
  final String businessCategory;
  final NetworkMediaModel businessMedia;
  final bool hasDiscount;
  final bool discountImageUrl;
  final String distance;
  final double? ratings;
  final double? width;
  final bool unbeatableDeal;

  const BusinessShortDetailsWidget(
      {super.key,
      required this.businessId,
      required this.businessName,
      required this.businessAddress,
      required this.businessCategory,
      required this.distance,
      required this.businessMedia,
      this.hasDiscount = false,
      this.discountImageUrl = false,
      required this.ratings,
      this.width,
      required this.unbeatableDeal});

  @override
  Widget build(BuildContext context) {
    // final mqSize = MediaQuery.sizeOf(context);
    const borderRadius = Radius.circular(10);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(BusinessDetailsScreen.routeName,
            queryParameters: {'id': businessId});
      },
      child: AbsorbPointer(
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(borderRadius),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.5, // Adjust the width as needed
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: NetworkMediaWidget(
                                key: ValueKey(businessMedia.mediaUrl),
                                media: businessMedia,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 120,
                              ),
                            ),
                          ),
                          if (unbeatableDeal)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(200, 8, 128, 1),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.5, // Adjust the width as needed
                                  ),
                                ),
                                child: Text(
                                  tr(LocaleKeys.unbeatableDeal),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 8),
                                ),
                              ),
                            ),
                          if (ratings != null && ratings != 0)
                            Positioned(
                              top: 10,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(229, 88, 25, 1),
                                  borderRadius: BorderRadius.horizontal(
                                      right: borderRadius),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      ratings.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              businessName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: AddressWithLocationIconWidget(
                                address: businessAddress,
                                iconSize: 11,
                                fontSize: 11,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfffafafa),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                businessCategory,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: ApplicationColours.themeBlueColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            RouteWithDistance(distance: distance),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              //Open close strip
              // Positioned(
              //   bottom: 10,
              //   right: 0,
              //   child: StripWidget(
              //     reverseAngle: true,
              //     type: isBusinessOpen
              //         ? StripWidgetType.open
              //         : StripWidgetType.closed,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
