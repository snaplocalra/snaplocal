// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:snap_local/common/review_module/model/ratings_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class RatingsReviewModel extends Equatable {
  final RatingsModel ratings;

  final RatingsBar ratingsBar;
  final CustomerReview? ownReview;
  final CustomerReviewModel customerReviewModel;

  const RatingsReviewModel({
    required this.ratings,
    required this.ratingsBar,
    required this.ownReview,
    required this.customerReviewModel,
  });

  factory RatingsReviewModel.fromJson(Map<String, dynamic> json) =>
      RatingsReviewModel(
        ratings: RatingsModel.fromMap(json["ratings"]),
        ratingsBar: RatingsBar.fromJson(json["ratings_bar"]),
        ownReview: json["own_review"] == null
            ? null
            : CustomerReview.fromJson(json["own_review"]),
        customerReviewModel:
            CustomerReviewModel.fromMap(json["customer_reviews"]),
      );

  RatingsReviewModel copyWith({
    RatingsModel? ratings,
    RatingsBar? ratingsBar,
    CustomerReview? ownReview,
    CustomerReviewModel? customerReviewModel,
  }) {
    return RatingsReviewModel(
      ratings: ratings ?? this.ratings,
      ratingsBar: ratingsBar ?? this.ratingsBar,
      ownReview: ownReview ?? this.ownReview,
      customerReviewModel: customerReviewModel ?? this.customerReviewModel,
    );
  }

  @override
  List<Object?> get props => [
        ratings,
        ratingsBar,
        ownReview,
        customerReviewModel,
      ];
}

class CustomerReviewModel {
  final List<CustomerReview> customerReviews;
  PaginationModel paginationModel;

  CustomerReviewModel({
    required this.customerReviews,
    required this.paginationModel,
  });

  factory CustomerReviewModel.fromMap(Map<String, dynamic> map) {
    return CustomerReviewModel(
      customerReviews: List<CustomerReview>.from(
        (map['data']).map((x) => CustomerReview.fromJson(x)),
      ),
      paginationModel: PaginationModel.fromMap(map),
    );
  }

  //Use for pagination
  CustomerReviewModel copyWith({required CustomerReviewModel newData}) {
    customerReviews.addAll(newData.customerReviews);
    paginationModel = newData.paginationModel;
    return CustomerReviewModel(
      customerReviews: customerReviews,
      paginationModel: paginationModel,
    );
  }
}

class CustomerReview {
  final String id;
  final String name;
  final String imageUrl;
  final String customerId;
  final double starRating;
  final String address;
  final String comment;
  final bool ownReview;
  final bool isVerified;
  final DateTime reviewTime;

  CustomerReview({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.customerId,
    required this.starRating,
    required this.address,
    required this.comment,
    required this.ownReview,
    required this.isVerified,
    required this.reviewTime,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        id: json["id"],
        name: json["name"],
        imageUrl: json["customer_image"],
        customerId: json["customer_id"],
        starRating: double.parse(json["star_rating"].toString()),
        address: json["address"],
        comment: json["comment"],
        ownReview: json["own_review"],
        isVerified: json["is_verified"],
        reviewTime: DateTime.fromMillisecondsSinceEpoch(json["review_time"]),
      );

  CustomerReview copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? customerId,
    double? starRating,
    String? address,
    String? comment,
    bool? ownReview,
    bool? isVerified,
    DateTime? reviewTime,
  }) {
    return CustomerReview(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      customerId: customerId ?? this.customerId,
      starRating: starRating ?? this.starRating,
      address: address ?? this.address,
      comment: comment ?? this.comment,
      ownReview: ownReview ?? this.ownReview,
      isVerified: isVerified ?? this.isVerified,
      reviewTime: reviewTime ?? this.reviewTime,
    );
  }
}

class RatingsBar {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;

  RatingsBar({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  factory RatingsBar.fromJson(Map<String, dynamic> json) => RatingsBar(
        oneStar: json["one_star"],
        twoStar: json["two_star"],
        threeStar: json["three_star"],
        fourStar: json["four_star"],
        fiveStar: json["five_star"],
      );
}
