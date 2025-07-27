// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/loading_screen.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/market_places/owner_activity_details/logic/extract_owner_activity_data_from_link/extract_owner_activity_data_from_link_cubit.dart';
import 'package:snap_local/common/market_places/owner_activity_details/logic/fetch_owner_activity_details/fetch_owner_activity_details_cubit.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_screen_data.dart';
import 'package:snap_local/common/market_places/owner_activity_details/repository/owner_activity_details_repository.dart';
import 'package:snap_local/common/market_places/owner_activity_details/widget/owner_activity_details_widget_by_type.dart';
import 'package:snap_local/common/market_places/owner_activity_details/widget/recommendation_by_type_wise_activity.dart';
import 'package:snap_local/common/market_places/widgets/post_owner_details.dart';
import 'package:snap_local/common/review_module/widget/give_rating_widget.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/common/utils/widgets/square_border_svg_button.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ShareOwnerActivityDetails extends StatelessWidget {
  final String encryptedData;

  const ShareOwnerActivityDetails({
    super.key,
    required this.encryptedData,
  });

  static const routeName = 'share_owner_activity_details';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtractOwnerActivityDataFromLinkCubit()
        ..extractOwnerActivityData(encryptedData),
      child: BlocBuilder<ExtractOwnerActivityDataFromLinkCubit,
          ExtractOwnerActivityDataFromLinkState>(
        builder: (context, extractOwnerActivityDataFromLinkState) {
          if (extractOwnerActivityDataFromLinkState.error != null) {
            return ErrorTextWidget(
              error: extractOwnerActivityDataFromLinkState.error!,
            );
          } else if (extractOwnerActivityDataFromLinkState.dataLoading) {
            return const LoadingScreen();
          } else {
            final ownerActivityScreenData =
                extractOwnerActivityDataFromLinkState.ownerActivityScreenData!;
            return OwnerActivityDetailsScreen(
              postId: ownerActivityScreenData.postId,
              ownerActivityType: ownerActivityScreenData.ownerActivityType,
            );
          }
        },
      ),
    );
  }
}

class OwnerActivityDetailsScreen extends StatelessWidget {
  final String postId;
  final String? appBarTitle;
  final OwnerActivityType ownerActivityType;

  const OwnerActivityDetailsScreen({
    super.key,
    required this.postId,
    this.appBarTitle,
    required this.ownerActivityType,
  });

  static const routeName = 'owner_activity_details';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FetchOwnerActivityDetailsCubit(OwnerActivityDetailsRepository())
                ..fetchOwnerActivityDetails(
                  ownerActivityType: ownerActivityType,
                  postId: postId,
                ),
        ),
        BlocProvider(create: (context) => ReportCubit(ReportRepository())),
      ],
      child: Scaffold(
        appBar: ThemeAppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: appBarTitle != null
              ? Text(
                  appBarTitle!,
                  style: TextStyle(
                    color: ApplicationColours.themeBlueColor,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
        body: BlocBuilder<FetchOwnerActivityDetailsCubit,
            FetchOwnerActivityDetailsState>(
          builder: (context, fetchOwnerActivityDetailsState) {
            if (fetchOwnerActivityDetailsState.error != null) {
              return ErrorTextWidget(
                  error: fetchOwnerActivityDetailsState.error!);
            } else if (fetchOwnerActivityDetailsState.dataLoading) {
              return const ThemeSpinner(size: 35);
            } else {
              final ownerActivity =
                  fetchOwnerActivityDetailsState.ownerActivityDetailsModel!;
              final postOwnerDetails = ownerActivity.postOwnerDetails;

              return ListView(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 5),
                    child: PostOwnerDetails(
                      id: postOwnerDetails.id,
                      name: postOwnerDetails.name,
                      image: postOwnerDetails.image,
                      address: postOwnerDetails.address,
                      isVerified: postOwnerDetails.isVerified,
                      ratingsModel: postOwnerDetails.ratingsModel,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: OwnerActivityDetailsWidgetByType(
                      ownerActivity: ownerActivity,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedHideWidget(
                          visible: !ownerActivity.hasUserRated,
                          child: GiveRatingWidget(
                            postId: postId,
                            ratingType: ownerActivityType.ratingType,
                            refreshAfterReview: () async {
                              await context
                                  .read<FetchOwnerActivityDetailsCubit>()
                                  .fetchOwnerActivityDetails(
                                    ownerActivityType: ownerActivityType,
                                    postId: postId,
                                  );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SquareBorderSvgButton(
                              svgImage: SVGAssetsImages.share,
                              text: "SHARE",
                              onTap: () {
                                final ownerActivityDetails =
                                    OwnerActivityDetailsScreenData(
                                  postId: postId,
                                  ownerActivityType: ownerActivityType,
                                );

                                //Open share
                                context.read<ShareCubit>().encryptionShare(
                                      context,
                                      jsonData: ownerActivityDetails.toJson(),
                                      screenURL:
                                          ShareOwnerActivityDetails.routeName,
                                      shareSubject: "Owner Activity Share",
                                    );
                              },
                            ),
                            SquareBorderSvgButton(
                              svgImage: SVGAssetsImages.report,
                              text: tr(LocaleKeys.report).toUpperCase(),
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                  ReportScreen.routeName,
                                  extra: OwnerActivityReportPayload(
                                    userId: postOwnerDetails.id,
                                    reportCubit: context.read<ReportCubit>(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Recommendation
                  RecommendationByTypeWiseActivity(
                    ownerActivityDetails: ownerActivity,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
