import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferenceKeys {
  splash("splash"),
  introduction("introduction"),
  chooseLanguage("choose_language"),
  userId("user_id"),
  accessToken("access_token"),
  onBoarding("onboarding"),
  groupScreenCoach("group_screen_coach"),
  pageScreenCoach("page_screen_coach"),
  addLocationCoach("add_location_coach"),
  jobScamDialog("job_scam_dialog"),
  buySellScamDialog("buy_sell_scam_dialog"),
  businessScamDialog("business_scam_dialog"),
  theme("theme");

  final String value;
  const SharedPreferenceKeys(this.value);
}

abstract class SharedPreferenceManager {
  Future<bool> storeData(
      {required SharedPreferenceKeys key, required String data}) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      return await sharedPref.setString(key.value, data);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<String?> getData({required SharedPreferenceKeys key}) async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(key.value);
  }

  Future<bool> deleteData({required SharedPreferenceKeys key}) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      return await sharedPref.remove(key.value);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      return await sharedPref.clear();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }
}
