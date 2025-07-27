import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';

class FirebaseUserRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final authSharedPref = AuthenticationTokenSharedPref();

  Future<void> createUser(
      FirebaseUserProfileDetailsModel profileDetails) async {
    try {
      return await _firebaseFirestore
          .collection(FirebasePath.userList)
          .doc(profileDetails.id)
          .set(profileDetails.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUser(
      FirebaseUserProfileDetailsModel profileDetails) async {
    try {
      return await _firebaseFirestore
          .collection(FirebasePath.userList)
          .doc(profileDetails.id)
          .update(profileDetails.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> manageUser(
      FirebaseUserProfileDetailsModel firebaseUserProfileDetails) async {
    try {
      final existingUserData =
          await fetchUserData(userId: firebaseUserProfileDetails.id);
      if (existingUserData != null) {
        await updateUser(firebaseUserProfileDetails);
      } else {
        await createUser(firebaseUserProfileDetails);
      }
    } catch (error) {
      ThemeToast.errorToast(error.toString());
    }
  }

  Stream<FirebaseUserProfileDetailsModel?> streamUserDetails(
      {required String userId}) {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.userList)
          .doc(userId)
          .snapshots(includeMetadataChanges: true)
          .map((snaps) {
        final userDetails = snaps.data();
        if (userDetails != null) {
          return FirebaseUserProfileDetailsModel.fromJson(userDetails);
        } else {
          return null;
        }
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<FirebaseUserProfileDetailsModel?> fetchUserData(
      {required String userId}) async {
    try {
      return await _firebaseFirestore
          .collection(FirebasePath.userList)
          .doc(userId)
          .get()
          .then(
            (response) => response.data() != null
                ? FirebaseUserProfileDetailsModel.fromJson(response.data()!)
                : null,
          );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      ThemeToast.errorToast(e.toString());
      return null;
    }
  }
}
