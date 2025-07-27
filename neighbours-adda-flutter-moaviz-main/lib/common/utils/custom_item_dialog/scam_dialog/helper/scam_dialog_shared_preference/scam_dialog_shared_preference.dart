import 'package:snap_local/utility/tools/shared_preference_manager.dart';

class ScamDialogTokenSharedPref extends SharedPreferenceManager {
//Set job scam dialog view status
  Future<bool> makeJobScamDialogViewed() async {
    return await storeData(
        key: SharedPreferenceKeys.jobScamDialog, data: 'true');
  }

//Get job scam dialog view status
  Future<bool> getJobScamDialogViewStatus() async {
    return await getData(key: SharedPreferenceKeys.jobScamDialog)
        .then((value) => value == "true");
  }

//Set buy sell scam dialog view status
  Future<bool> makeBuySellScamDialogViewed() async {
    return await storeData(
        key: SharedPreferenceKeys.buySellScamDialog, data: 'true');
  }

//Get buy sell scam dialog view status
  Future<bool> getBuySellScamDialogViewStatus() async {
    return await getData(key: SharedPreferenceKeys.buySellScamDialog)
        .then((value) => value == "true");
  }

  //Business
  //Set business scam dialog view status
  Future<bool> makeBusinessScamDialogViewed() async {
    return await storeData(
        key: SharedPreferenceKeys.businessScamDialog, data: 'true');
  }

  //Get business scam dialog view status
  Future<bool> getBusinessScamDialogViewStatus() async {
    return await getData(key: SharedPreferenceKeys.businessScamDialog)
        .then((value) => value == "true");
  }

  //Clear all scam dialog view status
  Future<bool> clearAllScamDialogViewStatus() async {
    return await deleteData(key: SharedPreferenceKeys.jobScamDialog) &&
        await deleteData(key: SharedPreferenceKeys.buySellScamDialog) &&
        await deleteData(key: SharedPreferenceKeys.businessScamDialog);
  }
}
