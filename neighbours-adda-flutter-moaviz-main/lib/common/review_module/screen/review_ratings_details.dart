import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/review_module/logic/ratings_review_details/ratings_review_details_cubit.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/repository/ratings_review_repository.dart';
import 'package:snap_local/common/review_module/widget/customer_review_widget.dart';
import 'package:snap_local/common/review_module/widget/rating_bar.dart';
import 'package:snap_local/common/review_module/widget/rating_details.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class RatingsReviewDetailsScreen extends StatefulWidget {
  final String id;
  final RatingType ratingType;
  const RatingsReviewDetailsScreen({
    super.key,
    required this.id,
    required this.ratingType,
  });
  static const routeName = 'ratings_review_details';

  @override
  State<RatingsReviewDetailsScreen> createState() =>
      RatingsReviewDetailsScreenState();
}

class RatingsReviewDetailsScreenState
    extends State<RatingsReviewDetailsScreen> {
  final customerReviewsScrollController = ScrollController();

  late RatingsReviewDetailsCubit ratingsReviewDetailsCubit =
      RatingsReviewDetailsCubit(RatingsReviewRepository());

  @override
  void initState() {
    super.initState();
    ratingsReviewDetailsCubit.fetchRatingsAndReviewsDetails(
      id: widget.id,
      ratingType: widget.ratingType,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerReviewsScrollController.addListener(() {
        if (customerReviewsScrollController.position.maxScrollExtent ==
            customerReviewsScrollController.offset) {
          ratingsReviewDetailsCubit
              .fetchRatingsAndReviewsDetails(
                id: widget.id,
                loadMoreData: true,
                ratingType: widget.ratingType,
              );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    customerReviewsScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ratingsReviewDetailsCubit,
      child: Scaffold(
        appBar: ThemeAppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text(
            tr(LocaleKeys.ratingsAndReviews),
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<RatingsReviewDetailsCubit, RatingsReviewDetailsState>(
            builder: (context, ratingsReviewDetailsState) {
          if (ratingsReviewDetailsState.error != null) {
            return ErrorTextWidget(error: ratingsReviewDetailsState.error!);
          } else if (ratingsReviewDetailsState.dataLoading ||
              !ratingsReviewDetailsState.isRatingsReviewModelAvailable) {
            return const ThemeSpinner(size: 35);
          } else {
            final ratingsReview = ratingsReviewDetailsState.ratingsReviewModel!;

            return ListView(
              controller: customerReviewsScrollController,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RatingsDetails(
                          starRatings: ratingsReview.ratings.starRating,
                          totalReviews: ratingsReview.ratings.totalReview,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: VerticalDivider(
                          thickness: 2,
                          width: 20,
                        ),
                      ),
                      Expanded(
                        child: RatingBarsWidget(
                          ratingsBar: ratingsReview.ratingsBar,
                          totalReviews: ratingsReview.ratings.totalReview,
                        ),
                      )
                    ],
                  ),
                ),
                CustomerReviewList(
                  id: widget.id,
                  customerReviewModel: ratingsReview.customerReviewModel,
                  ownReview: ratingsReview.ownReview,
                  ratingType: widget.ratingType,
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
