import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_local/authentication/logic/social_login/social_login_bloc.dart';
import 'package:snap_local/authentication/widgets/choose_authentication_method_widgets/agreement_widget.dart';
import 'package:snap_local/authentication/widgets/choose_authentication_method_widgets/verify_user_widget.dart';
import 'package:snap_local/authentication/widgets/social_login_widget.dart';
import 'package:snap_local/utility/common/widgets/or_divider_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ChooseAuthenticationMethodScreen extends StatelessWidget {
  static const routeName = 'choose_authentication_option';

  const ChooseAuthenticationMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ListView(
            key: const Key("choose_authentication_option_listview"),
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: mqSize.height * 0.02,
                  left: mqSize.width * 0.06,
                ),
                child: Text(
                  tr(LocaleKeys.newWayToConnectWithYourNeighbourhood),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.teko(
                    fontSize: 30,
                    letterSpacing: 0.2,
                    wordSpacing: 0.2,
                    fontWeight: FontWeight.w500,
                    color: ApplicationColours.themeBlueColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SvgPicture.asset(
                  key: const Key("choose_authentication_svg_widget"),
                  SVGAssetsImages.chooseAuthOption,
                  height: mqSize.height * 0.35,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: VerifyUserWidget(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ORDivider(dividerThickness: 1),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: SocialLoginWidget(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: AgreementWidget(
                  agreemenFrom: AgreemenFrom.chooseAuthScreen,
                ),
              ),
            ],
          ),
          //Show loader for social login event
          BlocBuilder<SocialLoginBloc, SocialLoginState>(
            builder: (context, socialLoginState) {
              return Visibility(
                visible: socialLoginState.requestLoading,
                child: Container(
                  color: Colors.black45,
                  child: const ThemeSpinner(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
