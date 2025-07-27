import 'package:designer/widgets/loading_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_handler/logic/internet/internet_cubit.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/authentication/screens/choose_authentication_method_screen.dart';
import 'package:snap_local/bottom_bar/logic/user_consent_handler/user_consent_handler_cubit.dart';
import 'package:snap_local/bottom_bar/screen/bottom_bar.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_cubit.dart';
import 'package:snap_local/onboarding/screens/onboarding_screen.dart';
import 'package:snap_local/splash/splash_controller/splash_controller_cubit.dart';
import 'package:snap_local/splash/splash_screen.dart';
import 'package:snap_local/utility/application_version_checker/logic/application_version_checker/application_version_checker_cubit.dart';
import 'package:snap_local/utility/application_version_checker/screen/critical_update_screen.dart';
import 'package:snap_local/utility/application_version_checker/widget/update_application_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/screen/choose_language_screen.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  static const routeName = '/';

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  void initState() {
    super.initState();

    // Fetch the languages
    context.read<LanguageKnownCubit>().fetchLanguages();

    // Wait for the widget to build before setting the saved language
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Set the saved language
      await context
          .read<LanguageChangeControllerCubit>()
          .setSavedLanguage(context.locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetCubit, InternetState>(
        listener: (context, internetState) {
      //pop to the 1st route
      if (internetState.disconnected) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }, builder: (context, internetState) {
      if (internetState.loading) {
        return const LoadingScreen();
      } else if (internetState.connected) {
        return BlocBuilder<SplashControllerCubit, SplashControllerState>(
          builder: (context, splashState) {
            if (splashState.loadSplash) {
              return const LoadingScreen();
            } else if (splashState.showSplash) {
              return SplashScreen(isRegularOpen: splashState.isRegularOpen);
            } else {
              return BlocConsumer<ApplicationVersionCheckerCubit,
                  ApplicationVersionCheckerState>(
                listener: (context, applicationVersionCheckState) {
                  if (applicationVersionCheckState is NormalUpdateFound) {
                    showUpdateApplicationDialog(
                      context: context,
                      applicationDownloadLink:
                          applicationVersionCheckState.applicationDownloadLink,
                    );
                  }
                },
                builder: (context, applicationVersionCheckState) {
                  switch (applicationVersionCheckState) {
                    case CriticalUpdateFound _:
                      return CriticalUpdateScreen(
                        applicationDownloadLink: applicationVersionCheckState
                            .applicationDownloadLink,
                      );

                    case ApplicationVersionCheckError _:
                      return ScaffoldErrorTextWidget(
                        error: applicationVersionCheckState.error,
                      );
                    case ApplicationVersionCheckingLoading _:
                      return const LoadingScreen();

                    case NoUpdateFound _:
                    default:
                      //Application data stack
                      return BlocBuilder<UserConsentHandlerCubit,
                          UserConsentHandlerState>(
                        builder: (context, userConsentHandlerState) {
                          if (userConsentHandlerState.loading) {
                            return const LoadingScreen();
                          } else if (!userConsentHandlerState
                              .languageSelected) {
                            return const ChooseLanguageScreen();
                          } else {
                            return BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(
                              builder: (context, state) {
                                if (state is AuthenticationUnauthenticated) {
                                  return const ChooseAuthenticationMethodScreen();
                                } else if (state
                                    is AuthenticationAuthenticated) {
                                  return  BottomBar();
                                } else if (state is OnBoarding) {
                                  return const OnboardingScreen();
                                } else {
                                  return const LoadingScreen(
                                    waitingText: "Please wait..",
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                  }
                },
              );
            }
          },
        );
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  SVGAssetsImages.noInternet,
                  height: 250,
                ),
                const SizedBox(height: 20),
                Text(
                  tr(LocaleKeys.noInternetConnection),
                  style: TextStyle(
                    color: ApplicationColours.themeBlueColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
