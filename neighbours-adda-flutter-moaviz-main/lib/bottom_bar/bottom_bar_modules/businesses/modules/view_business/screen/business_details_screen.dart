// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/logic/business_details/business_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/repository/business_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/widgets/business_discount.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/widgets/business_hours_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/widgets/near_by_business_recommendation.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/common/market_places/send_message_to_neighbours.dart';
import 'package:snap_local/common/review_module/logic/manage_rating/manage_rating_cubit.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/repository/ratings_review_repository.dart';
import 'package:snap_local/common/review_module/screen/review_ratings_details.dart';
import 'package:snap_local/common/review_module/widget/give_rating_widget.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_button.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/model/scam_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/business_communication_post.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/network_media_carousels_widget.dart';
import 'package:snap_local/common/utils/widgets/square_border_svg_button.dart';
import 'package:snap_local/common/utils/widgets/svg_elevated_button.dart';
import 'package:snap_local/common/utils/widgets/svg_text_widget.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../../../tutorial_screens/tutorial_logic/logic.dart';
import '../../../logic/business_check/business_check_cubit.dart';
import '../../manage_business/screen/create_or_update_business_screen.dart';

class BusinessDetailsScreen extends StatefulWidget {
  final String businessId;
  static const routeName = 'business_details';
  final void Function() onBusinessFetch;

  const BusinessDetailsScreen({super.key, required this.businessId, required this.onBusinessFetch});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  late BusinessDetailsCubit businessDetailsCubit =
      BusinessDetailsCubit(BusinessDetailsRepository());

  final scrollController = ScrollController();

  late ReportCubit reportCubit = ReportCubit(ReportRepository());

