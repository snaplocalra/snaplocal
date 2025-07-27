import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/review_module/model/add_rating_model.dart';
import 'package:snap_local/common/review_module/model/ratings_review_model.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class RatingsReviewRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> deleteReview({
    required String postId,
    required String reviewId,
    required RatingType ratingType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck(
          (_) => _deleteReviewIsolate(
              accessToken: accessToken,
              postId: postId,
              reviewId: reviewId,
              ratingType: ratingType),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _deleteReviewIsolate({
    required String accessToken,
    required String postId,
    required String reviewId,
    required RatingType ratingType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        "access_token": accessToken,
        "post_id": postId,
        "post_type": ratingType.name,
        "id": reviewId,
      });
      final dio = dioClient();
      return await dio
          .post('v2/common/delete_review', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

  Future<void> saveReview({
    required AddRatingModel addRatingModel,
    required RatingType ratingType,
    bool isEdit = false,
  }) async {
    try {
      final addRatingModelMap = addRatingModel.toMap();
      addRatingModelMap.addAll({
        'access_token': await authPref.getAccessToken(),
        "post_type": ratingType.name,
      });

      return await makeIsolateApiCallWithInternetCheck(
          (_) => _saveReviewIsolate(
                addRatingModelMap: addRatingModelMap,
                isEdit: isEdit,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _saveReviewIsolate({
    required Map<String, dynamic> addRatingModelMap,
    bool isEdit = false,
  }) async {
    try {
      FormData data = FormData.fromMap(addRatingModelMap);
      final dio = dioClient();
      final endpoint = isEdit ? "update_review" : "submit_review";
      return await dio.post('v2/common/$endpoint', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

  Future<RatingsReviewModel> fetchRatingsReviewDetails({
    required String id,
    required RatingType ratingType,
    int page = 1,
  }) async {
    try {
      final dataMap = {
        'access_token': await authPref.getAccessToken(),
        'post_id': id,
        "post_type": ratingType.name,
        'page': page,
      };
      return await makeIsolateApiCallWithInternetCheck(
          _fetchRatingsReviewDetailsIsolate, dataMap);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<RatingsReviewModel> _fetchRatingsReviewDetailsIsolate(
    Map<String, dynamic> dataMap,
  ) async {
    try {
      FormData data = FormData.fromMap(dataMap);
      final dio = dioClient();
      return await dio
          .post('v2/common/get_reviews', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return RatingsReviewModel.fromJson(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }
}
