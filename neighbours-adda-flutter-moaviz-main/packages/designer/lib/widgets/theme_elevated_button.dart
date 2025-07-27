import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';

class ThemeElevatedButton extends StatelessWidget {
  final String buttonName;
  final Widget? suffix;
  final Widget? prefix;
  final bool showLoadingSpinner;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final double textFontSize;
  final double loadingSpinnerSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool disableButton;
  const ThemeElevatedButton({
    super.key,
    this.showLoadingSpinner = false,
    this.disableButton = false,
    required this.buttonName,
    this.suffix,
    this.prefix,
    this.onPressed,
    this.textFontSize = 15,
    this.loadingSpinnerSize = 30,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height ?? 50,
        width: width ?? double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(
                disableButton ? Colors.grey : backgroundColor),
            foregroundColor: WidgetStateProperty.all(foregroundColor),
          ),
          onPressed: disableButton
              ? null
              : () {
                  if (onPressed != null && !showLoadingSpinner) {
                    onPressed!.call();
                  }
                },
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
            child: showLoadingSpinner
                ? ThemeSpinner(
                    color: foregroundColor ?? Colors.white,
                    size: loadingSpinnerSize,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefix != null) prefix!,
                      Text(
                        buttonName,
                        style: TextStyle(
                          color: foregroundColor ?? Colors.white,
                          fontSize: textFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (suffix != null) suffix!,
                    ],
                  ),
          ),
        ),
      );
}
