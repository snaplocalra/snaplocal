import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/screen/sales_post_details_screen.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class SalesPostShortDetailsListWidget extends StatelessWidget {
  final String postId;
  final String address;
  final String distance;
  final String saleItemName;
  final String saleItemPrice;
  final String itemCategory;
  final NetworkMediaModel postMedia;

  const SalesPostShortDetailsListWidget({
    super.key,
    required this.postId,
    required this.address,
    required this.distance,
    required this.saleItemName,
    required this.saleItemPrice,
    required this.itemCategory,
    required this.postMedia,
  });

  @override
  Widget build(BuildContext context) {
    // final mqSize = MediaQuery.sizeOf(context);
    const borderRadius = Radius.circular(10);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(
          SalesPostDetailsScreen.routeName,
          queryParameters: {'id': postId},
          extra: context.read<PostActionCubit>(),
        );
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
                  ClipRRect(
                    borderRadius: const BorderRadius.all(borderRadius),
                    child: CachedNetworkImage(
                      cacheKey: postMedia.mediaUrl,
                      imageUrl: postMedia.mediaUrl,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            saleItemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ApplicationColours.themeBlueColor,
                            ),
                          ),
                          Text(
                            itemCategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AddressWithLocationIconWidget(
                                    address: address,
                                    iconSize: 13,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                RouteWithDistance(
                                  distance: distance,
                                  iconSize: 12,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              saleItemPrice,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: ApplicationColours.themeLightPinkColor,
                              ),
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
