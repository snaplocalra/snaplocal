import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:designer/widgets/loading_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/screens/business_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/screen/explore_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/screens/home_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/screen/news_list_screen.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_visibility/bottom_bar_visibility_cubit.dart';
import 'package:snap_local/bottom_bar/model/bottom_bar_model.dart';
import 'package:snap_local/bottom_bar/widget/bottom_bar_item_widget.dart';
import 'package:snap_local/bottom_bar/widget/more_button.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/logic/locale_from_location/locale_from_location_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/push_notification/firebase_messaging_service/util/notification_listener.dart';
import 'package:snap_local/utility/session_checker/logic/cubit/session_checker_cubit.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  final GlobalKey _moreButtonKey = GlobalKey();
  late AnimationController _hideBottomBarAnimationController;

  final List<BottomBarModel> bottomBarItems = [
    BottomBarModel(
      image: SVGAssetsImages.home,
      name: LocaleKeys.home,
    ),
    BottomBarModel(
      image: SVGAssetsImages.localNews,
      name: LocaleKeys.localNews,
    ),
    BottomBarModel(
      image: SVGAssetsImages.businesses,
      name: LocaleKeys.businesses,
    ),
    BottomBarModel(
      image: SVGAssetsImages.explore,
      name: LocaleKeys.explore,
    ),
  ];

  Widget _selectedScreen({required int selectedIndex}) {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        //news screen
        return const NewsListScreen();
      case 2:
        return const BusinessScreen(isRootNavigation: true);
      case 3:
        return const ExploreScreen();
      default:
        throw tr(LocaleKeys.invalid);
    }
  }

  @override
  void initState() {
    super.initState();

    //Listen to push notification
    PushNotificationHandler().listenToNotificaton(context);

    //Check session
    context.read<SessionCheckerCubit>().checkSession();

    // Listen to the language change controller cubit
    listenNewsLanguageChange();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Fetch profile details
      context.read<ManageProfileDetailsBloc>().add(FetchProfileDetails());

      //Fetch profile settings
      context.read<ProfileSettingsCubit>().fetchProfileSettings();

      //Bottom bar visibility animation
      _hideBottomBarAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      // Fetch the locale from the location
      context.read<LocaleFromLocationCubit>().getLocaleByLocation(
            //Assign the default locale
            defaultLocale: context
                .read<LanguageChangeControllerCubit>()
                .state
                .selectedLanguage
                .languageEnum
                .locale,
          );
    });
  }

  void listenNewsLanguageChange() {
    // Listen to the application language state change
    context
        .read<LanguageChangeControllerCubit>()
        .stream
        .listen((languageChangeControllerState) {
      if (mounted) {
        // Get the selected application language
        final applicationLanguage =
            languageChangeControllerState.selectedLanguage.languageEnum;
        final localeFromLocationState =
            context.read<LocaleFromLocationCubit>().state;
        if (localeFromLocationState is LocaleFromLocationLoaded) {
          context
              .read<NewsLanguageChangeControllerCubit>()
              .setDynamicNewsLanguage(
                applicationLanguage,
                localeFromLocationState.locale,
              );
        }
      }
    });

    // Listen to Locale From Location state change
    context
        .read<LocaleFromLocationCubit>()
        .stream
        .listen((localeFromLocationState) {
      if (localeFromLocationState is LocaleFromLocationLoaded && mounted) {
        // Set the dynamic news language
        context
            .read<NewsLanguageChangeControllerCubit>()
            .setDynamicNewsLanguage(
              context
                  .read<LanguageChangeControllerCubit>()
                  .state
                  .selectedLanguage
                  .languageEnum,
              localeFromLocationState.locale,
            );
      }
    });
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCheckerCubit, SessionCheckerState>(
      listener: (context, sessionCheckerState) {
        if (!sessionCheckerState.isSessionValid) {
          context.read<AuthenticationBloc>().add(const LoggedOut());
        }
      },
      builder: (context, sessionCheckerState) {
        if (sessionCheckerState.isLoading) {
          return const LoadingScreen();
        } else {
          return BlocConsumer<BottomBarVisibilityCubit,
              BottomBarVisibilityState>(
            listener: (context, bottomBarVisibilityState) {
              if (bottomBarVisibilityState.visible) {
                _hideBottomBarAnimationController.reverse();
              } else {
                _hideBottomBarAnimationController.forward();
              }
            },
            builder: (context, bottomBarVisibilityState) {
              return BlocBuilder<BottomBarNavigatorCubit,
                  BottomBarNavigatorState>(
                buildWhen: (previous, current) {
                  return previous.currentSelectedScreenIndex !=
                      current.currentSelectedScreenIndex;
                },
                builder: (context, bottomBarState) {
                  return WillPopScope(
                    onWillPop: () async {
                      final currentIndex = context
                          .read<BottomBarNavigatorCubit>()
                          .state
                          .currentSelectedScreenIndex;

                      if (currentIndex > 0) {
                        context.read<BottomBarNavigatorCubit>().changeScreen(selectedIndex: 0);
                        return false;
                      } else {
                        final shouldExit = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(tr(LocaleKeys.exitApp)),
                            //content: Text(tr(LocaleKeys.exitConfirmation)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(tr(LocaleKeys.no)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text(tr(LocaleKeys.yes)),
                              ),
                            ],
                          ),
                        );

                        if (shouldExit == true) {
                          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                          return false; // prevent default pop behavior (already handled)
                        }
                        return false;
                      }
                    },
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                      floatingActionButton: bottomBarVisibilityState.visible
                          ? MoreButton(
                        isSelected: bottomBarState.currentSelectedScreenIndex == 4,
                      )
                          : null,
                      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                        hideAnimationController: _hideBottomBarAnimationController,
                        hideAnimationCurve: Curves.easeInOutSine,
                        itemCount: bottomBarItems.length,
                        activeIndex: bottomBarState.currentSelectedScreenIndex,
                        gapLocation: GapLocation.center,
                        notchSmoothness: NotchSmoothness.defaultEdge,
                        notchMargin: 5,
                        height: 60,
                        onTap: (selectedIndex) {
                          context
                              .read<BottomBarNavigatorCubit>()
                              .changeScreen(selectedIndex: selectedIndex);
                        },
                        tabBuilder: (index, isActive) {
                          return BottomBarItem(
                            bottomBarModel: bottomBarItems[index],
                            isSelected: isActive,
                          );
                        },
                      ),
                      body: _selectedScreen(
                        selectedIndex: bottomBarState.currentSelectedScreenIndex,
                      ),
                    ),
                  );


                  //   PopScope(
                  //   canPop: false,
                  //   onPopInvokedWithResult: (val,d) async {
                  //     print('Back button pressed');
                  //     //return false;
                  //
                  //     final currentIndex = context
                  //         .read<BottomBarNavigatorCubit>()
                  //         .state
                  //         .currentSelectedScreenIndex;
                  //
                  //     if (currentIndex > 0) {
                  //       // If not on the home tab, navigate to the home tab
                  //       context
                  //           .read<BottomBarNavigatorCubit>()
                  //           .changeScreen(selectedIndex: 0);
                  //       //return false;
                  //     }
                  //     else {
                  //       // Show exit confirmation dialog when on the home tab
                  //     showDialog(
                  //           context: context,
                  //           builder: (context) => AlertDialog(
                  //             title: Text(tr(LocaleKeys.exitApp)),
                  //             content: Text(tr(LocaleKeys.exitConfirmation)),
                  //             actions: [
                  //               TextButton(
                  //                 onPressed: () =>
                  //                     Navigator.of(context).pop(false),
                  //                 child: Text(tr(LocaleKeys.cancel)),
                  //               ),
                  //               TextButton(
                  //                 onPressed: () => Navigator.of(context).pop(true),
                  //                 child: Text(tr(LocaleKeys.exit)),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //     }
                  //   },
                  //   child: Scaffold(
                  //     resizeToAvoidBottomInset: false,
                  //     floatingActionButtonLocation:
                  //         FloatingActionButtonLocation.centerDocked,
                  //     floatingActionButton: bottomBarVisibilityState.visible
                  //         ? MoreButton(
                  //             isSelected: bottomBarState
                  //                     .currentSelectedScreenIndex ==
                  //                 4,
                  //           )
                  //         : null,
                  //     bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                  //       hideAnimationController:
                  //           _hideBottomBarAnimationController,
                  //       hideAnimationCurve: Curves.easeInOutSine,
                  //       itemCount: bottomBarItems.length,
                  //       activeIndex:
                  //           bottomBarState.currentSelectedScreenIndex,
                  //       gapLocation: GapLocation.center,
                  //       notchSmoothness: NotchSmoothness.defaultEdge,
                  //       notchMargin: 5,
                  //       height: 60,
                  //       onTap: (selectedIndex) {
                  //         context
                  //             .read<BottomBarNavigatorCubit>()
                  //             .changeScreen(selectedIndex: selectedIndex);
                  //       },
                  //       tabBuilder: (index, isActive) {
                  //         return BottomBarItem(
                  //           bottomBarModel: bottomBarItems[index],
                  //           isSelected: isActive,
                  //         );
                  //       },
                  //     ),
                  //     body: _selectedScreen(
                  //       selectedIndex:
                  //           bottomBarState.currentSelectedScreenIndex,
                  //     ),
                  //   ),
                  // );
                },
              );
            },
          );
        }
      },
    );
  }
}
