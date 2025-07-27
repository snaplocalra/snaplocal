import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConnectionActionButtonV2 extends StatelessWidget {
  const ConnectionActionButtonV2({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.showLoadingSpinner = false,
    this.disableButton = false,
    this.backgroundColor,
    this.foregroundColor,
    this.textFontSize = 11,
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

  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: showLoadingSpinner || disableButton ? null : onPressed,
        child: Container(
          alignment: Alignment.center,
          height: mqSize.height * 0.04,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.blueAccent.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: backgroundColor?.withOpacity(0.8) ??
                    Colors.blueAccent.shade400,
                spreadRadius: 0,
                blurRadius: 0,
                offset:
                    const Offset(0, 3), // changes the position of the shadow
              ),
            ],
          ),
          child: showLoadingSpinner
              ? const ThemeSpinner(
                  size: 25,
                  color: Colors.white,
                )
              : Text(
                  tr(buttonName),
                  style: TextStyle(
                    color: foregroundColor ?? Colors.white,
                    fontSize: textFontSize,
                  ),
                ),

          //  Padding(
          //   padding: const EdgeInsets.only(right: 8),
          //   child: ThemeElevatedButton(
          //     showLoadingSpinner: showLoadingSpinner,
          //     disableButton: disableButton,
          //     buttonName: tr(buttonName),
          //     height: height ?? mqSize.height * 0.04,
          //     padding: EdgeInsets.zero,
          //     textFontSize: textFontSize,
          //     backgroundColor: backgroundColor ?? Colors.blue.shade500,
          //     foregroundColor: foregroundColor ?? Colors.white,
          //     onPressed: onPressed,
          //     prefix: prefixSvg != null
          //         ? Padding(
          //             padding: const EdgeInsets.only(right: 5),
          //             child: SvgPicture.asset(prefixSvg!,
          //                 height: prefixSvgSize ?? 12,
          //                 width: prefixSvgSize ?? 12,
          //                 colorFilter: ColorFilter.mode(
          //                   prefixSvgColour ?? Colors.white,
          //                   BlendMode.srcIn,
          //                 )),
          //           )
          //         : null,
          //   ),
          // ),
        ),
      ),
    );
  }
}
