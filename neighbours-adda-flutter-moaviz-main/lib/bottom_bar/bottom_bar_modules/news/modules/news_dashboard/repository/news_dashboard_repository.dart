import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/news_dashboard_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/time_frame_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class NewsDashboardRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Fetch the news dashboard statistics
  Future<NewsDashboardChannelStatisticsModel> getNewsDashboardStatistics({
    required String channelId,
    required TimeFrameEnum? timeFrame,
    required DateTimeRange? dateTimeRange,
  }) async {
    try {
      final accesstoken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _getNewsDashboardStatisticsIsolate(
          accessToken: accesstoken,
          channelId: channelId,
          timeFrame: timeFrame,
          dateTimeRange: dateTimeRange,
        );
      }, ());
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

  Future<NewsDashboardChannelStatisticsModel>
      _getNewsDashboardStatisticsIsolate({
    required String accessToken,
    required String channelId,
    required TimeFrameEnum? timeFrame,
    required DateTimeRange? dateTimeRange,
  }) async {
    try {
      final dateRange = dateTimeRange != null
          ? jsonEncode({
              'from_date': dateTimeRange.start.millisecondsSinceEpoch,
              'to_date': dateTimeRange.end.millisecondsSinceEpoch,
            })
          : null;

      final formData = FormData.fromMap({
        'access_token': accessToken,
        'channel_id': channelId,
        'timeframe': timeFrame?.value,
        'date_range': dateRange,
      });

      final dio = dioClient();
      return await dio
          .post('channels/channel_statistics', data: formData)
          .then((response) {
        if (response.data['status'] == "valid") {
          return NewsDashboardChannelStatisticsModel.fromJson(
              response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  //Fetch the news dashboard news list
  Future<NewsDashboardNewsListModel> getNewsDashboardNewsList() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _getNewsDashboardNewsListIsolate,
        await authPref.getAccessToken(),
      );
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

  Future<NewsDashboardNewsListModel> _getNewsDashboardNewsListIsolate(
      String accessToken) async {
    try {
      final formData = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio
          .post('channels/channel/dashboard_news', data: formData)
          .then((response) {
        if (response.data['status'] == "valid") {
          return NewsDashboardNewsListModel.fromJson(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
