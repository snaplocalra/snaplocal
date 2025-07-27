import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/application_version_checker/logic/application_version_checker/application_version_checker_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class UpdateApplicationWidget extends StatelessWidget {
  final String applicationDownloadLink;
  final bool showSkipButton;
  const UpdateApplicationWidget({
    super.key,
    required this.applicationDownloadLink,
    this.showSkipButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * (showSkipButton ? 0.24 : 0.2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top:
                -50, // Adjust this value to position the CircleAvatar as desired
            left: 0,
            right: 0,
            child: CircleAvatar(
              // Add your circular logo here
              radius: 50,
              backgroundColor: Colors
                  .white, // This ensures the background color is transparent
              child: ClipOval(
                child: Image.asset(
                  PNGAssetsImages.logo,
                  fit:
                      BoxFit.cover, // Adjust the fit to cover the entire circle
                  width: 100, // Adjust width as needed
                  height: 100, // Adjust height as needed
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tr(LocaleKeys.updateAppMessage),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(200, 8, 128, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ThemeElevatedButton(
                    buttonName: tr(LocaleKeys.update),
                    onPressed: () {
                      context
                          .read<ApplicationVersionCheckerCubit>()
                          .updateApplciation(
                              applciationDownloadLink: applicationDownloadLink);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    width: 96,
                    height: 35,
                    borderRadius: 8,
                    textFontSize: 12,
                    padding: EdgeInsets.zero,
                    backgroundColor: ApplicationColours.themeLightPinkColor,
                  ),
                  if (showSkipButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          tr(LocaleKeys.skip),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color.fromRGBO(0, 25, 104, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Add other widgets below the CircleAvatar if needed
        ],
      ),
    );
  }
}

void showUpdateApplicationDialog({
  required BuildContext context,
  required String applicationDownloadLink,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: UpdateApplicationWidget(
        applicationDownloadLink: applicationDownloadLink,
      ),
    ),
  );
}
