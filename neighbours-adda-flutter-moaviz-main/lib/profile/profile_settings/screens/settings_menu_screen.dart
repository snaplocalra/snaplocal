import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/screen/help_and_support_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/screen/saved_items_screen.dart';
import 'package:snap_local/profile/manage_profile_details/screens/edit_profile_screen.dart';
import 'package:snap_local/profile/profile_privacy/screens/profile_privacy_screen.dart';
import 'package:snap_local/profile/profile_settings/screens/profile_settings_screen.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/screen/choose_language_screen.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';
import 'package:snap_local/utility/tools/responsive.dart';

class SettingsMenuScreen extends StatefulWidget {
  const SettingsMenuScreen({super.key});

  static const routeName = 'settings_menu';

  @override
  State<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
  List<SettingMenuWidget> getMenuList() => [
        SettingMenuWidget(
          name: tr(LocaleKeys.editProfile),
          svgImagePath: SVGAssetsImages.editProfile,
          onTap: () {
            GoRouter.of(context).pushNamed(EditProfileScreen.routeName);
          },
        ),
        SettingMenuWidget(
          name: tr(LocaleKeys.editPrivacy),
          svgImagePath: SVGAssetsImages.editPrivacy,
          onTap: () {
            GoRouter.of(context).pushNamed(ProfilePrivacyScreen.routeName);
          },
        ),
        SettingMenuWidget(
          name: tr(LocaleKeys.accountSetting),
          svgImagePath: SVGAssetsImages.accountSetting,
          onTap: () {
            GoRouter.of(context).pushNamed(ProfileSettingsScreen.routeName);
          },
        ),
        SettingMenuWidget(
          name: tr(LocaleKeys.languageSetting),
          svgImagePath: SVGAssetsImages.languageSetting,
          onTap: () {
            GoRouter.of(context).pushNamed(ChooseLanguageScreen.routeName);
          },
        ),
        // SettingMenuWidget(
        //   name: tr(LocaleKeys.ourBlog),
        //   svgImagePath: SVGAssetsImages.ourBlog,
        //   onTap: () {
        //     comingSoon();
        //   },
        // ),
        SettingMenuWidget(
          name: tr(LocaleKeys.ourSupport),
          svgImagePath: SVGAssetsImages.helpAndSupport,
          onTap: () {
            GoRouter.of(context).pushNamed(HelpAndSupportScreen.routeName);
          },
        ),
        // SettingMenuWidget(
        //   name: tr(LocaleKeys.yourActivity),
        //   svgImagePath: SVGAssetsImages.yourActivity,
        //   onTap: () {
        //     comingSoon();
        //   },
        // ),
        SettingMenuWidget(
          name: tr(LocaleKeys.savedItems),
          svgImagePath: SVGAssetsImages.savedItems,
          onTap: () {
            GoRouter.of(context).pushNamed(SavedItemScreen.routeName);
          },
        ),
        // SettingMenuWidget(
        //   name: tr(LocaleKeys.userAnalytics),
        //   svgImagePath: SVGAssetsImages.userAnalytics,
        //   onTap: () {
        //     comingSoon();
        //   },
        // ),
      ];

  bool willPopScope(bool allowPop) {
    return allowPop;
  }

  @override
  Widget build(BuildContext context) {
    return LanguageChangeBuilder(builder: (context, _) {
      final menuList = getMenuList();
      return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authenticationState) {
          return PopScope(
            canPop:
                willPopScope(authenticationState != AuthenticationLoading()),
            child: Scaffold(
              appBar: ThemeAppBar(
                elevation: 2,
                backgroundColor: Colors.white,
                title: Text(
                  tr(LocaleKeys.settings),
                  style: TextStyle(
                    color: ApplicationColours.themeBlueColor,
                    fontSize: 18,
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        crossAxisCount: Responsive.isDesktop(context)
                            ? 6
                            : Responsive.isTablet(context)
                                ? 4
                                : 2,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        final menu = menuList[index];
                        return menu;
                      },
                    ),
                  ),

                  //Logout Button
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SafeArea(
                      child: ThemeElevatedButton(
                        buttonName: tr(LocaleKeys.logout),
                        showLoadingSpinner:
                            authenticationState == AuthenticationLoading(),
                        onPressed: () {
                          if (mounted) {
                            context
                                .read<AuthenticationBloc>()
                                .add(const LoggedOut());
                          }
                        },
                      ),
                    ),
                  ),

                  //*******Warning*******
                  //This button is for pushing user to firebase only
                  //Do not use this button in production, this is only for development purpose
                  //Only developers allowed to use this button
                  // if (kDebugMode)
                  //   Padding(
                  //     padding: const EdgeInsets.all(10),
                  //     child: ThemeElevatedButton(
                  //       backgroundColor: Colors.amber,
                  //       foregroundColor: Colors.black,
                  //       buttonName: "Push user to firebase",
                  //       onPressed: () {
                  //         PushUserToFirebaseRepository()
                  //             .pushUserToFirebaseFromServer();
                  //       },
                  //     ),
                  //   ),
                  //*******Warning*******
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class SettingMenuWidget extends StatelessWidget {
  final String name;
  final String svgImagePath;
  final void Function() onTap;

  const SettingMenuWidget({
    super.key,
    required this.name,
    required this.svgImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(239, 239, 239, 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1,
              spreadRadius: 0,
              // Offset controls the position of the shadow
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  svgImagePath,
                  height: 35,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              tr(name),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
