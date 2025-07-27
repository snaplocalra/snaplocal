import 'dart:io';

import 'package:designer/utility/theme_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/logic/social_login/social_login_bloc.dart';
import 'package:snap_local/authentication/models/signup_screen_payload.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/signup_screen.dart';
import 'package:snap_local/authentication/widgets/choose_authentication_method_widgets/social_login_button.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialLoginBloc, SocialLoginState>(
      listener: (context, socialLoginState) {
        if (socialLoginState.error != null) {
          //show snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              socialLoginState.error!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        } else if (socialLoginState.profileActionRequired &&
            socialLoginState.firebaseUser != null &&
            socialLoginState.event != null) {
          final payLoad = SocialLoginPayload(
            user: socialLoginState.firebaseUser!,
            loginEvent: socialLoginState.event!,
          );

          if (!payLoad.emailAvailable) {
            ThemeToast.errorToast(tr(LocaleKeys.emailNotFound));
            return;
          } else if (socialLoginState.profileActionRequired) {
            //In facebook login, we need to check the email and phone number
            //If email is not available, then we will take the phone number

            GoRouter.of(context).pushNamed(
              SignupScreen.routeName,
              extra: payLoad,
            );
          }
        }
      },
      builder: (context, socialLoginState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              key: const Key("google_login_button"),
              disable: socialLoginState.requestLoading,
              svgImage: SVGAssetsImages.googleLogin,
              onTap: () async {
                context.read<SocialLoginBloc>().add(GoogleLogin());
              },
            ),
            Visibility(
              visible: Platform.isIOS,
              child: SocialLoginButton(
                key: const Key("apple_login_button"),
                size: 44,
                enableBorder: true,
                disable: socialLoginState.requestLoading,
                svgImage: SVGAssetsImages.appleLogin,
                onTap: () async {
                  context.read<SocialLoginBloc>().add(AppleLogin());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
