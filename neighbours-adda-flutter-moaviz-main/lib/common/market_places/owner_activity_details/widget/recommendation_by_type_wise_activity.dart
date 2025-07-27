//Recommendation based on the type of activity
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/screen/sales_post_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_short_details_widget.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_model.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class RecommendationByTypeWiseActivity extends StatelessWidget {
  final OwnerActivityDetailsModel ownerActivityDetails;

  const RecommendationByTypeWiseActivity({
    super.key,
    required this.ownerActivityDetails,
  });

  @override
  Widget build(BuildContext context) {
    switch (ownerActivityDetails.runtimeType) {
      case const (BuySellActivityModel):
        final buySellData = ownerActivityDetails as BuySellActivityModel;

        return
            //Items from seller
            buySellData.itemsFromSeller.isNotEmpty
                ? Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LocaleKeys.itemsFromSeller),
                          style: TextStyle(
                            color: ApplicationColours.themeBlueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: buySellData.itemsFromSeller.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final item = buySellData.itemsFromSeller[index];
                              final imageUrl = item.media.first.mediaUrl;
                              return BlocProvider(
                                create: (context) =>
                                    PostActionCubit(PostActionRepository()),
                                child: Builder(builder: (context) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: GestureDetector(
                                      onTap: () {
                                        GoRouter.of(context).pushNamed(
                                          SalesPostDetailsScreen.routeName,
                                          queryParameters: {'id': item.id},
                                          extra: PostActionCubit(
                                              PostActionRepository()),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),
                      ],
                    ),
                  )
                : throw ("Unsupported media type");

      case const (JobActivityModel):
        final jobData = ownerActivityDetails as JobActivityModel;

        return
            //Jobs posted by owner
            jobData.jobsPostedByOwner.isNotEmpty
                ? Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${LocaleKeys.jobPostedBy} ${ownerActivityDetails.postOwnerDetails.name}",
                          style: TextStyle(
                            color: ApplicationColours.themeBlueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: jobData.jobsPostedByOwner.length,
                          itemBuilder: (context, index) {
                            final jobsDetails =
                                jobData.jobsPostedByOwner[index];
                            return BlocProvider(
                              key: ValueKey(jobsDetails.id),
                              create: (context) => JobShortViewControllerCubit(
                                  jobShortDetailsModel: jobsDetails),
                              child: const JobShortDetailsWidget(),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();

      default:
        throw Exception("Unknown type: $ownerActivityDetails");
    }
  }
}
