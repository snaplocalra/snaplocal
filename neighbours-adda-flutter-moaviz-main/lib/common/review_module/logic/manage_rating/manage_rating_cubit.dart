import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/review_module/model/add_rating_model.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/repository/ratings_review_repository.dart';

part 'manage_rating_state.dart';

class ManageRatingCubit extends Cubit<ManageRatingState> {
  final RatingsReviewRepository ratingsReviewRepository;

  ManageRatingCubit({required this.ratingsReviewRepository})
      : super(const ManageRatingState());

  Future<void> saveReview({
    required AddRatingModel addRatingModel,
    required RatingType ratingType,
    required Future Function() refreshAfterReview,
    bool isEdit = false,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await ratingsReviewRepository.saveReview(
        addRatingModel: addRatingModel,
        ratingType: ratingType,
        isEdit: isEdit,
      );
      await refreshAfterReview();
      emit(state.copyWith(requestSuccess: true));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  Future<void> deleteReview({
    required String reviewId,
    required String postId,
    required RatingType ratingType,
    required Future Function() refreshAfterReview,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await ratingsReviewRepository.deleteReview(
        postId: postId,
        reviewId: reviewId,
        ratingType: ratingType,
      );
      await refreshAfterReview();
      emit(state.copyWith(deleteRequestSuccess: true));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }
}
