import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/review_module/model/ratings_review_model.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/repository/ratings_review_repository.dart';

part 'ratings_review_details_state.dart';

class RatingsReviewDetailsCubit extends Cubit<RatingsReviewDetailsState> {
  final RatingsReviewRepository ratingsReviewRepository;
  RatingsReviewDetailsCubit(this.ratingsReviewRepository)
      : super(const RatingsReviewDetailsState());

  Future<void> fetchRatingsAndReviewsDetails({
    bool loadMoreData = false,
    required String id,
    required RatingType ratingType,
  }) async {
    try {
      if (state.error != null && !state.isRatingsReviewModelAvailable) {
        emit(state.copyWith(dataLoading: !loadMoreData));
      }

      if (loadMoreData && state.ratingsReviewModel != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.ratingsReviewModel!.customerReviewModel.paginationModel
            .isLastPage) {
          //Increase the current page counter
          state.ratingsReviewModel!.customerReviewModel.paginationModel
              .currentPage += 1;
          final moreData =
              await ratingsReviewRepository.fetchRatingsReviewDetails(
            page: state.ratingsReviewModel!.customerReviewModel.paginationModel
                .currentPage,
            id: id,
            ratingType: ratingType,
          );

          emit(
            state.copyWith(
              ratingsReviewModel: state.ratingsReviewModel!.copyWith(
                customerReviewModel:
                    state.ratingsReviewModel!.customerReviewModel.copyWith(
                  newData: moreData.customerReviewModel,
                ),
              ),
            ),
          );
          return;
        }
      } else {
        final reviews = await ratingsReviewRepository.fetchRatingsReviewDetails(
          id: id,
          ratingType: ratingType,
        );
        emit(state.copyWith(ratingsReviewModel: reviews));
      }

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (!state.isRatingsReviewModelAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }
}
