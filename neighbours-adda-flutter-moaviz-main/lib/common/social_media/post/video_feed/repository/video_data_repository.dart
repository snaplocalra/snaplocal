import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_groups_response_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';

class VideoDataRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SocialPostsList> fetchVideoPosts({int page = 1}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          final page = params['page']! as int;
          return _fetchVideoFeedIsolate(
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
      rethrow;
    }
  }

  Future<SocialPostsList> _fetchVideoFeedIsolate({
    required String accessToken,
    required int page,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();
      return await dio.post('common/video_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          print("||||||||||||||||||||||||||VideoFeed||||||||||||||||||||||");
          print(response.data);
          return SocialPostsList.fromMap(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

  Future<LocalGroupsResponseModel> fetchHomeLocalGroups() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchHomeLocalGroupsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalGroupsResponseModel> _fetchHomeLocalGroupsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/groups_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalGroupsResponseModel.fromMap(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }
}
