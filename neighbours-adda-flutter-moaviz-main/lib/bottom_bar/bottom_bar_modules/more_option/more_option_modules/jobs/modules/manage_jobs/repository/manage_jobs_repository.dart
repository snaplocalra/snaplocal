import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/models/jobs_manage_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class ManageJobRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> manageJob({
    required JobManageModel jobManageModel,
    required bool isEdit,
  }) async {
    try {
      final jobManageMap = ({
        ...jobManageModel.toMap(),
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck((_) {
        return _manageJobIsolate(
          jobManageMap: jobManageMap,
          isEdit: isEdit,
        );
      }, {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _manageJobIsolate({
    required Map<String, dynamic> jobManageMap,
    required bool isEdit,
  }) async {
    try {
      FormData data = FormData.fromMap(jobManageMap);
      final dio = dioClient();
      return await dio
          .post("v3/jobs/job/${isEdit ? 'update' : 'add'}", data: data)
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

  Future<CategoryListModel> fetchJobIndustries() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchJobIndustriesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchJobIndustriesIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('jobs/job_industries', data: data).then((response) {
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

  Future<List<String>> fetchJobSkills() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchJobSkillsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<String>> _fetchJobSkillsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('jobs/job_skills', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return CategoryListModel.fromMap(response.data)
              .data
              .map((e) => e.name)
              .toList();
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
