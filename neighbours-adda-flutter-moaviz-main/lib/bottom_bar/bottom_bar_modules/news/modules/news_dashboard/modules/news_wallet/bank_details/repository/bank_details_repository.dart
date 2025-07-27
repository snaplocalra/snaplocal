import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/logic/models/manage_bank_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/model/bank_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../../utility/constant/errors.dart';

class ManageBankRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Add Bank Details
  Future<void> addBankDetails(ManageBankDetailsModel bankDetails) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _addBankDetailsIsolate(
          accessToken: accessToken,
          bankDetails: bankDetails,
        );
      }, {}).then((value) {
        if (value != null) {
          ThemeToast.successToast(value);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _addBankDetailsIsolate({
    required String accessToken,
    required ManageBankDetailsModel bankDetails,
  }) async {
    try {
      final dio = dioClient();
      final data = FormData.fromMap(
        bankDetails.toMap()..addAll({'access_token': accessToken}),
      );
      return await dio
          .post('channels/beneficiary/add', data: data)
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

  //Fetch Bank list
  Future<List<BankDetailsModel>> fetchBankList() async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchBankListIsolate(accessToken: accessToken);
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<BankDetailsModel>> _fetchBankListIsolate(
      {required String accessToken}) async {
    try {
      final dio = dioClient();
      final data = FormData.fromMap({'access_token': accessToken});
      return await dio
          .post('channels/beneficiary', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List<BankDetailsModel>.from(
            response.data['data'].map(
              (x) => BankDetailsModel.fromJson(x),
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
