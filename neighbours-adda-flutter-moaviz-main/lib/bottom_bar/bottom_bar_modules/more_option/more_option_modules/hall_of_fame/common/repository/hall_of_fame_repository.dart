import 'dart:convert';

import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_banner_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_model_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/models/winners_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../utility/constant/errors.dart';

class HallOfFameRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<QuizDataModel> fetchQuizData() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchQuizDataIsolate(
            accessToken: accessToken,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<QuizDataModel> _fetchQuizDataIsolate(
      {required String accessToken}) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post("quiz/fetch_quiz_data", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return QuizDataModel.fromJson(response.data['data']);
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

  Future<void> startQuiz({
    // required List<String> languageId,
    required List<String> topicIdList,
  }) async {
    try {
      final startQuizDataMap = {
        // 'language_id': jsonEncode(languageId),
        'topic_id': jsonEncode(topicIdList),
        'access_token': await authPref.getAccessToken(),
      };
      await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final startQuizDataMap =
              params['startQuizDataMap']! as Map<String, String>;
          return _startQuizIsolate(startQuizDataMap);
        },
        {'startQuizDataMap': startQuizDataMap},
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _startQuizIsolate(
      Map<String, String> startQuizDataMap) async {
    try {
      FormData data = FormData.fromMap(startQuizDataMap);
      final dio = dioClient();

      return await dio.post("quiz/create", data: data).then((response) {
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

  Future<void> submitQuiz(QuizDataModel quizData) async {
    try {
      final quizDataMap = {
        'quiz_id': quizData.quizData!.id,
        'answer': quizData.toRequiredJson(),
        'access_token': await authPref.getAccessToken(),
      };
      await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final quizDataMap = params['quizDataMap']! as Map<String, String>;
          return _submitQuizIsolate(quizDataMap);
        },
        {'quizDataMap': quizDataMap},
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _submitQuizIsolate(Map<String, String> quizDataMap) async {
    try {
      FormData data = FormData.fromMap(quizDataMap);
      final dio = dioClient();
      return await dio.post("quiz/submit", data: data).then((response) {
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

  Future<CategoryListModel> fetchQuizInterestsTopics() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchQuizInterestsTopicsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchQuizInterestsTopicsIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('quiz/interests', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return CategoryListModel.fromMap(response.data);
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

  Future<String> fetchQuizBanner(QuizBannerType quizBannerType) async {
    try {
      final quizBannerDataMap = {
        'access_token': await authPref.getAccessToken(),
        'type': quizBannerType.name,
      };
      return await makeIsolateApiCallWithInternetCheck(
        _fetchQuizBannerIsolate,
        quizBannerDataMap,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _fetchQuizBannerIsolate(
      Map<String, String> quizBannerDataMap) async {
    try {
      FormData data = FormData.fromMap(quizBannerDataMap);

      final dio = dioClient();
      return await dio.post('quiz/banners', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return response.data['data']['image'];
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

  Future<WinnersListModel> fetchWinners({int page = 1}) async {
    try {
      final fetchWinnerDataMap = {
        'access_token': await authPref.getAccessToken(),
        'page': page,
      };

      return await makeIsolateApiCallWithInternetCheck(
          _fetchWinnersIsolate, fetchWinnerDataMap);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<WinnersListModel> _fetchWinnersIsolate(
      Map<String, dynamic> fetchWinnerDataMap) async {
    try {
      FormData data = FormData.fromMap(fetchWinnerDataMap);

      final dio = dioClient();
      return await dio.post('quiz/winners', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return WinnersListModel.fromJson(response.data);
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
