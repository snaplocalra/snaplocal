import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/widgets/route_with_distance_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/screen/manage_sales_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/logic/sales_post_details/sales_post_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sale_post_mark_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/repository/sales_post_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/widget/near_by_sales_recommendation.dart';
import 'package:snap_local/common/market_places/interested_people_list/screen/interested_people_list_screen.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';
import 'package:snap_local/common/market_places/owner_activity_details/screen/owner_acitvity_details_screen.dart';
import 'package:snap_local/common/market_places/send_message_to_neighbours.dart';
import 'package:snap_local/common/market_places/widgets/post_owner_details.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_button.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/model/scam_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/sales_communication_post.dart';
import 'package:snap_local/common/utils/location/widgets/map_and_feed_radius_widget.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/models/post_action_type_enum.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/common/utils/widgets/delete_dialog.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/network_media_carousels_widget.dart';
import 'package:snap_local/common/utils/widgets/square_border_svg_button.dart';
import 'package:snap_local/common/utils/widgets/svg_elevated_button.dart';
import 'package:snap_local/common/utils/widgets/svg_text_widget.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';
import 'package:text_scroll/text_scroll.dart';

class SalesPostDetailsScreen extends StatefulWidget {
  final String salesPostId;

  static const routeName = 'sales_post_details';

  const SalesPostDetailsScreen({
    super.key,
    required this.salesPostId,
  });

  @override
  State<SalesPostDetailsScreen> createState() => _SalesPostDetailsScreenState();
}

class _SalesPostDetailsScreenState extends State<SalesPostDetailsScreen> {
  late SalesPostDetailsCubit salesPostDetailsCubit;
  late ReportCubit reportCubit = ReportCubit(ReportRepository());
  late PostActionCubit postActionCubit =
      PostActionCubit(PostActionRepository());

