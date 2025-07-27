// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ThemeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final double? elevation;
  final double? appBarHeight;
  final Widget? flexibleSpace;
  final Widget? bottom;
  final Future<bool?> Function()? onPop;
  final bool showBackButton;
  final bool enableBackButtonBackground;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? leadingColor;
  final bool? centerTitle;
  final double? titleSpacing;
  const ThemeAppBar({
    super.key,
    this.title,
    this.elevation,
    this.appBarHeight,
    this.onPop,
    this.showBackButton = true,
    this.actions,
    this.flexibleSpace,
    this.backgroundColor,
    this.leadingColor,
    this.bottom,
    this.titleSpacing = 0,
    this.centerTitle = false,
    this.enableBackButtonBackground = false,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(appBarHeight ?? AppBar().preferredSize.height);

  @override
  PreferredSizeWidget build(BuildContext context) => AppBar(
        elevation: elevation ?? 0,
        title: title,
        titleSpacing: titleSpacing,
        centerTitle: centerTitle,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: backgroundColor ?? Colors.transparent,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IOSBackButton(
                onPop: onPop,
                enableBackground: enableBackButtonBackground,
              )
            : null,
        flexibleSpace: flexibleSpace,
        actions: actions,
        bottom: bottom != null
            ? PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child: bottom!,
              )
            : null,
      );
}

class IOSBackButton extends StatelessWidget {
  final bool enableBackground;
  final Future<bool?> Function()? onPop;
  final double? iconSize;
  final double? circleSize;

  const IOSBackButton({
    super.key,
    this.enableBackground = true,
    this.onPop,
    this.iconSize,
    this.circleSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool allowPop = true;
        if (onPop != null) {
          await onPop!().then((value) {
            if (value != null) {
              allowPop = value;
            }
          });
        }
        if (allowPop && GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        }
      },
      child: enableBackground
          ? Container(
              margin: const EdgeInsets.all(10),
              height: circleSize ?? 20,
              width: circleSize ?? 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: iconSize ?? 15,
                color: ApplicationColours.themeBlueColor,
              ),
            )
          : Icon(
              Icons.arrow_back_ios_new,
              size: iconSize ?? 20,
              color: ApplicationColours.themeBlueColor,
            ),
    );
  }
}
