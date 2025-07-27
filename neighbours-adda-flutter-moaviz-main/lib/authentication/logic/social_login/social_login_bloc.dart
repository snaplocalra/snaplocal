import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/authentication/models/authenticated_user_details.dart';
import 'package:snap_local/authentication/models/social_login_type.dart';
import 'package:snap_local/authentication/repository/auth_repository.dart';
import 'package:snap_local/authentication/repository/firebase_login.dart';

part 'social_login_event.dart';
part 'social_login_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  final FirebaseLoginRepository firebaseLoginRepository;
  final AuthRepository authRepository;
  final AuthenticationBloc authenticationBloc;
  SocialLoginBloc({
    required this.firebaseLoginRepository,
    required this.authRepository,
    required this.authenticationBloc,
  }) : super(const SocialLoginState()) {
    on<SocialLoginEvent>((event, emit) async {
      //Update the state with the event
      //Do not remove this line
      emit(state.copyWith(event: event));
      //
      if (event is GoogleLogin) {
        try {
          emit(state.copyWith(requestLoading: true));
          //Open google login dialog and get user details
          final user = await firebaseLoginRepository.signInWithGoogle();

          //Register the user with the backend
          final socialLoginResponse = await authRepository.socialLogin(
            firebaseUser: user!,
            socialRegistrationType: SocialRegistrationType.google,
          );

          //Existing user profile
          if (socialLoginResponse.isUserProfileCompleted) {
            final authenticatedUser =
                socialLoginResponse.authenticatedUserDetails!;
            //If user profile completed then login the user
            login(authenticatedUser);
            emit(state.copyWith(requestSuccess: true));
            return;
          } else {
            //New profile registration
            emit(state.copyWith(
              profileActionRequired: true,
              firebaseUser: user,
            ));
            return;
          }
        } catch (e) {
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          authenticationBloc.add(const LoggedOut());
          emit(state.copyWith(error: e.toString()));
        }
      } else if (event is FacebookLogin) {
        try {
          emit(state.copyWith(requestLoading: true));
          final user = await firebaseLoginRepository.signInWithFacebook();
          final socialLoginResponse = await authRepository.socialLogin(
            firebaseUser: user!,
            socialRegistrationType: SocialRegistrationType.facebook,
          );
          //Existing user profile
          if (socialLoginResponse.isUserProfileCompleted) {
            final authenticatedUser =
                socialLoginResponse.authenticatedUserDetails!;
            //If user profile completed then login the user
            login(authenticatedUser);

            return;
          } else {
            //New profile registration
            emit(state.copyWith(
              profileActionRequired: true,
              firebaseUser: user,
            ));
            return;
          }
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          authenticationBloc.add(const LoggedOut());
          emit(state.copyWith(error: e.toString()));
        }
      } else if (event is AppleLogin) {
        try {
          emit(state.copyWith(requestLoading: true));
          final user = await firebaseLoginRepository.signInWithApple();
          final socialLoginResponse = await authRepository.socialLogin(
            firebaseUser: user!,
            socialRegistrationType: SocialRegistrationType.apple,
          );
          if (socialLoginResponse.isUserProfileCompleted) {
            final authenticatedUser =
                socialLoginResponse.authenticatedUserDetails!;
            //If user profile completed then login the user
            login(authenticatedUser);
            emit(state.copyWith(requestSuccess: true));
            return;
          } else {
            //New profile registration
            emit(state.copyWith(
              profileActionRequired: true,
              firebaseUser: user,
            ));
          }
        } catch (e) {
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          authenticationBloc.add(const LoggedOut());
          emit(state.copyWith(error: e.toString()));
        }
      }
    });
  }

  ///Trigger the auth bloc to login
  void login(AuthenticatedUserDetails authenticatedUserDetails) {
    try {
      authenticationBloc.add(LoggedIn(
        accessToken: authenticatedUserDetails.accessToken,
        userId: authenticatedUserDetails.userId,
      ));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }
}
