import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class JobsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<JobsListModel> fetchNeighboursPostedJobs({
    int page = 1,
    required JobsListType jobsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchNeighboursPostedJobsIsolate(
          accessToken: accessToken,
          page: page,
          jobsListType: jobsListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<JobsListModel> _fetchNeighboursPostedJobsIsolate({
    required String accessToken,
    required int page,
    required JobsListType jobsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'search_keyword': searchKeyword,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post(jobsListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return JobsListModel.fromJson(response.data);
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

  Future<JobsListModel> fetchOwnPostedJobs({
    int page = 1,
    required JobsListType jobsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchOwnPostedJobsIsolate(
          accessToken: accessToken,
          page: page,
          jobsListType: jobsListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<JobsListModel> _fetchOwnPostedJobsIsolate({
    required String accessToken,
    required int page,
    required JobsListType jobsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'access_token': accessToken,
        'search_keyword': searchKeyword,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post(jobsListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return JobsListModel.fromJson(response.data);
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

  Future<JobsListModel> searchJobs({
    int page = 1,
    required String query,
    required String jobsIndustryCategoryId,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _searchJobsIsolate(
            page: page,
            query: query,
            accessToken: accessToken,
            jobsIndustryCategoryId: jobsIndustryCategoryId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<JobsListModel> _searchJobsIsolate({
    required String query,
    required int page,
    required String accessToken,
    required String jobsIndustryCategoryId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
        'industry_id': jobsIndustryCategoryId,
      });

      final dio = dioClient();
      return await dio.post("jobs/job/search", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return JobsListModel.fromJson(response.data);
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
