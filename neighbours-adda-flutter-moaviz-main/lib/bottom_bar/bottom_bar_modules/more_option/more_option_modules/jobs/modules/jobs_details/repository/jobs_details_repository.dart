import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class JobsDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<JobDetailModel> fetchJobsDetails({required String jobId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchJobsDetailsIsolate(
            accessToken: accessToken,
            jobId: jobId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<JobDetailModel> _fetchJobsDetailsIsolate({
    required String accessToken,
    required String jobId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'job_id': jobId,
      });
      final dio = dioClient();
      return await dio.post("v3/jobs/job/view", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return JobDetailModel.fromJson(response.data['data']);
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

  //Application submit
  Future<void> applyJob({required String jobId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _applyJobIsolate(
            accessToken: accessToken,
            jobId: jobId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _applyJobIsolate({
    required String accessToken,
    required String jobId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'job_id': jobId,
      });
      final dio = dioClient();
      return await dio.post("jobs/job/apply_job", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return;
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

  //Mark job as closed
  Future<void> closePosition({required String jobId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _closePositionIsolate(
            accessToken: accessToken,
            jobId: jobId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _closePositionIsolate({
    required String accessToken,
    required String jobId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'job_id': jobId,
      });
      final dio = dioClient();
      return await dio
          .post("jobs/job/mark_as_closed", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return;
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
