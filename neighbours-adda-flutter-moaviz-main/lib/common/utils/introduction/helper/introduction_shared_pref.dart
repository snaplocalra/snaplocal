import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:snap_local/utility/tools/shared_preference_manager.dart';

class IntroductionSharedPref extends SharedPreferenceManager {
  Future<bool> deleteIntroductionStatus() async {
    try {
      await deleteData(key: SharedPreferenceKeys.chooseLanguage);
      await deleteData(key: SharedPreferenceKeys.introduction);
      return true;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> setInitialChooseLanguageComplete() async {
    return await storeData(
        key: SharedPreferenceKeys.chooseLanguage, data: 'true');
  }

  Future<bool> isInitialChooseLanguageCompleted() async {
    return await getData(key: SharedPreferenceKeys.chooseLanguage)
        .then((value) => value == "true");
  }

  Future<bool> isIntroductionCompleted() async {
    return await getData(key: SharedPreferenceKeys.introduction)
        .then((value) => value == "true");
  }

  Future<bool> setIntroductionComplete() async {
    return await storeData(
        key: SharedPreferenceKeys.introduction, data: 'true');
  }

  Future<bool> resetIntroduction() async {
    bool response = false;
    response = await deleteData(key: SharedPreferenceKeys.introduction);
    response = await deleteData(key: SharedPreferenceKeys.chooseLanguage);
    return response;
  }
}
