// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class CircularTick extends StatelessWidget {
  final bool showTick;
  final bool enablePlaceHolder;
  final double? tickSize;
  final double? placeHolderHeight;
  final double? placeHolderWidth;
  const CircularTick({
    super.key,
    this.showTick = false,
    this.enablePlaceHolder = false,
    this.tickSize,
    this.placeHolderHeight,
    this.placeHolderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(showTick || enablePlaceHolder ? 2 : 0),
      decoration: BoxDecoration(
        color: showTick ? Theme.of(context).primaryColor : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: showTick
              ? Theme.of(context).primaryColor
              : const Color.fromRGBO(214, 214, 214, 1),
          width: enablePlaceHolder ? 1 : 0,
        ),
      ),
      child: showTick
          ? Icon(
              FeatherIcons.check,
              color: Colors.white,
              size: tickSize,
            )
          : enablePlaceHolder
              ? SizedBox(
                  height: placeHolderHeight,
                  width: placeHolderWidth,
                )
              : const SizedBox.shrink(),
    );
  }
}
