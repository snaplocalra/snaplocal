import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/model/news_channel_overview_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

class NewsChannelOverviewRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<NewsChannelOverViewModel> getChannelOverviewData(
      String channelId) async {
    try {
      //Get the access token
      final accessToken = await authPref.getAccessToken();

      final data = FormData.fromMap({
        "channel_id": channelId,
        "access_token": accessToken,
      });

      //Api call
      return await dioClient()
          .post("channels/channel/overview", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return NewsChannelOverViewModel.fromJson(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Error handling
      rethrow;
    }
  }
}
