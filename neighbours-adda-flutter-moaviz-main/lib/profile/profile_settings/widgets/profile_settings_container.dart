import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ProfileSettingContainer extends StatelessWidget {
  final String? heading;
  final Widget content;
  final String? buttonName;
  final EdgeInsetsGeometry? padding;
  final void Function()? buttonOnTap;

  const ProfileSettingContainer({
    super.key,
    this.heading,
    this.padding,
    required this.content,
    this.buttonName,
    this.buttonOnTap,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null)
            Text(
              tr(heading!),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 5),
            child: content,
          ),
          if (buttonOnTap != null && buttonName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: ThemeElevatedButton(
                buttonName: tr(buttonName!),
                onPressed: buttonOnTap,
                height: mqSize.height * 0.045,
                width: mqSize.width * 0.35,
                textFontSize: 10,
                backgroundColor: ApplicationColours.themeBlueColor,
                padding: EdgeInsets.zero,
              ),
            )
        ],
      ),
    );
  }
}
