import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class RatingsDetails extends StatelessWidget {
  const RatingsDetails({
    super.key,
    required this.starRatings,
    required this.totalReviews,
  });

  final double starRatings;
  final int totalReviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          starRatings.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: RatingStars(
            value: starRatings > 5 ? 5 : starRatings,
            starBuilder: (index, color) => Icon(
              Icons.star,
              color: color,
              size: 25,
            ),
            valueLabelVisibility: false,
            starCount: 5,
            starSize: 25,
            maxValue: 5,
            starSpacing: 0,
            animationDuration: const Duration(milliseconds: 1000),
            starOffColor: const Color(0xffe7e8ea),
            starColor: const Color.fromRGBO(243, 141, 24, 1),
          ),
        ),
        Text(
          "(${totalReviews.formatNumber()} ${totalReviews <= 1 ? 'review' : 'reviews'})",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(33, 35, 41, 0.6),
          ),
        ),
      ],
    );
  }
}
