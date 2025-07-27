import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/screen/sales_post_details_screen.dart';
import 'package:snap_local/common/utils/models/price_model.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/common/utils/widgets/strip_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SalesPostCardWidget extends StatelessWidget {
  final NetworkMediaModel media;
  final String id;
  final String title;
  final String category;
  final String address;
  final String distance;
  final PriceModel? price;
  final bool isBought;
  final bool isSold;

  const SalesPostCardWidget(
      {super.key,
      required this.id,
      required this.media,
      required this.title,
      required this.category,
      required this.address,
      required this.distance,
      required this.price,
      this.isBought = false, 
      this.isSold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(
            SalesPostDetailsScreen.routeName,
            queryParameters: {'id': id},
            extra: context.read<PostActionCubit>(),
          );
        },
        child: AbsorbPointer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkMediaWidget(
                media: media,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          isSold
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 180 *
                                          3.14159 /
                                          180, // Convert degree to radian
                                      // : 0,
                                      child: SvgPicture.asset(
                                        // type.svgPath,
                                        SVGAssetsImages.redStrip,
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      tr('Sold'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : isBought
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 180 *
                                          3.14159 /
                                          180, // Convert degree to radian
                                      // : 0,
                                      child: SvgPicture.asset(
                                        // type.svgPath,
                                        SVGAssetsImages.greenStrip,
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      tr('Intrested'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),

                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 5,
                          //     vertical: 2,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Colors.green,
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   child: const Text(
                          //     'Intrested',
                          //     style: TextStyle(
                          //       fontSize: 11,
                          //       fontWeight: FontWeight.w600,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ) : SizedBox.shrink()
                        ],
                      ),
                      Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: AddressWithLocationIconWidget(
                                address: address,
                                iconSize: 11,
                                fontSize: 11,
                                icon: Icons.location_on_outlined,
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                              child: VerticalDivider(
                                width: 15,
                                thickness: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 0.4),
                              ),
                            ),
                            RouteWithDistance(distance: distance),
                          ],
                        ),
                      ),
                      Text(
                        price != null
                            ? price!.formattedPrice
                            : tr(LocaleKeys.free),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ApplicationColours.themeLightPinkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
