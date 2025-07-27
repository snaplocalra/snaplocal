import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/authentication/repository/auth_repository.dart';
import 'package:snap_local/authentication/repository/firebase_login.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/profile/manage_profile_details/repository/profile_repository.dart';
import 'package:snap_local/utility/tools/shared_preference_manager.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  final FirebaseLoginRepository firebaseLoginRepository;
  AuthenticationBloc({
    required this.authRepository,
    required this.firebaseLoginRepository,
  }) : super(AuthenticationUninitialized()) {
    final authenticationTokenSharedPref = AuthenticationTokenSharedPref();
    on<AuthenticationEvent>(
      (event, emit) async {
        if (event is AppStarted) {
          emit(AuthenticationLoading());
          if (await authenticationTokenSharedPref.hasToken()) {
            emit(const AuthenticationAuthenticated());
          } else {
            //clear the local data base
            await HydratedBloc.storage.clear();

            //logout if any firebase session is going on
            await firebaseLoginRepository.logout();
            if (await authenticationTokenSharedPref.isOnboardingCompleted()) {
              emit(const AuthenticationUnauthenticated());
            } else {
              emit(OnBoarding());
            }
          }

          return;
        } else if (event is OpenAuth) {
          emit(AuthenticationLoading());
          // await AuthenticationTokenSharedPref().setOnboardingComplete();
          emit(const AuthenticationUnauthenticated());
          return;
        } else if (event is LoggedIn) {
          try {
            emit(AuthenticationLoading());

            //StoreToken
            await _storeToken(
              accessToken: event.accessToken,
              userId: event.userId,
            );

            //Fetch profile details
            final profileDetails =
                await ProfileRepository().fetchProfileDetails();

            //Create firebase user instance
            final firebaseProfile = FirebaseUserProfileDetailsModel(
              id: profileDetails.id,
              name: profileDetails.name,
              email: profileDetails.email,
              mobile: profileDetails.mobile,
              gender: profileDetails.gender,
              profileImage: profileDetails.profileImage,
            );

            //update profile on firebase
            await FirebaseUserRepository().manageUser(firebaseProfile);

            emit(const AuthenticationAuthenticated());
            return;
          } catch (e) {
            emit(const AuthenticationUnauthenticated());
            await logout();
          }
        } else if (event is LoggedOut) {
          try {
            emit(AuthenticationLoading());
            await logout();
            if (isClosed) {
              return;
            }
            emit(const AuthenticationUnauthenticated());
          } catch (e) {
            // Record the error in Firebase Crashlytics
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
            //if the logout api failed, then emit the Authenticated state
            emit(const AuthenticationAuthenticated());
            await ThemeToast.errorToast(e.toString());
            return;
          }
        }
      },
    );
  }

  ///Store user uid on the device local cache
  Future<void> _storeToken({
    required String accessToken,
    required String userId,
  }) async {
    await AuthenticationTokenSharedPref().storeCreds(
      key: SharedPreferenceKeys.accessToken,
      token: accessToken,
    );
    await AuthenticationTokenSharedPref().storeCreds(
      key: SharedPreferenceKeys.userId,
      token: userId,
    );
  }

  ///Logout the user
  Future<void> logout() async {
    //logout from server
    await authRepository.logout();
    //logout if any firebase session is going on
    await firebaseLoginRepository.logout();
    //clear the local data base
    await HydratedBloc.storage.clear();
    //Clear the locale cache to remove all the saved objects like cached network image etc
    await DefaultCacheManager().emptyCache();
  }
}
