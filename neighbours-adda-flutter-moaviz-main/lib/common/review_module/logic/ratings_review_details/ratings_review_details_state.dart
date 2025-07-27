part of 'ratings_review_details_cubit.dart';

class RatingsReviewDetailsState extends Equatable {
  final bool dataLoading;
  final String? error;
  final RatingsReviewModel? ratingsReviewModel;
  const RatingsReviewDetailsState({
    this.dataLoading = false,
    this.error,
    this.ratingsReviewModel,
  });

  bool get isRatingsReviewModelAvailable => ratingsReviewModel != null;

  @override
  List<Object?> get props => [ratingsReviewModel, error, dataLoading];

  RatingsReviewDetailsState copyWith({
    bool? dataLoading,
    String? error,
    RatingsReviewModel? ratingsReviewModel,
  }) {
    return RatingsReviewDetailsState(
      dataLoading: dataLoading ?? false,
      error: error,
      ratingsReviewModel: ratingsReviewModel ?? this.ratingsReviewModel,
    );
  }
}
