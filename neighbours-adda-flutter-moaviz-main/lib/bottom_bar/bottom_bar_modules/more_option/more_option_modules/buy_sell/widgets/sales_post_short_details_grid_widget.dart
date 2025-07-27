// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/screen/sales_post_details_screen.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/common/utils/widgets/strip_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SalesPostShortDetailsGridWidget extends StatefulWidget {
  final SalesPostShortDetailsModel salesPostDetails;
  final double? width;
  final void Function()? onRemoveItem;

  const SalesPostShortDetailsGridWidget({
    super.key,
    required this.salesPostDetails,
    this.width,
    this.onRemoveItem,
  });

  @override
  State<SalesPostShortDetailsGridWidget> createState() =>
      _SalesPostShortDetailsGridWidgetState();
}

class _SalesPostShortDetailsGridWidgetState
    extends State<SalesPostShortDetailsGridWidget>
    with AutomaticKeepAliveClientMixin {
  SalesPostShortDetailsModel get salesPostDetails => widget.salesPostDetails;

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    const borderRadius = Radius.circular(10);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context)
            .pushNamed(
          SalesPostDetailsScreen.routeName,
          queryParameters: {'id': salesPostDetails.id},
          extra: context.read<PostActionCubit>(),
        )
            .then((value) {
          if (widget.onRemoveItem != null && value != null && value == true) {
            widget.onRemoveItem!();
          }
        });
      },
      child: AbsorbPointer(
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            border: Border.all(width: 0.04),
            color: Colors.white,
            borderRadius: const BorderRadius.all(borderRadius),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: borderRadius,
                        topRight: borderRadius,
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(salesPostDetails.media.first.mediaUrl),
                        media: salesPostDetails.media.first,
                        width: widget.width,
                        height: widget.width,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              salesPostDetails.itemName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              salesPostDetails.category.subCategory.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: ApplicationColours.themeBlueColor,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AddressWithLocationIconWidget(
                                    address:
                                        salesPostDetails.taggedLocation.address,
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
                                RouteWithDistance(
                                    distance: salesPostDetails.distance),
                              ],
                            ),
                            Text(
                              salesPostDetails.price != null
                                  ? salesPostDetails.price!.formattedPrice
                                  : tr(LocaleKeys.free),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ApplicationColours.themeLightPinkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),

              //Strip
              if (salesPostDetails.isSold || salesPostDetails.isBought)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: StripWidget(
                    type: salesPostDetails.isSold
                        ? StripWidgetType.soldOut
                        : StripWidgetType.bought,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
