import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class CategoryChips extends StatelessWidget {
  final String text;
  final double horizontalPadding;
  final double verticalPadding;
  final double radius;
  final String? imageUrl;
  final bool isSelected;
  final bool enableShadow;
  final bool enableborder;
  final bool expandText;
  final void Function()? onTap;
  final Color? unselectedBackgroundColor;
  final Color? unselectedForegroundColor;

  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color borderColor;
  final double fontSize;
  final double imageHeight;
  const CategoryChips({
    super.key,
    required this.text,
    this.isSelected = false,
    this.enableShadow = false,
    this.enableborder = false,
    this.expandText = false,
    this.horizontalPadding = 20,
    this.verticalPadding = 10,
    this.radius = 10,
    this.imageUrl,
    this.onTap,
    this.unselectedBackgroundColor,
    this.unselectedForegroundColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.borderColor = Colors.grey,
    this.fontSize = 12,
    this.imageHeight = 20,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: isSelected
            ? selectedForegroundColor ?? Colors.white
            : unselectedForegroundColor ?? Colors.black,
      ),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          border: enableborder
              ? Border.all(
                  width: 0.5,
                  color: borderColor,
                )
              : null,
          boxShadow: enableShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 3,
                    // changes position of shadow
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          borderRadius: BorderRadius.circular(radius),
          color: isSelected
              ? selectedBackgroundColor ?? ApplicationColours.themeBlueColor
              : unselectedBackgroundColor ?? Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CachedNetworkImage(
                  cacheKey: imageUrl!,
                  imageUrl: imageUrl!,
                  fit: BoxFit.scaleDown,
                  height: imageHeight,
                ),
              ),
            expandText ? Expanded(child: textWidget) : textWidget,
          ],
        ),
      ),
    );
  }
}
