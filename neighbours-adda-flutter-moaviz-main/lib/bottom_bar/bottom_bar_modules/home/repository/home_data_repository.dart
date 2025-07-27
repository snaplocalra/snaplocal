import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/home_banners_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_connection_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_event_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_groups_response_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_jobs_response.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_news_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_news_response.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_offers_response.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_pages_response_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_buy_sell_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/connection_ignore_response.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/connection_connect_response.dart';

import '../../../../utility/constant/errors.dart';

class HomeDataRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ConnectionConnectResponse> connectConnection(String userId, {bool isCancel = false}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _connectConnectionIsolate,
        {
          'accessToken': await authPref.getAccessToken(),
          'targeting_user_id': userId,
          'isCancel': isCancel,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ConnectionConnectResponse> _connectConnectionIsolate(Map<String, dynamic> params) async {
    try {
      final accessToken = params['accessToken']! as String;
      final userId = params['targeting_user_id']! as String;
      final isCancel = params['isCancel']! as bool;

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'targeting_user_id': userId,
        'is_cancel': isCancel,
      });

      final dio = dioClient();
      const endpoint = 'users/user_connections/add';
      return await dio.post(endpoint, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ConnectionConnectResponse.fromMap(response.data);
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

  Future<SocialPostsList> fetchHomeSocialPosts({int page = 1}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          final page = params['page']! as int;
          return _fetchHomeFeedIsolate(
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

  Future<SocialPostsList> _fetchHomeFeedIsolate({
    required String accessToken,
    required int page,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();
      return await dio.post('v2/users/posts', data: data).then((response) {
        if (response.data['status'] == "valid") {
          print("||||||||||||||||||||||||||HomeFeed||||||||||||||||||||||");
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

  Future<HomeBannersList> fetchHomeBanners() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchHomeBannersIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<HomeBannersList> _fetchHomeBannersIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/home_sliders', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return HomeBannersList.fromMap(response.data['data']);
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

  Future<LocalPagesResponseModel> fetchHomeLocalPages() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchHomeLocalPagesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalPagesResponseModel> _fetchHomeLocalPagesIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/pages_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalPagesResponseModel.fromJson(response.data);
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

  Future<LocalBuyAndSellModel> fetchLocalBuyAndSellItems() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchLocalBuyAndSellItemsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalBuyAndSellModel> _fetchLocalBuyAndSellItemsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/buy_sell_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalBuyAndSellModel.fromMap(response.data);
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

  Future<LocalJobsResponse> fetchLocalJobs() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchLocalJobsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalJobsResponse> _fetchLocalJobsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/jobs_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalJobsResponse.fromMap(response.data);
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

  Future<LocalOffersResponse> fetchLocalOffers() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchLocalOffersIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalOffersResponse> _fetchLocalOffersIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/offers_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalOffersResponse.fromMap(response.data);
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

  Future<LocalEventsResponse> fetchLocalEvents() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchLocalEventsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalEventsResponse> _fetchLocalEventsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/events_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalEventsResponse.fromMap(response.data);
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

  Future<LocalNewsResponse> fetchLocalNews() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchLocalNewsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalNewsResponse> _fetchLocalNewsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/news_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalNewsResponse.fromMap(response.data);
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

  Future<List<LocalConnectionModel>> fetchLocalConnections() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchLocalConnectionsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocalConnectionModel>> _fetchLocalConnectionsIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post('common/connection_list_for_feed_post', data: data).then((response) {
        if (response.data['status'] == "valid") {
          final connectionResponse = LocalConnectionResponse.fromMap(response.data);
          return connectionResponse.data;
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

  Future<ConnectionIgnoreResponse> ignoreConnection(String userId) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _ignoreConnectionIsolate,
        {
          'accessToken': await authPref.getAccessToken(),
          'userId': userId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ConnectionIgnoreResponse> _ignoreConnectionIsolate(Map<String, dynamic> params) async {
    try {
      final accessToken = params['accessToken']! as String;
      final userId = params['userId']! as String;

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
      });

      final dio = dioClient();
      return await dio.post('common/add_ignore_list', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ConnectionIgnoreResponse.fromMap(response.data);
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

  Future<ConnectionConnectResponse> acceptConnection(String userId) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _acceptConnectionIsolate,
        {
          'accessToken': await authPref.getAccessToken(),
          'connection_id': userId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ConnectionConnectResponse> _acceptConnectionIsolate(Map<String, dynamic> params) async {
    try {
      final accessToken = params['accessToken']! as String;
      final userId = params['connection_id']! as String;

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'connection_id': userId,
      });

      final dio = dioClient();
      const endpoint = 'users/user_connections/accept';
      return await dio.post(endpoint, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ConnectionConnectResponse.fromMap(response.data);
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

  Future<ConnectionConnectResponse> rejectConnection(String userId) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _rejectConnectionIsolate,
        {
          'accessToken': await authPref.getAccessToken(),
          'connection_id': userId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ConnectionConnectResponse> _rejectConnectionIsolate(Map<String, dynamic> params) async {
    try {
      final accessToken = params['accessToken']! as String;
      final userId = params['connection_id']! as String;

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'connection_id': userId,
      });

      final dio = dioClient();
      const endpoint = 'users/user_connections/reject';
      return await dio.post(endpoint, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ConnectionConnectResponse.fromMap(response.data);
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
