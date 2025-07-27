import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/bottom_bar/model/bottom_bar_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class BottomBarItem extends StatelessWidget {
  final BottomBarModel bottomBarModel;
  final bool isSelected;
  final bool isCenterButton;

  const BottomBarItem({
    super.key,
    required this.bottomBarModel,
    this.isSelected = false,
    this.isCenterButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          bottomBarModel.image,
          height: 25,
          width: 25,
          colorFilter: isSelected
              ? ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                )
              : ColorFilter.mode(
                  isCenterButton
                      ? Colors.white
                      : ApplicationColours.themeBlueColor,
                  BlendMode.srcIn,
                ),
        ),
        const SizedBox(height: 5),
        Text(
          tr(bottomBarModel.name),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            color: isCenterButton
                ? Colors.white
                : isSelected
                    ? Theme.of(context).primaryColor
                    : ApplicationColours.themeBlueColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
