import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/follow/model/follow_handler.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

class FollowHandlerRepositoryImpl extends BaseApi
    implements FollowHandlerRepository {
  @override
  Future<void> execute(FollowHandler followHandler) async {
    try {
      final data = FormData.fromMap({
        "access_token": await AuthenticationTokenSharedPref().getAccessToken(),
        ...followHandler.data,
      });

      final dio = dioClient();
      return await dio
          .post(followHandler.apiEndpoint, data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return;
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}

abstract class FollowHandlerRepository {
  Future<void> execute(FollowHandler blockHandler);
}
