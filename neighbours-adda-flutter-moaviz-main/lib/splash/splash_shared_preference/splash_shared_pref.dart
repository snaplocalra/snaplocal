import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:snap_local/utility/tools/shared_preference_manager.dart';

class SplashSharedPref extends SharedPreferenceManager {
  Future<bool> deleteSplashData() async {
    try {
      await deleteData(key: SharedPreferenceKeys.splash);
      return true;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> isRegularOpen() async {
    return await getData(key: SharedPreferenceKeys.splash)
        .then((value) => value == "true");
  }

  Future<bool> setFreshOpenCompleted() async {
    return await storeData(key: SharedPreferenceKeys.splash, data: 'true');
  }
}
