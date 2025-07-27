import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/constant/names.dart';


class FirebaseLoginRepository {
  final firebaseAuth = FirebaseAuth.instance;

  String _randomNonceString({int length = 32}) {
    assert(length > 0);

    // Generate random bytes
    final random = Random.secure();
    final randomBytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      randomBytes[i] = random.nextInt(256);
    }

    // Character set to use in the nonce
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    // Convert random bytes to a string using the character set
    final nonce = String.fromCharCodes(randomBytes.map((byte) {
      return charset.codeUnitAt(byte % charset.length);
    }));

    return nonce;
  }

  String _createHashSHA256String(String input) {
    // Convert the input string to a list of bytes
    final bytes = utf8.encode(input);

    // Create the SHA-256 hash of the bytes
    final digest = sha256.convert(bytes);

    // Convert the hash to a hexadecimal string
    return digest.toString();
  }

  Future<void> anonymousLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      late String error;
      switch (e.code) {
        case "operation-not-allowed":
          error = "Anonymous auth hasn't been enabled for $applicationName.";
          break;
        default:
          error = "Unknown error.";
      }
      throw (error);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      throw ("Login cancelled");
    }
  }

  Future<User?> signInWithApple() async {
    try {
      if (await SignInWithApple.isAvailable()) {
        const appleClientID =
            isProduction ? 'com.snaplocal.app' : 'com.cm.neighboursadda';
        const appleSignInRedirectLink =
            'https://neighboursadda-11bb0.firebaseapp.com/__/auth/handler';

        //Raw nonce
        final rawNonce = _randomNonceString();

        // Create a SHA-256 hash of the nonce. Consider using the `crypto` package from the pub.dev registry.
        String hashSHA256String = _createHashSHA256String(rawNonce);

        // 1. perform the sign-in request
        final signInCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: appleClientID,
            redirectUri: Uri.parse(appleSignInRedirectLink),
          ),
          nonce: hashSHA256String,
        );

        // 2. check the result
        if (signInCredential.identityToken != null) {
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: signInCredential.identityToken!,
            accessToken: signInCredential.authorizationCode,
            rawNonce: rawNonce,
          );

          final userCredential =
              await firebaseAuth.signInWithCredential(credential);

          //if user full name is available then update the user instance
          if (signInCredential.givenName != null &&
              signInCredential.familyName != null) {
            await userCredential.user!.updateDisplayName(
              "${signInCredential.givenName} ${signInCredential.familyName}",
            );
          } else if (signInCredential.givenName != null) {
            await userCredential.user!.updateDisplayName(
              "${signInCredential.givenName}",
            );
          } else if (signInCredential.familyName != null) {
            await userCredential.user!.updateDisplayName(
              "${signInCredential.familyName}",
            );
          }
          return userCredential.user;
        }
      } else {
        throw ("Apple login not available");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (e is FirebaseAuthException) {
        if (e.message != null) {
          throw Exception(e.message!);
        }
      } else if (e is AssertionError) {
        throw ("Login canceled");
      } else {
        rethrow;
      }
    }
    return null;
  }

  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString)
              as FacebookAuthCredential;

      // Once signed in, return the User
      final userCredential =
          await firebaseAuth.signInWithCredential(facebookAuthCredential);

      return userCredential.user;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (e is FirebaseAuthException) {
        if (e.message != null) {
          throw Exception(e.message!);
        }
      } else if (e is AssertionError) {
        throw ("Login canceled");
      } else {
        rethrow;
      }
    }
    return null;
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
