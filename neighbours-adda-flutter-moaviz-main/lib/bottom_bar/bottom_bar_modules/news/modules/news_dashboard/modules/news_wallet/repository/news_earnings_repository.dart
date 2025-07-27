import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/models/news_earnings_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/models/news_wallet_transactions_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class NewsEarningsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Fetch news earnings details
  Future<NewsEarningsDetailsModel> fetchNewsEarningsDetails(
      String channelId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) {
          return _fetchNewsEarningsDetailsIsolate(
            accessToken: accessToken,
            channelId: channelId,
          );
        },
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<NewsEarningsDetailsModel> _fetchNewsEarningsDetailsIsolate({
    required String accessToken,
    required String channelId,
  }) async {
    try {
      final dio = dioClient();
      final data = FormData.fromMap({
        'access_token': accessToken,
        'channel_id': channelId,
      });
      return await dio.post('channels/earnings', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return NewsEarningsDetailsModel.fromMap(response.data['data']);
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

  Future<NewsWalletTransactionsList> fetchNewsWalletTransactions(
      {int page = 1}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          final page = params['page']! as int;
          return _fetchNewsWalletTransactionsIsolate(
            accessToken: accessToken,
            page: page,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
          'page': page,
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<NewsWalletTransactionsList> _fetchNewsWalletTransactionsIsolate({
    required String accessToken,
    required int page,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post("channels/earnings/history", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return NewsWalletTransactionsList.fromMap(response.data);
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