  @override
  void initState() {
    super.initState();

    salesPostDetailsCubit = SalesPostDetailsCubit(SalesPostDetailsRepository());
    //Fetch sales details
    salesPostDetailsCubit.fetchSalesPostDetails(widget.salesPostId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: salesPostDetailsCubit),
        BlocProvider.value(value: reportCubit),
        BlocProvider.value(value: postActionCubit),
      ],
      child: BlocBuilder<SalesPostDetailsCubit, SalesPostDetailsState>(
        builder: (context, salesPostDetailsState) {
          final salesPostData = salesPostDetailsState.salesPostDetailModel;
          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: ThemeAppBar(
                enableBackButtonBackground: true,
                elevation: 0,
                titleSpacing: 0,
                actions: [
                  (salesPostDetailsState.isSalesPostDetailAvailable)
                      ? Row(
                          children: [
                            //Book mark
                            BlocConsumer<PostActionCubit, PostActionState>(
                              listener: (context, postActionState) {
                                if (postActionState.isRequestFailed) {
                                  //Reverse the status
                                  context
                                      .read<SalesPostDetailsCubit>()
                                      .updatePostSaveStatus(
                                          !salesPostData!.isSaved);
                                }
                              },
                              builder: (context, postActionState) {
                                return CircularSvgButton(
                                  svgImage: salesPostData!.isSaved
                                      ? SVGAssetsImages.saved
                                      : SVGAssetsImages.unSaved,
                                  iconColor: Colors.white,
                                  backgroundColor:
                                      ApplicationColours.themeLightPinkColor,
                                  onTap: postActionState.isSaveRequestLoading
                                      ? null
                                      : () {
                                          context
                                              .read<PostActionCubit>()
                                              .saveUnsavePost(
                                                postId: salesPostData.id,
                                                postActionType:
                                                    PostActionType.market,
                                              );
                                          context
                                              .read<SalesPostDetailsCubit>()
                                              .updatePostSaveStatus(
                                                  !salesPostData.isSaved);
                                        },
                                );
                              },
                            ),
                            //Only post admin can edit the post details
                            if (salesPostData!.isPostAdmin)
                              CircularSvgButton(
                                svgImage: SVGAssetsImages.edit,
                                iconColor: Colors.white,
                                backgroundColor:
                                    ApplicationColours.themeLightPinkColor,
                                onTap: () {
                                  GoRouter.of(context)
                                      .pushNamed(
                                        ManageSalesPostScreen.routeName,
                                        extra: salesPostData,
                                      )
                                      .whenComplete(
                                        () => context
                                            .read<SalesPostDetailsCubit>()
                                            .fetchSalesPostDetails(
                                                widget.salesPostId),
                                      );
                                },
                              ),
                            CircularSvgButton(
                              svgImage: SVGAssetsImages.allowSharing,
                              iconColor: Colors.white,
                              iconSize: 18,
                              backgroundColor:
                                  ApplicationColours.themeLightPinkColor,
                              onTap: () {
                                context.read<ShareCubit>().generalShare(
                                      context,
                                      data: widget.salesPostId,
                                      screenURL:
                                          SalesPostDetailsScreen.routeName,
                                      shareSubject:
                                          tr(LocaleKeys.checkoutthisitem),
                                    );
                              },
                            ),
                            const SizedBox(width: 5),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              body: (salesPostDetailsState.error != null)
                  ? ErrorTextWidget(error: salesPostDetailsState.error!)
                  : (salesPostDetailsState.dataLoading ||
                          !salesPostDetailsState.isSalesPostDetailAvailable)
                      ? const ThemeSpinner(size: 35)
                      : RefreshIndicator.adaptive(
                          onRefresh: () => context
                              .read<SalesPostDetailsCubit>()
                              .fetchSalesPostDetails(widget.salesPostId),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              //Media Carausel
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: NetworkMediaCarouselWidget(
                                  media: salesPostData!.media,
                                ),
                              ),
                              //Product details
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextScroll(
                                            salesPostData.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: ApplicationColours
                                                  .themeBlueColor,
                                            ),
                                            velocity: const Velocity(
                                                pixelsPerSecond: Offset(10, 0)),
                                            delayBefore:
                                                const Duration(seconds: 2),
                                            pauseBetween:
                                                const Duration(seconds: 2),
                                            fadedBorder: true,
                                            fadedBorderWidth: 0.05,
                                            fadeBorderSide:
                                                FadeBorderSide.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          salesPostData
                                              .category.subCategory.name,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                          child: VerticalDivider(
                                            width: 15,
                                            thickness: 1.5,
                                            color: Color.fromRGBO(
                                                112, 112, 112, 0.4),
                                          ),
                                        ),
                                        SvgTextWidget(
                                          svgImage: SVGAssetsImages.calendar,
                                          svgheight: 12,
                                          prefixText:
                                              "Posted on ${FormatDate.selectedDateSlashDDMMYYYY(salesPostData.createdAt)}",
                                          prefixStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromRGBO(
                                                112, 112, 112, 1),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:
                                                AddressWithLocationIconWidget(
                                              address: salesPostData
                                                  .postLocation.address,
                                              iconSize: 16,
                                              fontSize: 12,
                                              iconTopPadding: 0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                            child: VerticalDivider(
                                              width: 15,
                                              thickness: 1.5,
                                              color: Color.fromRGBO(
                                                  112, 112, 112, 0.4),
                                            ),
                                          ),
                                          RouteWithDistance(
                                            distance: salesPostData.distance,
                                            iconSize: 12,
                                            fontSize: 10,
                                          ),
                                          const SizedBox(width: 8),
                                          SvgElevatedButton(
                                            onTap: () {
                                              //Launch Google map
                                              UrlLauncher().openMap(
                                                latitude: salesPostData
                                                    .postLocation.latitude,
                                                longitude: salesPostData
                                                    .postLocation.longitude,
                                              );
                                            },
                                            svgImage:
                                                SVGAssetsImages.navigation,
                                            name: LocaleKeys.navigate,
                                            boxHeight: 20,
                                            textSize: 10,
                                            backgroundcolor: ApplicationColours
                                                .themeBlueColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          salesPostData.price != null
                                              ? salesPostData
                                                  .price!.formattedPrice
                                              : tr(LocaleKeys.free),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: ApplicationColours
                                                .themeLightPinkColor,
                                          ),
                                        ),
                                        if (salesPostData.isPostAdmin)
                                          GestureDetector(
                                            onTap: salesPostData
                                                        .interestedPeopleCount >
                                                    0
                                                ? () {
                                                    GoRouter.of(context)
                                                        .pushNamed(
                                                      InterestedPeopleListScreen
                                                          .routeName,
                                                      queryParameters: {
                                                        'id': salesPostData.id,
                                                      },
                                                      extra: MarketPlaceType
                                                          .buySell,
                                                    );
                                                  }
                                                : null,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Color.fromRGBO(
                                                    226, 233, 255, 1),
                                              ),
                                              child: Text(
                                                "${salesPostData.interestedPeopleCount.formatNumber()} ${tr(LocaleKeys.interested)}",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //Description
                              Visibility(
                                visible: salesPostData.description.isNotEmpty,
                                child: Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tr(LocaleKeys.description),
                                        style: TextStyle(
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        salesPostData.description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(35, 32, 31, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //Analytics Overview
                              if (salesPostData.isPostAdmin)
                                Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.all(10),
                                  child: AnalyticsOverviewButton(
                                    moduleId: widget.salesPostId,
                                    moduleType: AnalyticsModuleType.buyAndSell,
                                  ),
                                ),

                              //Sender Details
                              Visibility(
                                visible: !salesPostData.isPostAdmin,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  color: Colors.white,
                                  // margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SendMessageToNeighbours(
                                        scamType: ScamType.market,
                                        receiverUserId:
                                            salesPostData.sellerDetails.id,
                                        otherCommunicationModelImpl:
                                            SalesCommunicationPost(
                                          id: salesPostData.id,
                                          itemName: salesPostData.name,
                                        ),
                                      ),
                                      //Posted by
                                      Text(
                                        tr(LocaleKeys.postedBy),
                                        style: TextStyle(
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      PostOwnerDetails(
                                        id: salesPostData.sellerDetails.id,
                                        name: salesPostData.sellerDetails.name,
                                        image: salesPostData.sellerDetails.image,
                                        address: salesPostData.sellerDetails.address,
                                        isVerified: salesPostData.sellerDetails.isVerified,
                                        category: salesPostData
                                            .category.subCategory.name,
                                        postCreatedAt: salesPostData.createdAt,
                                        isOwner: salesPostData.isPostAdmin,
                                        ratingType: RatingType.market,
                                        ratingTypeId: salesPostData.id,
                                        ratingsModel: salesPostData
                                            .sellerDetails.ratingsModel,
                                        onProfileTap: () {
                                          GoRouter.of(context).pushNamed(
                                            OwnerActivityDetailsScreen
                                                .routeName,
                                            queryParameters: {
                                              "post_id": salesPostData.id,
                                              "app_bar_title":
                                                  salesPostData.name,
                                            },
                                            extra: OwnerActivityType.market,
                                          );
                                        },
                                      ),
                                      //Bottom spacing
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),

                              //Post action
                              Container(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(10),
                                child: salesPostData.isPostAdmin
                                    ? BlocConsumer<PostActionCubit,
                                        PostActionState>(
                                        listener: (context, postActionState) {
                                          if (postActionState
                                              .isDeleteRequestSuccess) {
                                            //Close the screen after delete
                                            GoRouter.of(context).pop(true);
                                          }
                                        },
                                        builder: (context, postActionState) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: SquareBorderSvgButton(
                                                  showloading:
                                                      salesPostDetailsState
                                                          .requestLoading,
                                                  svgImage: salesPostData
                                                          .isSoldout
                                                      ? SVGAssetsImages.soldout
                                                      : SVGAssetsImages.buysell,
                                                  text: salesPostData.isSoldout
                                                      ? tr(LocaleKeys
                                                          .markAsAvailable)
                                                      : tr(LocaleKeys
                                                          .markAsSold),
                                                  backgroundColor: salesPostData
                                                          .isSoldout
                                                      ? const Color.fromRGBO(
                                                          71, 105, 211, 1)
                                                      : Colors.grey[50],
                                                  foregroundColor:
                                                      salesPostData.isSoldout
                                                          ? Colors.white
                                                          : ApplicationColours
                                                              .themeBlueColor,
                                                  onTap: postActionState
                                                          .isDeleteRequestLoading
                                                      ? null
                                                      : () {
                                                          context
                                                              .read<
                                                                  SalesPostDetailsCubit>()
                                                              .markAs(
                                                                postId:
                                                                    salesPostData
                                                                        .id,
                                                                salesPostMarkType: salesPostData.isSoldout
                                                                    ? SalesPostMarkType
                                                                        .markAsAvailable
                                                                    : SalesPostMarkType
                                                                        .soldout,
                                                              );
                                                        },
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SquareBorderSvgButton(
                                                showloading: postActionState
                                                    .isDeleteRequestLoading,
                                                svgImage:
                                                    SVGAssetsImages.delete,
                                                text: tr(LocaleKeys.delete),
                                                onTap: salesPostDetailsState
                                                        .requestLoading
                                                    ? null
                                                    : () async {
                                                        HapticFeedback
                                                            .heavyImpact();
                                                        await showDeleteAlertDialog(
                                                          context,
                                                          description: tr(
                                                            LocaleKeys
                                                                .areyousureyouwanttopermanentlyremovethispost,
                                                          ),
                                                        ).then((allowDelete) {
                                                          if (allowDelete &&
                                                              context.mounted) {
                                                            //Api call
                                                            context
                                                                .read<
                                                                    PostActionCubit>()
                                                                .deleteMarketPlacePost(
                                                                  postId:
                                                                      salesPostData
                                                                          .id,
                                                                  marketPlaceType:
                                                                      MarketPlaceType
                                                                          .buySell,
                                                                );
                                                          }
                                                        });
                                                      },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : Builder(builder: (context) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //click to show interest
                                            Visibility(
                                              visible: !salesPostData.isSoldout,
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child:
                                                        SquareBorderSvgButton(
                                                      showloading:
                                                          salesPostDetailsState
                                                              .requestLoading,
                                                      svgImage: SVGAssetsImages
                                                          .bought,
                                                      backgroundColor:
                                                          salesPostData
                                                                  .isInterested
                                                              ? const Color
                                                                  .fromRGBO(71,
                                                                  105, 211, 1)
                                                              : Colors.grey[50],
                                                      foregroundColor: salesPostData
                                                              .isInterested
                                                          ? Colors.white
                                                          : ApplicationColours
                                                              .themeBlueColor,
                                                      text: salesPostData
                                                              .isInterested
                                                          ? tr(LocaleKeys
                                                              .clickToRemoveInterest)
                                                          : tr(LocaleKeys
                                                              .clickToShowInterest),
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                SalesPostDetailsCubit>()
                                                            .markAs(
                                                              postId:
                                                                  salesPostData
                                                                      .id,
                                                              salesPostMarkType:
                                                                  salesPostData
                                                                          .isInterested
                                                                      ? SalesPostMarkType
                                                                          .unmarkAsBought
                                                                      : SalesPostMarkType
                                                                          .bought,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 5,
                                                      left: 60,
                                                      right: 0,
                                                      child: Icon(Icons.star,
                                                          color: salesPostData
                                                                  .isInterested
                                                              ? Colors.yellow
                                                              : ApplicationColours
                                                                  .themeBlueColor,
                                                          size: 20))
                                                ],
                                              ),
                                            ),
                                            //Report
                                            Visibility(
                                              visible: !salesPostData
                                                      .isPostAdmin &&
                                                  !salesPostData.reportedByUser,
                                              child: BlocListener<ReportCubit,
                                                  ReportState>(
                                                listener:
                                                    (context, reportState) {
                                                  if (reportState
                                                      .requestSuccess) {
                                                    //pop screen
                                                    GoRouter.of(context).pop();
                                                  }
                                                },
                                                child: SquareBorderSvgButton(
                                                  svgImage:
                                                      SVGAssetsImages.report,
                                                  text: tr(LocaleKeys.report),
                                                  onTap: () {
                                                    GoRouter.of(context)
                                                        .pushNamed(
                                                      ReportScreen.routeName,
                                                      extra:
                                                          SalesPostReportPayload(
                                                        salesPostId:
                                                            salesPostData.id,
                                                        reportCubit:
                                                            context.read<
                                                                ReportCubit>(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                              ),

                              //Item location
                              if (salesPostData.taggedlocation != null)
                                Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: WidgetHeading(
                                          title: tr(LocaleKeys.itemLocation),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: MapWithMarker(
                                          hideMarker:
                                              salesPostData.hideExactLocation,
                                          preSelectedLatLng: LatLng(
                                            salesPostData
                                                .taggedlocation!.latitude,
                                            salesPostData
                                                .taggedlocation!.longitude,
                                          ),
                                          circleRadius: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              //Other Near By Recommendation
                              Visibility(
                                visible: salesPostData
                                    .nearByRecommendation.isNotEmpty,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: NearBySalesRecommendation(
                                    nearbyList:
                                        salesPostData.nearByRecommendation,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}
