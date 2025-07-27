import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_timeframe_type.dart';
import 'package:snap_local/common/utils/analytics/model/date_time_range_extension.dart';
import 'package:snap_local/common/utils/analytics/module/graph_analytics/model/graph_analytics_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class GraphAnalyticsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  // Fetch analytics overview
  Future<List<GraphAnalyticsModel>> fetchGraphAnalytics({
    required String moduleId,
    required String analyticsOverviewId,
    required AnalyticsModuleType moduleType,
    required AnalyticsTimeframeType? timeFrame,
    required DateTimeRange? dateRange,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchGraphAnalyticsIsolate(
          accessToken: accessToken,
          analyticsOverviewId: analyticsOverviewId,
          moduleId: moduleId,
          moduleType: moduleType,
          timeFrame: timeFrame,
          dateRange: dateRange,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<GraphAnalyticsModel>> _fetchGraphAnalyticsIsolate({
    required String accessToken,
    required String moduleId,
    required String analyticsOverviewId,
    required AnalyticsModuleType moduleType,
    required AnalyticsTimeframeType? timeFrame,
    required DateTimeRange? dateRange,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'module_id': moduleId,
        'module_type': moduleType.name,
        'analytics_time_frame': timeFrame?.jsonValue,
        'analytics_overview_id': analyticsOverviewId,
        'date_range': dateRange?.toJson(),
      });

      final dio = dioClient();
      return await dio
          .post("common/get_graph_details", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List<GraphAnalyticsModel>.from(
            response.data['data'].map(
              (model) => GraphAnalyticsModel.fromMap(model),
            ),
          );
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
