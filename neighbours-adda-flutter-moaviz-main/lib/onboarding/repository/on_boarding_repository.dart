import 'package:dio/dio.dart';
import 'package:snap_local/onboarding/model/on_boarding_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

class OnBoardingRepository extends BaseApi {
  Future<List<OnboardingModel>> fetchOnBoardingData() async {
    try {
      final dio = dioClient();
      final response = await dio.post('common/welcome_slides');

      final data = response.data;
      if (data['status'] == "valid") {
        return onboardingModelFromMap(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw Exception('Server error');
        } else {
          throw Exception('Unable to fetch data');
        }
      } else {
        rethrow;
      }
    }
  }
}
