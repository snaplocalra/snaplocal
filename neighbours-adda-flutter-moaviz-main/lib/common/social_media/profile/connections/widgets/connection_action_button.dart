import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ConnectionActionButton extends StatelessWidget {
  const ConnectionActionButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.showLoadingSpinner = false,
    this.disableButton = false,
    this.backgroundColor,
    this.foregroundColor,
    this.textFontSize = 12,
    this.height,
    this.flex = 1,
    this.prefixSvg,
    this.prefixSvgColour,
    this.prefixSvgSize,
  });

  final String? prefixSvg;
  final Color? prefixSvgColour;
  final double? prefixSvgSize;
  final String buttonName;
  final bool showLoadingSpinner;
  final bool disableButton;
  final double textFontSize;
  final double? height;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ThemeElevatedButton(
          showLoadingSpinner: showLoadingSpinner,
          disableButton: disableButton,
          buttonName: tr(buttonName),
          height: height ?? mqSize.height * 0.04,
          padding: EdgeInsets.zero,
          textFontSize: textFontSize,
          backgroundColor: backgroundColor ?? ApplicationColours.themeBlueColor,
          foregroundColor: foregroundColor ?? Colors.white,
          onPressed: onPressed,
          prefix: prefixSvg != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SvgPicture.asset(prefixSvg!,
                      height: prefixSvgSize ?? 12,
                      width: prefixSvgSize ?? 12,
                      colorFilter: ColorFilter.mode(
                        prefixSvgColour ?? Colors.white,
                        BlendMode.srcIn,
                      )),
                )
              : null,
        ),
      ),
    );
  }
}
