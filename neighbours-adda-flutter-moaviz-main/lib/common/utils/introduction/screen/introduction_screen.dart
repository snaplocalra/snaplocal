import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/bottom_bar/logic/user_consent_handler/user_consent_handler_cubit.dart';
import 'package:snap_local/common/utils/introduction/helper/introduction_shared_pref.dart';
import 'package:snap_local/common/utils/introduction/widget/introduction_title_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class IntroductionScreen extends StatelessWidget {
  static const routeName = 'introduction';

  const IntroductionScreen({super.key});

  bool willPopScope() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: willPopScope(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(top: mqSize.height * 0.06),
          child: Column(
            children: [
              // SvgPicture.asset(
              //   SVGAssetsImages.logo,
              //   height: mqSize.height * 0.12,
              // ),
              Image.asset(
                PNGAssetsImages.logo,
                height: mqSize.height * 0.12,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: IntroductionTitleWidget(),
              ),
              Expanded(child: SvgPicture.asset(SVGAssetsImages.introduction)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ThemeElevatedButton(
                  buttonName: tr(LocaleKeys.iAgree),
                  onPressed: () async {
                    await IntroductionSharedPref()
                        .setIntroductionComplete()
                        .then(
                          (value) => context
                              .read<UserConsentHandlerCubit>()
                              .checkLanguageAndAgreement(),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
