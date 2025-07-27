import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/model/block_handler.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

class BlockHandlerRepositoryImpl extends BaseApi
    implements BlockHandlerRepository {
  @override
  Future<void> execute(BlockHandler blockHandler) async {
    try {
      final data = FormData.fromMap({
        "access_token": await AuthenticationTokenSharedPref().getAccessToken(),
        ...blockHandler.data,
      });

      final dio = dioClient();
      return await dio
          .post(blockHandler.apiEndpoint, data: data)
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

abstract class BlockHandlerRepository {
  Future<void> execute(BlockHandler blockHandler);
}
