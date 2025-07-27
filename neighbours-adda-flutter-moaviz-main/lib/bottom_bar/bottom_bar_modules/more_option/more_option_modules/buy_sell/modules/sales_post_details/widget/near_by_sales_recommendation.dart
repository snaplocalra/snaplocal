import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/widgets/sales_post_short_details_grid_widget.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NearBySalesRecommendation extends StatefulWidget {
  const NearBySalesRecommendation({
    super.key,
    required this.nearbyList,
  });

  final List<SalesPostShortDetailsModel> nearbyList;

  @override
  State<NearBySalesRecommendation> createState() =>
      _NearBySalesRecommendationState();
}

class _NearBySalesRecommendationState extends State<NearBySalesRecommendation>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double gridHeight = 180;
    double gridWidth = 150;
    return Visibility(
      visible: widget.nearbyList.isNotEmpty,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                tr(LocaleKeys.otherNearbyRecommendations),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: gridHeight,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.nearbyList.length,
                itemBuilder: (context, index) {
                  final salesPostDetails = widget.nearbyList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: MultiBlocProvider(
                      key: ValueKey(salesPostDetails.id),
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              PostActionCubit(PostActionRepository()),
                        ),
                      ],
                      child: SalesPostShortDetailsGridWidget(
                        width: gridWidth,
                        salesPostDetails: salesPostDetails,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
