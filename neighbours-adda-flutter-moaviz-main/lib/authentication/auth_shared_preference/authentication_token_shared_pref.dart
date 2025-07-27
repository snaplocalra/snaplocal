import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:snap_local/utility/tools/shared_preference_manager.dart';

class AuthenticationTokenSharedPref extends SharedPreferenceManager {
  Future<bool> storeCreds({
    required SharedPreferenceKeys key,
    required String token,
  }) async {
    return await storeData(
      key: key,
      data: token,
    );
  }
  // Testing part

  Future<bool> deleteCreds() async {
    try {
      await deleteData(key: SharedPreferenceKeys.accessToken);
      await deleteData(key: SharedPreferenceKeys.userId);
      return true;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> isOnboardingCompleted() async {
    return await getData(key: SharedPreferenceKeys.onBoarding)
        .then((value) => value == "true");
  }

  Future<bool> setOnboardingComplete() async {
    return await storeData(key: SharedPreferenceKeys.onBoarding, data: 'true');
  }

  Future<String> getAccessToken() async {
    return await getData(key: SharedPreferenceKeys.accessToken) ?? "";
  }

  Future<String> getUserId() async {
    return await getData(key: SharedPreferenceKeys.userId) ?? "";
  }

  Future<bool> hasToken() async {
    final userToken = await getAccessToken();
    final userId = await getUserId();
    final hasToken = userToken.isNotEmpty && userId.isNotEmpty;
    return hasToken;
  }
}
