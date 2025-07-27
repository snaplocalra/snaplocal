import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/model/manage_news_channel_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

import '../../../../../../utility/constant/errors.dart';

class ManageNewsChannelRepositoryImpl extends BaseApi
    implements ManageNewsChannelRepository {
  final authPref = AuthenticationTokenSharedPref();

  @override
  Future<void> createNewsChannel(
    ManageNewsChannelModel newsChannelDetails,
  ) async {
    try {
      //Get the access token
      final accessToken = await authPref.getAccessToken();

      //Convert the news channel details to map
      final createNewsChannelDetailsMap = newsChannelDetails.toMap();

      //Add the access token to the map
      createNewsChannelDetailsMap.addAll({'access_token': accessToken});

      //Create the form data
      FormData data = FormData.fromMap(createNewsChannelDetailsMap);

      //Create the dio instance
      return await dioClient()
          .post("channels/channel/add", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
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

  @override
  Future<void> updateNewsChannel(
    ManageNewsChannelModel updatedNewsChannelDetails,
  ) async {
    try {
      //Get the access token
      final accessToken = await authPref.getAccessToken();

      final updatedNewsChannelDetailsMap = updatedNewsChannelDetails.toMap();

      //Add the access token to the map
      updatedNewsChannelDetailsMap.addAll({'access_token': accessToken});

      //Create the form data
      FormData data = FormData.fromMap(updatedNewsChannelDetailsMap);

      //Create the dio instance
      return dioClient()
          .post("channels/channel/update", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
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

  @override
  Future<ManageNewsChannelModel?> getNewsChannel() async {
    try {
      //Get the access token
      final accessToken = await authPref.getAccessToken();

      //Create the form data
      FormData data = FormData.fromMap({'access_token': accessToken});

      //Create the dio instance
      return dioClient()
          .post("channels/channel/get_own_channel_details", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['data'] == null
              ? null
              : ManageNewsChannelModel.fromMap(response.data['data']);
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

abstract class ManageNewsChannelRepository {
  //create news channel
  Future<void> createNewsChannel(ManageNewsChannelModel newsChannelDetails);

  //update news channel
  Future<void> updateNewsChannel(
      ManageNewsChannelModel updatedNewsChannelDetails);

  //delete news channel
  // Future<void> deleteNewsChannel(String newsChannelId);

  //get news channel
  Future<ManageNewsChannelModel?> getNewsChannel();
}
