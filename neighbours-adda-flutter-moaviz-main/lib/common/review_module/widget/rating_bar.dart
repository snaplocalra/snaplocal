import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:snap_local/common/review_module/model/ratings_review_model.dart';

class RatingBarsWidget extends StatelessWidget {
  final RatingsBar ratingsBar;
  final int totalReviews;
  const RatingBarsWidget({
    super.key,
    required this.ratingsBar,
    required this.totalReviews,
  });

  double _progressPercentage(int startRatingCount) {
    final progressPercentage = (startRatingCount.toDouble() / totalReviews);
    return progressPercentage.isNaN ? 0 : progressPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressIndicator(
          count: 5,
          progressValue: _progressPercentage(ratingsBar.fiveStar),
        ),
        ProgressIndicator(
          count: 4,
          progressValue: _progressPercentage(ratingsBar.fourStar),
        ),
        ProgressIndicator(
          count: 3,
          progressValue: _progressPercentage(ratingsBar.threeStar),
        ),
        ProgressIndicator(
          count: 2,
          progressValue: _progressPercentage(ratingsBar.twoStar),
        ),
        ProgressIndicator(
          count: 1,
          progressValue: _progressPercentage(ratingsBar.oneStar),
        ),
      ],
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  final int count;
  final double progressValue;
  const ProgressIndicator({
    super.key,
    required this.progressValue,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$count",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: LinearPercentIndicator(
            percent: progressValue,
            progressColor: Colors.green,
            backgroundColor: Colors.black.withOpacity(0.2),
            barRadius: const Radius.circular(10),
          ),
        ),
      ],
    );
  }
}
