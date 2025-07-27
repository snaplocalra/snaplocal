// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_alert_dialog.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/review_module/logic/manage_rating/manage_rating_cubit.dart';
import 'package:snap_local/common/review_module/logic/ratings_review_details/ratings_review_details_cubit.dart';
import 'package:snap_local/common/review_module/model/ratings_review_model.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/repository/ratings_review_repository.dart';
import 'package:snap_local/common/review_module/widget/give_rating_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/profile/profile_details/own_profile/screen/own_profile_screen.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

import '../../../utility/constant/assets_images.dart';

class CustomerReviewList extends StatefulWidget {
  const CustomerReviewList({
    super.key,
    required this.customerReviewModel,
    required this.id,
    this.ownReview,
    required this.ratingType,
  });

  final CustomerReviewModel customerReviewModel;
  final String id;
  final CustomerReview? ownReview;
  final RatingType ratingType;

  @override
  State<CustomerReviewList> createState() => _CustomerReviewListState();
}

class _CustomerReviewListState extends State<CustomerReviewList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ManageRatingCubit(ratingsReviewRepository: RatingsReviewRepository()),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                tr(LocaleKeys.yourReview),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            //Own review
            widget.ownReview != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: CustomerReviewWidget(
                      name: widget.ownReview!.name,
                      imageUrl: widget.ownReview!.imageUrl,
                      startRating: widget.ownReview!.starRating,
                      address: widget.ownReview!.address,
                      comment: widget.ownReview!.comment,
                      isVerified: widget.ownReview!.isVerified,
                      reviewTime: widget.ownReview!.reviewTime,
                      actions: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child:
                            BlocBuilder<ManageRatingCubit, ManageRatingState>(
                          builder: (context, manageRatingState) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: manageRatingState.requestLoading
                                      ? null
                                      : () {
                                          showDialog(
                                            barrierDismissible: false,
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
                                                      //Close the dialog box
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: GiveRatingWidget(
                                                      manageRatingCubit:
                                                          context.read<
                                                              ManageRatingCubit>(),
                                                      existingReview:
                                                          widget.ownReview!,
                                                      postId: widget.id,
                                                      ratingType:
                                                          widget.ratingType,
                                                      refreshAfterReview:
                                                          () async {
                                                        await context
                                                            .read<
                                                                RatingsReviewDetailsCubit>()
                                                            .fetchRatingsAndReviewsDetails(
                                                              id: widget.id,
                                                              ratingType: widget
                                                                  .ratingType,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  child: Text(
                                    tr(LocaleKeys.edit),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: manageRatingState.requestLoading
                                          ? Colors.grey
                                          : ApplicationColours
                                              .themeLightPinkColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: manageRatingState.requestLoading
                                      ? null
                                      : () {
                                          showThemeAlertDialog(
                                            context: context,
                                            onAcceptPressed: () {
                                              context
                                                  .read<ManageRatingCubit>()
                                                  .deleteReview(
                                                    reviewId:
                                                        widget.ownReview!.id,
                                                    postId: widget.id,
                                                    ratingType:
                                                        widget.ratingType,
                                                    refreshAfterReview:
                                                        () async {
                                                      await context
                                                          .read<
                                                              RatingsReviewDetailsCubit>()
                                                          .fetchRatingsAndReviewsDetails(
                                                            id: widget.id,
                                                            ratingType: widget
                                                                .ratingType,
                                                          );
                                                    },
                                                  );
                                            },
                                            title: tr(LocaleKeys
                                                .areYouSureyouWantToDeleteYourReview),
                                          );
                                        },
                                  child: Text(
                                    tr(LocaleKeys.delete),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: manageRatingState.requestLoading
                                          ? Colors.grey
                                          : ApplicationColours
                                              .themeLightPinkColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      onTap: () {
                        //If the post is user own post, then open the own posts and profile
                        GoRouter.of(context)
                            .pushNamed(OwnProfilePostsScreen.routeName);
                      },
                    ),
                  )
                :
                //Add review
                Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: BlocBuilder<ManageRatingCubit, ManageRatingState>(
                        builder: (context, manageRatingState) {
                          return ThemeElevatedButton(
                            backgroundColor: ApplicationColours.themeBlueColor,
                            width: 100,
                            height: 30,
                            textFontSize: 10,
                            showLoadingSpinner:
                                manageRatingState.requestLoading,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ManageRatingCubit>(),
                                  child: Dialog(
                                    child: BlocListener<ManageRatingCubit,
                                        ManageRatingState>(
                                      listener: (context, manageRatingState) {
                                        if (manageRatingState.requestSuccess) {
                                          //Close the dialog box
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GiveRatingWidget(
                                          manageRatingCubit:
                                              context.read<ManageRatingCubit>(),
                                          postId: widget.id,
                                          ratingType: widget.ratingType,
                                          refreshAfterReview: () async {
                                            await context
                                                .read<
                                                    RatingsReviewDetailsCubit>()
                                                .fetchRatingsAndReviewsDetails(
                                                  id: widget.id,
                                                  ratingType: widget.ratingType,
                                                );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            buttonName: tr(LocaleKeys.addReview),
                          );
                        },
                      ),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                tr(LocaleKeys.customerReviews),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            widget.customerReviewModel.customerReviews.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        tr(LocaleKeys.noPublicReviewsAvailable),
                      ),
                    ),
                  )
                :
                //Other user review
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    itemCount:
                        widget.customerReviewModel.customerReviews.length + 1,
                    itemBuilder: (context, index) {
                      if (index <
                          widget.customerReviewModel.customerReviews.length) {
                        final customerReview =
                            widget.customerReviewModel.customerReviews[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: CustomerReviewWidget(
                            name: customerReview.name,
                            imageUrl: customerReview.imageUrl,
                            startRating: customerReview.starRating,
                            address: customerReview.address,
                            comment: customerReview.comment,
                            isVerified: customerReview.isVerified,
                            reviewTime: customerReview.reviewTime,
                            onTap: () {
                              //Else then open the Neighbours posts and profile
                              GoRouter.of(context).pushNamed(
                                NeighboursProfileAndPostsScreen.routeName,
                                queryParameters: {
                                  'id': customerReview.customerId
                                },
                              );
                            },
                          ),
                        );
                      } else if (widget
                          .customerReviewModel.paginationModel.isLastPage) {
                        return const SizedBox.shrink();
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: ThemeSpinner(size: 40),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class CustomerReviewWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double startRating;
  final String address;
  final String comment;
  final bool isVerified;
  final DateTime reviewTime;
  final Widget? actions;
  final void Function() onTap;
  const CustomerReviewWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.startRating,
    required this.address,
    required this.comment,
    required this.isVerified,
    required this.reviewTime,
    this.actions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onTap,
              child: NetworkImageCircleAvatar(
                imageurl: imageUrl,
                radius: 20,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if(isVerified==true)...[
                          const SizedBox(width: 2),
                          SvgPicture.asset(
                            SVGAssetsImages.greenTick,
                            height: 12,
                            width: 12,
                          ),
                        ],
                      ],
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color.fromRGBO(113, 108, 108, 1),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          if (address.isNotEmpty)
                            TextSpan(
                              text: "$address . ",
                            ),
                          TextSpan(
                            text: FormatDate.ddMMampm(reviewTime),
                          ),
                        ],
                      ),
                    ),

                    //Actions widget
                    if (actions != null) actions!,
                  ],
                ),
              ),
            ),
            RatingStars(
              value: startRating,
              valueLabelVisibility: false,
              starCount: 5,
              starSize: 15,
              maxValue: 5,
              starSpacing: 4,
              starOffColor: const Color(0xffe7e8ea),
              starColor: const Color.fromRGBO(243, 141, 24, 1),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: comment.isNotEmpty,
          child: Text(comment),
        ),
        const ThemeDivider(thickness: 2),
      ],
    );
  }
}