  @override
  void initState() {
    super.initState();
    businessDetailsCubit.fetchBusinessDetails(widget.businessId);
    //handleMyBusinessTutorial(context);
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: businessDetailsCubit),
        BlocProvider.value(value: reportCubit),
      ],
      child: BlocBuilder<BusinessDetailsCubit, BusinessDetailsState>(
        builder: (context, businessDetailsState) {
          if (businessDetailsState.error != null) {
            return ErrorTextWidget(error: businessDetailsState.error!);
          } else if (businessDetailsState.dataLoading ||
              !businessDetailsState.isBusinessViewDetailsAvailable) {
            return Scaffold(body: const ThemeSpinner(size: 35));
          } else {
            final businessDetails = businessDetailsState.businessDetailsModel!;

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  titleSpacing: 0,
                  leading: const IOSBackButton(),
                  backgroundColor: Colors.transparent,

                  actions: [
                    //Edit Button
                    if (businessDetails.isPostOwner)
                      Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircularSvgButton(
                        svgImage: SVGAssetsImages.edit,
                        iconColor: Colors.white,
                        iconSize: 18,
                        backgroundColor: ApplicationColours.themeLightPinkColor,
                        onTap: () {
                          GoRouter.of(context)
                              .pushNamed(
                            CreateOrUpdateBusinessScreen.routeName,
                            extra: businessDetails,
                          )
                              .whenComplete(() {
                            if (context.mounted) {
                              //Check business
                              context
                                  .read<BusinessCheckCubit>()
                                  .checkBusinessDetails();
                            }

                            //Fetch business
                            widget.onBusinessFetch.call();
                          });
                        },

                      ),
                    ),

                    //share button
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircularSvgButton(
                        svgImage: SVGAssetsImages.allowSharing,
                        iconColor: Colors.white,
                        iconSize: 18,
                        backgroundColor: ApplicationColours.themeLightPinkColor,
                        onTap: () {
                          context.read<ShareCubit>().generalShare(
                            context,
                            data: widget.businessId,
                            screenURL: BusinessDetailsScreen.routeName,
                            shareSubject: tr(LocaleKeys.checkOutThisBusiness),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                body: RefreshIndicator.adaptive(
                  onRefresh: () => businessDetailsCubit
                      .fetchBusinessDetails(widget.businessId),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      //Media Carausel
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: NetworkMediaCarouselWidget(
                            media: businessDetails.media),
                      ),

                      //Analytics Overview
                      if (businessDetails.isPostOwner)
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: AnalyticsOverviewButton(
                            height: 40,
                            textFontSize: 13,
                            moduleId: widget.businessId,
                            moduleType: AnalyticsModuleType.business,
                          ),
                        ),

                      //Business Details
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Business Name
                              Row(
                                children: [
                                  Expanded(
                                    child: TextScroll(
                                      businessDetails.businessName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      velocity: const Velocity(
                                          pixelsPerSecond: Offset(10, 0)),
                                      delayBefore: const Duration(seconds: 2),
                                      pauseBetween: const Duration(seconds: 2),
                                      fadedBorder: true,
                                      fadedBorderWidth: 0.05,
                                      fadeBorderSide: FadeBorderSide.right,
                                    ),
                                  ),
                                  Visibility(
                                    visible: businessDetails
                                        .ratingsModel.totalReview >
                                        0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          //Navigate to review details screen
                                          GoRouter.of(context)
                                              .pushNamed(
                                            RatingsReviewDetailsScreen
                                                .routeName,
                                            queryParameters: {
                                              'id': businessDetails.id
                                            },
                                            extra: RatingType.business,
                                          )
                                              .whenComplete(
                                                () => context
                                                .read<
                                                BusinessDetailsCubit>()
                                                .fetchBusinessDetails(
                                                widget.businessId),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Color.fromRGBO(
                                                243,
                                                141,
                                                24,
                                                1,
                                              ),
                                              size: 14,
                                            ),
                                            Text(
                                              "${businessDetails.ratingsModel.starRating} (${businessDetails.ratingsModel.totalReview} ${businessDetails.ratingsModel.totalReview == 1 ? LocaleKeys.review : LocaleKeys.reviews})",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //Shop Open or Closed
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  tr(businessDetails
                                      .businessStatus.displayValue),
                                  style: TextStyle(
                                    color: businessDetails.businessStatus.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AddressWithLocationIconWidget(
                                        address: businessDetails
                                            .businessLocation.address,
                                        iconSize: 18,
                                        fontSize: 13,
                                        iconTopPadding: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(
                                        width: 15,
                                        thickness: 1.5,
                                        color:
                                        Color.fromRGBO(112, 112, 112, 0.4),
                                      ),
                                    ),
                                    RouteWithDistance(
                                      distance: businessDetails.distance,
                                      iconSize: 14,
                                      fontSize: 12,
                                    ),
                                    const SizedBox(width: 5),
                                    SvgElevatedButton(
                                      onTap: () {
                                        //Launch Google map
                                        UrlLauncher().openMap(
                                          latitude: businessDetails
                                              .postLocation.latitude,
                                          longitude: businessDetails
                                              .postLocation.longitude,
                                        );
                                      },
                                      svgImage: SVGAssetsImages.navigation,
                                      name: LocaleKeys.navigate,
                                      backgroundcolor:
                                      ApplicationColours.themeBlueColor,
                                    ),
                                  ],
                                ),
                              ),
                              SvgTextWidget(
                                svgImage: SVGAssetsImages.basket,
                                prefixText: businessDetails.category
                                    .subCategoryString(),
                              ),

                              //Business Timings
                              BusinessHoursDisplayWidget(
                                businessHoursModel:
                                businessDetails.businessHoursModel,
                              ),

                              //Address
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgTextWidget(
                                      svgImage: SVGAssetsImages.address,
                                      prefixText: tr(LocaleKeys.address),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        businessDetails.businessAddress,
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              //Phone Number
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgTextWidget(
                                    svgImage: SVGAssetsImages.phone,
                                    prefixText: tr(LocaleKeys.phone),
                                    suffixText: businessDetails.phoneNumber,
                                  ),
                                  const SizedBox(width: 12),
                                  SvgElevatedButton(
                                    onTap: () {
                                      //start call
                                      UrlLauncher().makeCall(
                                          businessDetails.phoneNumber);
                                    },
                                    svgImage: SVGAssetsImages.callDialer,
                                    name: LocaleKeys.callNow,
                                    backgroundcolor:
                                    const Color.fromRGBO(40, 120, 21, 1),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // Sender Details
                      Visibility(
                        visible: !businessDetails.isPostOwner &&
                            businessDetails.enableChat,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: SendMessageToNeighbours(
                            heading: tr(
                                LocaleKeys.questionsChatWithTheBusinessOwner),
                            scamType: ScamType.business,
                            receiverUserId: businessDetails.postOwnerDetails.id,
                            otherCommunicationModelImpl:
                            BusinessCommunicationPost(
                              id: businessDetails.id,
                              businessName: businessDetails.businessName,
                            ),
                          ),
                        ),
                      ),

                      //Discounts
                      Visibility(
                        visible: businessDetails.hasDiscount,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    // "Discounts",
                                    tr(LocaleKeys.discounts),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: SizedBox(
                                      height: 100,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          //Discounts in percentage
                                          ListView.builder(
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: businessDetails
                                                .discountInPercentage.length,
                                            itemBuilder: (context, index) {
                                              final discount = businessDetails
                                                  .discountInPercentage[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: BusinessDiscountWidget(
                                                  businessDiscountOption:
                                                  discount,
                                                  businessDiscountType:
                                                  BusinessDiscountType
                                                      .percentage,
                                                ),
                                              );
                                            },
                                          ),

                                          //Discounts in price
                                          ListView.builder(
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: businessDetails
                                                .discountInPrice.length,
                                            itemBuilder: (context, index) {
                                              final discount = businessDetails
                                                  .discountInPrice[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: BusinessDiscountWidget(
                                                  businessDiscountOption:
                                                  discount,
                                                  businessDiscountType:
                                                  BusinessDiscountType
                                                      .price,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      //Post action
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Rate Business
                            AnimatedHideWidget(
                              //If the user didn't rate the business then show the rate button or else
                              //for the edit the viewing user review review must be available
                              visible: !businessDetails.hasUserRated ||
                                  businessDetails.viewingUserReview != null,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: BlocProvider(
                                  create: (context) => ManageRatingCubit(
                                      ratingsReviewRepository:
                                      RatingsReviewRepository()),
                                  child: BlocBuilder<ManageRatingCubit,
                                      ManageRatingState>(
                                    builder: (context, manageRatingState) {
                                      return SquareBorderSvgButton(
                                        showloading:
                                        manageRatingState.requestLoading,
                                        svgImage: SVGAssetsImages.addReview,
                                        text: businessDetails.hasUserRated
                                            ? tr(LocaleKeys.editReview)
                                            : tr(LocaleKeys.addReview),
                                        onTap: () {
                                          //Open the give review in a dialog
                                          showDialog(
                                            barrierDismissible:
                                            !manageRatingState
                                                .requestLoading,
                                            context: context,
                                            builder: (_) => Dialog(
                                              child: BlocProvider.value(
                                                value: context
                                                    .read<ManageRatingCubit>(),
                                                child: BlocListener<
                                                    ManageRatingCubit,
                                                    ManageRatingState>(
                                                  listener: (context,
                                                      manageRatingState) {
                                                    if (manageRatingState
                                                        .requestSuccess) {
                                                      if (mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    child: GiveRatingWidget(
                                                      existingReview:
                                                      businessDetails
                                                          .viewingUserReview,
                                                      manageRatingCubit:
                                                      context.read<
                                                          ManageRatingCubit>(),
                                                      postId:
                                                      businessDetails.id,
                                                      ratingType:
                                                      RatingType.business,
                                                      refreshAfterReview:
                                                          () async {
                                                        await context
                                                            .read<
                                                            BusinessDetailsCubit>()
                                                            .fetchBusinessDetails(
                                                            widget
                                                                .businessId);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            //Website
                            Visibility(
                              visible: businessDetails.websiteLink.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: SquareBorderSvgButton(
                                  svgImage: SVGAssetsImages.website,
                                  text: tr(LocaleKeys.website),
                                  onTap: () {
                                    UrlLauncher().openWebsite(
                                        businessDetails.websiteLink);
                                  },
                                ),
                              ),
                            ),

                            //Report
                            BlocListener<ReportCubit, ReportState>(
                              listener: (context, reportState) {
                                if (reportState.requestSuccess) {
                                  //pop screen
                                  GoRouter.of(context).pop();
                                }
                              },
                              child: Visibility(
                                visible: !businessDetails.isPostOwner &&
                                    !businessDetails.reportedByUser,
                                child: SquareBorderSvgButton(
                                  svgImage: SVGAssetsImages.report,
                                  text: tr(LocaleKeys.report),
                                  onTap: () {
                                    GoRouter.of(context).pushNamed(
                                      ReportScreen.routeName,
                                      extra: BusinessDetailsReportPayload(
                                        businessId: businessDetails.id,
                                        reportCubit:
                                        context.read<ReportCubit>(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      // "Business Location",
                                      tr(LocaleKeys.businessLocation),
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 25, 104, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SizedBox(
                                      height: 150,
                                      child: MapWithMarker(
                                        circleRadius: 10,
                                        preSelectedLatLng: LatLng(
                                          businessDetails.postLocation.latitude,
                                          businessDetails
                                              .postLocation.longitude,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),

                      //Other Near By Recommendation
                      Visibility(
                        visible: businessDetails.nearbyList.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: OtherNearByBusinessRecommendation(
                            nearbyList: businessDetails.nearbyList,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return MultiBlocProvider(
  //     providers: [
  //       BlocProvider.value(value: businessDetailsCubit),
  //       BlocProvider.value(value: reportCubit),
  //     ],
  //     child: SafeArea(
  //       child: Scaffold(
  //         extendBodyBehindAppBar: true,
  //         appBar: AppBar(
  //           elevation: 0,
  //           titleSpacing: 0,
  //           leading: const IOSBackButton(),
  //           backgroundColor: Colors.transparent,
  //
  //           actions: [
  //             //Edit Button
  //             Padding(
  //               padding: const EdgeInsets.only(right: 5),
  //               child: CircularSvgButton(
  //                 svgImage: SVGAssetsImages.edit,
  //                 iconColor: Colors.white,
  //                 iconSize: 18,
  //                 backgroundColor: ApplicationColours.themeLightPinkColor,
  //               ),
  //             ),
  //
  //             //share button
  //             Padding(
  //               padding: const EdgeInsets.only(right: 5),
  //               child: CircularSvgButton(
  //                 svgImage: SVGAssetsImages.allowSharing,
  //                 iconColor: Colors.white,
  //                 iconSize: 18,
  //                 backgroundColor: ApplicationColours.themeLightPinkColor,
  //                 onTap: () {
  //                   context.read<ShareCubit>().generalShare(
  //                         context,
  //                         data: widget.businessId,
  //                         screenURL: BusinessDetailsScreen.routeName,
  //                         shareSubject: tr(LocaleKeys.checkOutThisBusiness),
  //                       );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //         body: BlocBuilder<BusinessDetailsCubit, BusinessDetailsState>(
  //           builder: (context, businessDetailsState) {
  //             if (businessDetailsState.error != null) {
  //               return ErrorTextWidget(error: businessDetailsState.error!);
  //             } else if (businessDetailsState.dataLoading ||
  //                 !businessDetailsState.isBusinessViewDetailsAvailable) {
  //               return const ThemeSpinner(size: 35);
  //             } else {
  //               final businessDetails =
  //                   businessDetailsState.businessDetailsModel!;
  //
  //               return RefreshIndicator.adaptive(
  //                 onRefresh: () => businessDetailsCubit
  //                     .fetchBusinessDetails(widget.businessId),
  //                 child: ListView(
  //                   controller: scrollController,
  //                   padding: EdgeInsets.zero,
  //                   children: [
  //                     //Media Carausel
  //                     Padding(
  //                       padding: const EdgeInsets.only(bottom: 5),
  //                       child: NetworkMediaCarouselWidget(
  //                           media: businessDetails.media),
  //                     ),
  //
  //                     //Analytics Overview
  //                     if (businessDetails.isPostOwner)
  //                       Container(
  //                         color: Colors.white,
  //                         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
  //                         child: AnalyticsOverviewButton(
  //                           height: 40,
  //                           textFontSize: 13,
  //                           moduleId: widget.businessId,
  //                           moduleType: AnalyticsModuleType.business,
  //                         ),
  //                       ),
  //
  //                     //Business Details
  //                     Container(
  //                       color: Colors.white,
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 15, vertical: 8),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             // Business Name
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: TextScroll(
  //                                     businessDetails.businessName,
  //                                     style: const TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                     velocity: const Velocity(
  //                                         pixelsPerSecond: Offset(10, 0)),
  //                                     delayBefore: const Duration(seconds: 2),
  //                                     pauseBetween: const Duration(seconds: 2),
  //                                     fadedBorder: true,
  //                                     fadedBorderWidth: 0.05,
  //                                     fadeBorderSide: FadeBorderSide.right,
  //                                   ),
  //                                 ),
  //                                 Visibility(
  //                                   visible: businessDetails
  //                                           .ratingsModel.totalReview >
  //                                       0,
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         horizontal: 5),
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         //Navigate to review details screen
  //                                         GoRouter.of(context)
  //                                             .pushNamed(
  //                                               RatingsReviewDetailsScreen
  //                                                   .routeName,
  //                                               queryParameters: {
  //                                                 'id': businessDetails.id
  //                                               },
  //                                               extra: RatingType.business,
  //                                             )
  //                                             .whenComplete(
  //                                               () => context
  //                                                   .read<
  //                                                       BusinessDetailsCubit>()
  //                                                   .fetchBusinessDetails(
  //                                                       widget.businessId),
  //                                             );
  //                                       },
  //                                       child: Row(
  //                                         children: [
  //                                           const Icon(
  //                                             Icons.star,
  //                                             color: Color.fromRGBO(
  //                                               243,
  //                                               141,
  //                                               24,
  //                                               1,
  //                                             ),
  //                                             size: 14,
  //                                           ),
  //                                           Text(
  //                                             "${businessDetails.ratingsModel.starRating} (${businessDetails.ratingsModel.totalReview} ${businessDetails.ratingsModel.totalReview == 1 ? LocaleKeys.review : LocaleKeys.reviews})",
  //                                             style: const TextStyle(
  //                                               fontSize: 12,
  //                                               fontWeight: FontWeight.w600,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //
  //                             //Shop Open or Closed
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 5),
  //                               child: Text(
  //                                 tr(businessDetails
  //                                     .businessStatus.displayValue),
  //                                 style: TextStyle(
  //                                   color: businessDetails.businessStatus.color,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               ),
  //                             ),
  //
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 5),
  //                               child: Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: AddressWithLocationIconWidget(
  //                                       address: businessDetails
  //                                           .businessLocation.address,
  //                                       iconSize: 18,
  //                                       fontSize: 13,
  //                                       iconTopPadding: 1,
  //                                     ),
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 20,
  //                                     child: VerticalDivider(
  //                                       width: 15,
  //                                       thickness: 1.5,
  //                                       color:
  //                                           Color.fromRGBO(112, 112, 112, 0.4),
  //                                     ),
  //                                   ),
  //                                   RouteWithDistance(
  //                                     distance: businessDetails.distance,
  //                                     iconSize: 14,
  //                                     fontSize: 12,
  //                                   ),
  //                                   const SizedBox(width: 5),
  //                                   SvgElevatedButton(
  //                                     onTap: () {
  //                                       //Launch Google map
  //                                       UrlLauncher().openMap(
  //                                         latitude: businessDetails
  //                                             .postLocation.latitude,
  //                                         longitude: businessDetails
  //                                             .postLocation.longitude,
  //                                       );
  //                                     },
  //                                     svgImage: SVGAssetsImages.navigation,
  //                                     name: LocaleKeys.navigate,
  //                                     backgroundcolor:
  //                                         ApplicationColours.themeBlueColor,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SvgTextWidget(
  //                               svgImage: SVGAssetsImages.basket,
  //                               prefixText: businessDetails.category
  //                                   .subCategoryString(),
  //                             ),
  //
  //                             //Business Timings
  //                             BusinessHoursDisplayWidget(
  //                               businessHoursModel:
  //                                   businessDetails.businessHoursModel,
  //                             ),
  //
  //                             //Address
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 5),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   SvgTextWidget(
  //                                     svgImage: SVGAssetsImages.address,
  //                                     prefixText: tr(LocaleKeys.address),
  //                                   ),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(left: 20),
  //                                     child: Text(
  //                                       businessDetails.businessAddress,
  //                                       style: TextStyle(
  //                                         color: Colors.black.withOpacity(0.5),
  //                                         fontSize: 12,
  //                                       ),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //
  //                             //Phone Number
  //                             Row(
  //                               crossAxisAlignment: CrossAxisAlignment.end,
  //                               children: [
  //                                 SvgTextWidget(
  //                                   svgImage: SVGAssetsImages.phone,
  //                                   prefixText: tr(LocaleKeys.phone),
  //                                   suffixText: businessDetails.phoneNumber,
  //                                 ),
  //                                 const SizedBox(width: 12),
  //                                 SvgElevatedButton(
  //                                   onTap: () {
  //                                     //start call
  //                                     UrlLauncher().makeCall(
  //                                         businessDetails.phoneNumber);
  //                                   },
  //                                   svgImage: SVGAssetsImages.callDialer,
  //                                   name: LocaleKeys.callNow,
  //                                   backgroundcolor:
  //                                       const Color.fromRGBO(40, 120, 21, 1),
  //                                 ),
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //
  //                     // Sender Details
  //                     Visibility(
  //                       visible: !businessDetails.isPostOwner &&
  //                           businessDetails.enableChat,
  //                       child: Container(
  //                         margin: const EdgeInsets.symmetric(vertical: 2),
  //                         color: Colors.white,
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 15, vertical: 8),
  //                         child: SendMessageToNeighbours(
  //                           heading: tr(
  //                               LocaleKeys.questionsChatWithTheBusinessOwner),
  //                           scamType: ScamType.business,
  //                           receiverUserId: businessDetails.postOwnerDetails.id,
  //                           otherCommunicationModelImpl:
  //                               BusinessCommunicationPost(
  //                             id: businessDetails.id,
  //                             businessName: businessDetails.businessName,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //
  //                     //Discounts
  //                     Visibility(
  //                       visible: businessDetails.hasDiscount,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(top: 3.0),
  //                         child: Container(
  //                           color: Colors.white,
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   // "Discounts",
  //                                   tr(LocaleKeys.discounts),
  //                                   style: const TextStyle(
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.w600,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       vertical: 10),
  //                                   child: SizedBox(
  //                                     height: 100,
  //                                     child: ListView(
  //                                       scrollDirection: Axis.horizontal,
  //                                       children: [
  //                                         //Discounts in percentage
  //                                         ListView.builder(
  //                                           physics:
  //                                               const NeverScrollableScrollPhysics(),
  //                                           scrollDirection: Axis.horizontal,
  //                                           shrinkWrap: true,
  //                                           itemCount: businessDetails
  //                                               .discountInPercentage.length,
  //                                           itemBuilder: (context, index) {
  //                                             final discount = businessDetails
  //                                                 .discountInPercentage[index];
  //                                             return Padding(
  //                                               padding: const EdgeInsets.only(
  //                                                   right: 15),
  //                                               child: BusinessDiscountWidget(
  //                                                 businessDiscountOption:
  //                                                     discount,
  //                                                 businessDiscountType:
  //                                                     BusinessDiscountType
  //                                                         .percentage,
  //                                               ),
  //                                             );
  //                                           },
  //                                         ),
  //
  //                                         //Discounts in price
  //                                         ListView.builder(
  //                                           physics:
  //                                               const NeverScrollableScrollPhysics(),
  //                                           scrollDirection: Axis.horizontal,
  //                                           shrinkWrap: true,
  //                                           itemCount: businessDetails
  //                                               .discountInPrice.length,
  //                                           itemBuilder: (context, index) {
  //                                             final discount = businessDetails
  //                                                 .discountInPrice[index];
  //                                             return Padding(
  //                                               padding: const EdgeInsets.only(
  //                                                   right: 15),
  //                                               child: BusinessDiscountWidget(
  //                                                 businessDiscountOption:
  //                                                     discount,
  //                                                 businessDiscountType:
  //                                                     BusinessDiscountType
  //                                                         .price,
  //                                               ),
  //                                             );
  //                                           },
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //
  //                     //Post action
  //                     Container(
  //                       color: Colors.white,
  //                       margin: const EdgeInsets.symmetric(vertical: 5),
  //                       padding: const EdgeInsets.all(10),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           //Rate Business
  //                           AnimatedHideWidget(
  //                             //If the user didn't rate the business then show the rate button or else
  //                             //for the edit the viewing user review review must be available
  //                             visible: !businessDetails.hasUserRated ||
  //                                 businessDetails.viewingUserReview != null,
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(right: 20),
  //                               child: BlocProvider(
  //                                 create: (context) => ManageRatingCubit(
  //                                     ratingsReviewRepository:
  //                                         RatingsReviewRepository()),
  //                                 child: BlocBuilder<ManageRatingCubit,
  //                                     ManageRatingState>(
  //                                   builder: (context, manageRatingState) {
  //                                     return SquareBorderSvgButton(
  //                                       showloading:
  //                                           manageRatingState.requestLoading,
  //                                       svgImage: SVGAssetsImages.addReview,
  //                                       text: businessDetails.hasUserRated
  //                                           ? tr(LocaleKeys.editReview)
  //                                           : tr(LocaleKeys.addReview),
  //                                       onTap: () {
  //                                         //Open the give review in a dialog
  //                                         showDialog(
  //                                           barrierDismissible:
  //                                               !manageRatingState
  //                                                   .requestLoading,
  //                                           context: context,
  //                                           builder: (_) => Dialog(
  //                                             child: BlocProvider.value(
  //                                               value: context
  //                                                   .read<ManageRatingCubit>(),
  //                                               child: BlocListener<
  //                                                   ManageRatingCubit,
  //                                                   ManageRatingState>(
  //                                                 listener: (context,
  //                                                     manageRatingState) {
  //                                                   if (manageRatingState
  //                                                       .requestSuccess) {
  //                                                     if (mounted) {
  //                                                       Navigator.pop(context);
  //                                                     }
  //                                                   }
  //                                                 },
  //                                                 child: ClipRRect(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10),
  //                                                   child: GiveRatingWidget(
  //                                                     existingReview:
  //                                                         businessDetails
  //                                                             .viewingUserReview,
  //                                                     manageRatingCubit:
  //                                                         context.read<
  //                                                             ManageRatingCubit>(),
  //                                                     postId:
  //                                                         businessDetails.id,
  //                                                     ratingType:
  //                                                         RatingType.business,
  //                                                     refreshAfterReview:
  //                                                         () async {
  //                                                       await context
  //                                                           .read<
  //                                                               BusinessDetailsCubit>()
  //                                                           .fetchBusinessDetails(
  //                                                               widget
  //                                                                   .businessId);
  //                                                     },
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         );
  //                                       },
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //                           //Website
  //                           Visibility(
  //                             visible: businessDetails.websiteLink.isNotEmpty,
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(right: 20),
  //                               child: SquareBorderSvgButton(
  //                                 svgImage: SVGAssetsImages.website,
  //                                 text: tr(LocaleKeys.website),
  //                                 onTap: () {
  //                                   UrlLauncher().openWebsite(
  //                                       businessDetails.websiteLink);
  //                                 },
  //                               ),
  //                             ),
  //                           ),
  //
  //                           //Report
  //                           BlocListener<ReportCubit, ReportState>(
  //                             listener: (context, reportState) {
  //                               if (reportState.requestSuccess) {
  //                                 //pop screen
  //                                 GoRouter.of(context).pop();
  //                               }
  //                             },
  //                             child: Visibility(
  //                               visible: !businessDetails.isPostOwner &&
  //                                   !businessDetails.reportedByUser,
  //                               child: SquareBorderSvgButton(
  //                                 svgImage: SVGAssetsImages.report,
  //                                 text: tr(LocaleKeys.report),
  //                                 onTap: () {
  //                                   GoRouter.of(context).pushNamed(
  //                                     ReportScreen.routeName,
  //                                     extra: BusinessDetailsReportPayload(
  //                                       businessId: businessDetails.id,
  //                                       reportCubit:
  //                                           context.read<ReportCubit>(),
  //                                     ),
  //                                   );
  //                                 },
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     Padding(
  //                         padding: const EdgeInsets.only(top: 3.0),
  //                         child: Container(
  //                             color: Colors.white,
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(
  //                                     // "Business Location",
  //                                     tr(LocaleKeys.businessLocation),
  //                                     style: const TextStyle(
  //                                       color: Color.fromRGBO(0, 25, 104, 1),
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(bottom: 8.0),
  //                                   child: SizedBox(
  //                                     height: 150,
  //                                     child: MapWithMarker(
  //                                       circleRadius: 10,
  //                                       preSelectedLatLng: LatLng(
  //                                         businessDetails.postLocation.latitude,
  //                                         businessDetails
  //                                             .postLocation.longitude,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ))),
  //
  //                     //Other Near By Recommendation
  //                     Visibility(
  //                       visible: businessDetails.nearbyList.isNotEmpty,
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 5),
  //                         child: OtherNearByBusinessRecommendation(
  //                           nearbyList: businessDetails.nearbyList,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
