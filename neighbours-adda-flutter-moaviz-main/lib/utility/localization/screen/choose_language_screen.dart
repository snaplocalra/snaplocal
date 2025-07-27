import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/logic/user_consent_handler/user_consent_handler_cubit.dart';
import 'package:snap_local/common/utils/introduction/helper/introduction_shared_pref.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/widget/language_card_widget.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool allowPop;
  const ChooseLanguageScreen({
    super.key,
    this.allowPop = false,
  });
  static const routeName = 'choose_language';

  @override
  Widget build(BuildContext context) {
    return LanguageChangeBuilder(builder: (context, state) {
      final logs = state.languagesModel.languages;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: ThemeAppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text(
            tr(LocaleKeys.chooseLanguage),
            style: TextStyle(
              color: ApplicationColours.themeBlueColor,
              fontSize: 20,
            ),
          ),
        ),
        // appBar: ThemeAppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0.5,
        //   showBackButton: allowPop,
        //   onPop: () async {
        //     GoRouter.of(context).pop();
        //     return null;
        //   },
        //   titleSpacing: 10,
        //   title: Text(
        //     tr(LocaleKeys.chooseLanguage),
        //     style: TextStyle(
        //       color: ApplicationColours.themeBlueColor,
        //       fontSize: 20,
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                tr(LocaleKeys.chooseLanguageDescription),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(162, 167, 185, 1),
                ),
              ),
            ),
            Expanded(
              child: (logs.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          "No language found",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        ThemeElevatedButton(
                          buttonName: tr(LocaleKeys.goBack),
                          onPressed: () => GoRouter.of(context).pop(),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              crossAxisCount:
                                  2, // Change this value as per your need
                              childAspectRatio:
                                  4 / 2, // Change this value as per your need
                            ),
                            itemCount: logs.length,
                            itemBuilder: (context, index) => LanguageCardWidget(
                              languageModel: logs[index],
                              onTap: (selectedLanguage) async {
                                if (!selectedLanguage.isSelected) {
                                  await EasyLocalization.of(context)
                                      ?.setLocale(
                                          selectedLanguage.languageEnum.locale)
                                      .whenComplete(
                                        () => context
                                            .read<
                                                LanguageChangeControllerCubit>()
                                            .selectLanguage(selectedLanguage),
                                      );
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SafeArea(
                            child: ThemeElevatedButton(
                              buttonName: tr(LocaleKeys.continueButton),
                              onPressed: () async {
                                if (allowPop) {
                                  GoRouter.of(context).pop();
                                } else {
                                  await IntroductionSharedPref()
                                      .setInitialChooseLanguageComplete()
                                      .then(
                                        (value) => context
                                            .read<UserConsentHandlerCubit>()
                                            .checkLanguageAndAgreement(),
                                      );
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}
