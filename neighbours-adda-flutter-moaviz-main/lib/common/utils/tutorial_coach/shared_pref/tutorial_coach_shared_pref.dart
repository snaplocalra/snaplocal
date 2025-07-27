import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:snap_local/utility/tools/shared_preference_manager.dart';

class TutorialCoachSharedPref extends SharedPreferenceManager {
  Future<bool> deleteCoachStatus() async {
    try {
      await deleteData(key: SharedPreferenceKeys.groupScreenCoach);
      await deleteData(key: SharedPreferenceKeys.pageScreenCoach);
      await deleteData(key: SharedPreferenceKeys.addLocationCoach);
      return true;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  //Group screen
  Future<bool> isGroupScreenCoachCompleted() async {
    return await getData(key: SharedPreferenceKeys.groupScreenCoach)
        .then((value) => value == "true");
  }

  Future<bool> setGroupScreenCoachComplete() async {
    return await storeData(
        key: SharedPreferenceKeys.groupScreenCoach, data: 'true');
  }

  //Page screen
  Future<bool> isPageScreenCoachCompleted() async {
    return await getData(key: SharedPreferenceKeys.pageScreenCoach)
        .then((value) => value == "true");
  }

  Future<bool> setPageScreenCoachComplete() async {
    return await storeData(
        key: SharedPreferenceKeys.pageScreenCoach, data: 'true');
  }

  //Marketplace location
  Future<bool> isAddLocationCoachCompleted() async {
    return await getData(key: SharedPreferenceKeys.addLocationCoach)
        .then((value) => value == "true");
  }

  Future<bool> setAddLocationCoachComplete() async {
    return await storeData(
        key: SharedPreferenceKeys.addLocationCoach, data: 'true');
  }
}
